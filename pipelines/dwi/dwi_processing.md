# DWI Processing
## Output:
```
${researcher}/${project}/derivatives/dwi/scalar
  ∟sub-${subject}_ses-${session}_*_Scalar_*.nii.gz
```
## Code:
```bash
#------------------------------------------------------------------------------
# set up software
#------------------------------------------------------------------------------
nimg_core_root=/Shared/nopoulos/nimg_core
source /Shared/pinc/sharedopt/apps/sourcefiles/afni_source.sh
afni_version=${AFNIDIR##*/}
source /Shared/pinc/sharedopt/apps/sourcefiles/ants_source.sh
ants_version=$(echo "${ANTSPATH}" | cut -d "/" -f9)
fsl_version=6.0.0_multicore
source /Shared/pinc/sharedopt/apps/sourcefiles/fsl_source.sh ${fsl_version}


#------------------------------------------------------------------------------
# specify analysis variables
#------------------------------------------------------------------------------
researcher=~/Desktop
project=HarshmanTest
subject=CKD02
session=2pnytnt0zp
site=00100
space=HCPNOBS1
template=1mm
prefix=sub-${subject}_ses-${session}_site-${site}

#------------------------------------------------------------------------------
# Initialize Output Folders
#------------------------------------------------------------------------------
dir_template=${nimg_core_root}/templates_human
dir_raw=${researcher}/${project}/nifti/sub-${subject}/ses-${session}/dwi
dir_anat_native=${researcher}/${project}/derivatives/anat/native
dir_xfm=${researcher}/${project}/derivatives/xfm/sub-${subject}/ses-${session}
dir_prep=${researcher}/${project}/derivatives/dwi/prep/sub-${subject}/ses-${session}
dir_scalar=${researcher}/${project}/derivatives/dwi/scalar

dir_corrected=${researcher}/${project}/derivatives/dwi/corrected
dir_native_scalars=${researcher}/${project}/derivatives/dwi/scalars_native/sub-${subject}/ses-${session}/
dir_template_scalars=${researcher}/${project}/derivatives/dwi/scalars_${space}_${template}

mkdir -p ${dir_prep}
mkdir -p ${dir_corrected}
mkdir -p ${dir_template_scalars}
mkdir -p ${dir_native_scalars}
#------------------------------------------------------------------------------
# 1. B0 Extraction, Topup Prep
#------------------------------------------------------------------------------

rm ${dir_prep}/*.nii.gz \
  ${dir_prep}/*.bval \
  ${dir_prep}/*.bvec \
  ${dir_prep}/*.json \
  ${dir_prep}/*.txt

cp ${dir_raw}/*.* ${dir_prep}/

unset allDwiNames B0s
declare -a allDwiNames
declare -a B0s
for i in ${dir_prep}/*_dwi.nii.gz; do
  unset dtiName B0s numB0s PEDstring PEDSTRING PED EESstring EES AcqMPEstring AcqMPE readoutTime
  dtiName=${i::-11}
  B0s=($(cat ${dtiName}_dwi.bval))
  numB0s=0
  PEDstring=$(grep '"PhaseEncodingDirection"' ${dtiName}_dwi.json | awk '{print $2}')
  PEDSTRING=${PEDstring::-4}
  if [ -z $PEDSTRING ]; then
    PED=1
  else
    PED=-1
  fi
  EESstring=$(grep '"EffectiveEchoSpacing"' ${dtiName}_dwi.json | awk '{print $2}')
  EES=${EESstring::-1}
  AcqMPEstring=$(grep '"AcquisitionMatrixPE"' ${dtiName}_dwi.json | awk '{print $2}')
  AcqMPE=${AcqMPEstring::-1}
  readoutTime=$(echo "${EES} * ((${AcqMPE} / 2) - 1)" | bc -l)
  touch ${dtiName}_B0sAcqParams.txt
  for j in "${B0s[@]}"; do
    if [ $j -eq 0 ]; then
      let numB0s=numB0s+1;
      echo "0 ${PED} 0 ${readoutTime}" >> ${dtiName}_B0sAcqParams.txt
    fi
  done
  fslroi ${i} ${dtiName}_b0.nii.gz 0 ${numB0s}
  allDwiNames+=(${dtiName})
done

rm ${dir_prep}/All_dwisAcqParams.txt ${dir_prep}/All.bvec ${dir_prep}/All.bval ${dir_prep}/All_index.txt
rm ${dir_prep}/XVals.txt ${dir_prep}/YVals.txt ${dir_prep}/ZVals.txt
unset acqLine indx TotalBVals TotalXVals TotalYVals TotalZVals
acqLine=1
indx=""
TotalBVals=""
TotalXVals=""
TotalYVals=""
TotalZVals=""
touch ${dir_prep}/All_dwisAcqParams.txt

for i in ${allDwiNames[@]}; do
  unset BVals XVals YVals ZVals PEDstring PEDSTRING PED EESstring EES AcqMPEstring AcqMPE readoutTime
  BVals=($(cat ${i}_dwi.bval))
  for j in "${BVals[@]}"; do
    indx="${indx} ${acqLine}"
  done
  XVals=($(sed "1q;d" ${i}_dwi.bvec))
  YVals=($(sed "2q;d" ${i}_dwi.bvec))
  ZVals=($(sed "3q;d" ${i}_dwi.bvec))
  TotalBVals="${TotalBVals} ${BVals[@]}"
  echo $TotalBVals
  TotalXVals="${TotalXVals} ${XVals[@]}"
  TotalYVals="${TotalYVals} ${YVals[@]}"
  TotalZVals="${TotalZVals} ${ZVals[@]}"
  PEDstring=$(grep '"PhaseEncodingDirection"' ${i}_dwi.json | awk '{print $2}')
  PEDSTRING=${PEDstring::-4}
  if [ -z $PEDSTRING ]; then
    PED=1
  else
    PED=-1
  fi
  EESstring=$(grep '"EffectiveEchoSpacing"' ${i}_dwi.json | awk '{print $2}')
  EES=${EESstring::-1}
  AcqMPEstring=$(grep '"AcquisitionMatrixPE"' ${i}_dwi.json | awk '{print $2}')
  AcqMPE=${AcqMPEstring::-1}
  readoutTime=$(echo "${EES} * ((${AcqMPE} / 2) - 1)" | bc -l)
  echo "0 ${PED} 0 ${readoutTime}" >> ${dir_prep}/All_dwisAcqParams.txt
  acqLine=$(echo "${acqLine} + 1" | bc -l)
done
echo $indx > ${dir_prep}/All_index.txt
echo $TotalBVals > ${dir_prep}/All.bval
echo $TotalXVals > ${dir_prep}/XVals.txt
echo $TotalYVals > ${dir_prep}/YVals.txt
echo $TotalZVals > ${dir_prep}/ZVals.txt
cat ${dir_prep}/XVals.txt ${dir_prep}/YVals.txt ${dir_prep}/ZVals.txt >> ${dir_prep}/All.bvec

firstName=${allDwiNames[0]}
unset tempB0Files tempB0AcqFiles tempDwiFiles
declare -a tempB0Files
declare -a tempB0AcqFiles
declare -a tempDwiFiles
for j in ${allDwiNames[@]}; do
  if [ "${firstName}" != "$j" ]; then
    tempB0Files+=(${j}_b0.nii.gz)
    tempDwiFiles+=(${j}_dwi.nii.gz)
    tempB0AcqFiles+=(${j}_B0sAcqParams.txt)
  fi
done
fslmerge -t All_B0s.nii.gz ${firstName}_b0.nii.gz ${tempB0Files[@]}
fslmerge -t All_dwis.nii.gz ${firstName}_dwi.nii.gz ${tempDwiFiles[@]}
cat ${firstName}_B0sAcqParams.txt ${tempB0AcqFiles[@]} >> ${dir_prep}/All_B0sAcqParams.txt



#------------------------------------------------------------------------------
# 2. Topup, Eddy Correction, and DWI Brain Mask
#------------------------------------------------------------------------------

rm ${dir_prep}/*brain.nii.gz \
  ${dir_prep}/*mask.nii.gz \
  ${dir_prep}/*hifi_b0*.nii.gz \
  ${dir_prep}/*eddy*
  ${dir_prep}/*topup*

topup \
  --imain=${dir_prep}/All_B0s.nii.gz \
  --datain=${dir_prep}/All_B0sAcqParams.txt \
  --config=b02b0.cnf \
  --out=${dir_prep}/topup_results \
  --iout=${dir_prep}/All_hifi_b0.nii.gz
fslmaths ${dir_prep}/All_hifi_b0.nii.gz -Tmean ${dir_prep}/All_hifi_b0_mean.nii.gz
bet ${dir_prep}/All_hifi_b0_mean.nii.gz ${dir_prep}/All_hifi_b0_brain.nii.gz -m
eddy_openmp \
  --imain=${dir_prep}/All_dwis.nii.gz \
  --mask=${dir_prep}/All_hifi_b0_brain_mask.nii.gz \
  --acqp=${dir_prep}/All_dwisAcqParams.txt \
  --index=${dir_prep}/All_index.txt \
  --bvecs=${dir_prep}/All.bvec \
  --bvals=${dir_prep}/All.bval \
  --topup=${dir_prep}/topup_results \
  --out=${dir_prep}/All_dwi_hifi_eddy.nii.gz

cp ${dir_prep}/All_dwi_hifi_eddy.nii.gz ${dir_corrected}/${prefix}_dwi_hifi_eddy.nii.gz
#------------------------------------------------------------------------------
# 3. DWI Scalars
#------------------------------------------------------------------------------
rm ${dir_prep}/*Scalar*.nii.gz

dtifit \
  -k ${dir_prep}/All_dwi_hifi_eddy.nii.gz \
  -o ${dir_prep}/All_Scalar \
  -r ${dir_prep}/All.bvec \
  -b ${dir_prep}/All.bval \
  -m ${dir_prep}/All_hifi_b0_brain_mask.nii.gz

#------------------------------------------------------------------------------
# 4. Register B0 to T2 in native space
#------------------------------------------------------------------------------
rm ${dir_prep}/*.mat \
  ${dir_prep}/*prep-rigid*

fixed_image=${dir_anat_native}/sub-${subject}_ses-${session}_site-${site}_T2w_brain.nii.gz
moving_image=${dir_prep}/All_hifi_b0_mean.nii.gz
antsRegistration \
  -d 3 \
  --float 1 \
  --verbose 1 \
  -u 1 \
  -w [0.01,0.99] \
  -z 1 \
  -q [${fixed_image},${moving_image},1] \
  -t Rigid[0.1] \
  -m MI[${fixed_image},${moving_image},1,32,Regular,0.25] \
  -c [1000x500x250x100,1e-6,10] \
  -f 8x4x2x1 \
  -s 3x2x1x0vox \
  -t Affine[0.1] \
  -m MI[${fixed_image},${moving_image},1,32,Regular,0.25] \
  -c [1000x500x250x100,1e-6,10] \
  -f 8x4x2x1 \
  -s 3x2x1x0vox \
  -o ${dir_prep}/dwi_to_native_temp_

for i in ${dir_prep}/*Scalar*.nii.gz; do
  moving_image=${i}
  antsApplyTransforms -d 3 \
    -i ${moving_image} \
    -o ${i::-7}_from-dwi+raw_to-T1w+raw_xfm-stack.nii.gz \
    -t ${dir_prep}/dwi_to_native_temp_0GenericAffine.mat \
    -r ${moving_image}
  mv ${i::-7}_from-dwi+raw_to-T1w+raw_xfm-stack.nii.gz ${dir_native_scalars}/
done
mv ${dir_prep}/dwi_to_native_temp_0GenericAffine.mat ${dir_xfm}/${prefix}_from-dwi+raw_to-T1w+raw_xfm-affine.mat

#------------------------------------------------------------------------------
# 5. Stack Transform to Template Space
#------------------------------------------------------------------------------
unset xfm
xfm[0]=${dir_xfm}/${prefix}_from-dwi+raw_to-T1w+raw_xfm-affine.mat
xfm[1]=${dir_xfm}/${prefix}_from-T1w+raw_to-${space}+${template}_xfm-rigid.mat
ref_image=${dir_template}/${space}/${template}/${space}_${template}_T1w.nii.gz
antsApplyTransforms -d 3 \
  -o [${dir_xfm}/${prefix}_from-dwi+raw_to-${space}+${template}_xfm-stack.nii.gz,1] \
  -t ${xfm[1]} \
  -t ${xfm[0]} \
  -r ${ref_image}

#------------------------------------------------------------------------------
# 6. Apply Tansforms - Scalars to Template Space
#------------------------------------------------------------------------------
for i in ${dir_prep}/*Scalar*.nii.gz; do
  unset xfm
  xfm[0]=${dir_xfm}/${prefix}_from-dwi+raw_to-T1w+raw_xfm-affine.mat
  xfm[1]=${dir_xfm}/${prefix}_from-T1w+raw_to-${space}+${template}_xfm-rigid.mat
  ref_image=${dir_template}/${space}/${template}/${space}_${template}_T1w.nii.gz
  antsApplyTransforms -d 3 \
    -o [${i::-7}_from-dwi+raw_to-${space}+${template}_xfm-stack.nii.gz,1] \
    -t ${xfm[1]} \
    -t ${xfm[0]} \
    -r ${ref_image}
  mv ${i::-7}_from-dwi+raw_to-${space}+${template}_xfm-stack.nii.gz ${dir_template_scalars}_from-dwi+raw_to-${space}+${template}_xfm-stack.nii.gz
done

```
### Citations:
>Jenkinson M, Beckmann CF, Behrens TE, Woolrich MW, & Smith SM. (2012). FSL. Neuroimage, 62(2), 782-790. DOI:10.1016/j.neuroimage.2011.09.015 PMID:21979382
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

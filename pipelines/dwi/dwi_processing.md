# DWI Processing
## Output:
```
${researcher}/${project}/derivatives/dwi/scalar
  ∟sub-${subject}_ses-${session}_*_Scalar_*.nii.gz
```
## Code:
```bash
#------------------------------------------------------------------------------
# specify analysis variables
#------------------------------------------------------------------------------
researcher=/Shared/hothlab
project=AJM_Test
subject=D046
session=3287pppgax
site=00201
#space=HCPNOBS1
#template=1mm

#------------------------------------------------------------------------------
# Initialize Output Folders
#------------------------------------------------------------------------------
dir_raw=${researcher}/${project}/sub-${subject}/ses-${session}/dwi
dir_anat_native=${researcher}/${project}/derivatices/anat/native/

dir_prep=${researcher}/${project}/derivatives/dwi/prep/sub-${subject}/ses-${session}
dir_results=${researcher}/${project}/derivatives/dwi/results/sub-${subject}/ses-${session}
dir_xfm=${researcher}/${project}/derivatives/xfm/qc/dwi_prep
dir_scalar=${researcher}/${project}/derivatives/dwi/scalar

mkdir -p ${dir_prep}
mkdir -p ${dir_results}
mkdir -p ${dir_xfm}

#------------------------------------------------------------------------------
# 1. B0 Extraction, Topup Prep
#------------------------------------------------------------------------------

rm ${dir_prep}/*.nii.gz \
  ${dir_prep}/*.bval \
  ${dir_prep}/*.bvec \
  ${dir_prep}/*.json \
  ${dir_prep}/*.txt

cp ${dir_raw}/*.* ${dir_prep}/

unset allDwiFiles
declare -a allDwiFiles

for i in ${dir_prep}/*dwi.nii.gz; do
  unset dtiFile dtiName B0s numB0s PEDstring PEDSTRING PED EESstring EES AcqMPEstring AcqMPE readoutTime
  dtiFile=$i
  dtiName=${dtiFile::-11}
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
  indx=""
  for j in "${B0s[@]}"; do
    indx="${indx} 1"
    if [ $j -eq 0 ]; then
      let numB0s=numB0s+1;
      echo "0 ${PED} 0 ${readoutTime}" >> ${dtiName}_B0sAcqParams.txt
    fi
  done
  echo $indx > ${dtiName}_index.txt
  fslroi ${dtiFile} ${dtiName}_b0.nii.gz 0 ${numB0s}
  allDwiFiles+=(${dtiName})
done


for i in ${allDwiFiles[@]}; do
  unset tempB0Files
  declare -a tempB0Files
  unset tempB0AcqFiles
  declare -a tempB0AcqFiles
  for j in ${allDwiFiles[@]}; do
    if [ "$i" != "$j" ]; then
      tempB0Files+=(${j}_b0.nii.gz)
      tempB0AcqFiles+=(${j}_B0sAcqParams.txt)
    fi
  done
  fslmerge -t ${i}_all_B0s.nii.gz ${i}_b0.nii.gz ${tempB0Files[@]}
  cat ${i}_B0sAcqParams.txt ${tempB0AcqFiles[@]} >> ${i}_all_B0sAcqParams.txt
done


#------------------------------------------------------------------------------
# 2. Topup, Eddy Correction, and DWI Brain Mask
#------------------------------------------------------------------------------

rm ${dir_prep}/*brain.nii.gz \
  ${dir_prep}/*mask.nii.gz \
  ${dir_prep}/*hifi_b0.nii.gz \
  ${dir_prep}/*eddy.nii.gz

for i in ${dir_prep}/*_dwi.nii.gz; do
  dtiFile=$i
  dtiName=${dtiFile::-11}
  topup \
    --imain=${dtiName}_all_B0s.nii.gz \
    --datain=${dtiName}_all_B0sAcqParams.txt \
    --config=b02b0.cnf \
    --out=topup_results \
    --iout=${dtiName}_hifi_b0.nii.gz
  fslmaths ${dtiName}_hifi_b0.nii.gz -Tmean ${dtiName}_hifi_b0.nii.gz
  bet ${dtiName}_hifi_b0.nii.gz ${dtiName}_hifi_b0_brain.nii.gz -m
  eddy_openmp \
    --imain=${dtiFile} \
    --mask=${dtiName}_hifi_b0_brain_mask.nii.gz \
    --acqp=${dtiName}_B0sAcqParams.txt \
    --index=${dtiName}_index.txt \
    --bvecs=${dtiName}_dwi.bvec \
    --bvals=${dtiName}_dwi.bval \
    --topup=topup_results \
    --out=${dtiName}_dwi_hifi_eddy.nii.gz
done

#------------------------------------------------------------------------------
# 3. DWI Scalars
#------------------------------------------------------------------------------
rm ${dir_prep}/*Scalar*.nii.gz

for i in ${dir_prep}/*_eddy.nii.gz; do
  dtiFile=$i
  dtiEddyName=${dtiFile::-7}
  dtiName=${dtiFile::-21}
  dtifit \
    -k ${dtiFile} \
    -o ${dtiEddyName}_Scalar \
    -r ${dtiName}_dwi.bvec \
    -b ${dtiName}_dwi.bval \
    -m ${dtiName}_hifi_b0_brain_mask.nii.gz
done

#------------------------------------------------------------------------------
# 4. Register Scalars to Native Space
#------------------------------------------------------------------------------
echo 'task: dwi rigid_alignment' >> ${subject_log}
date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}

for i in ${dir_prep}/*_dwi.nii.gz; do
  dtiFile=$i
  dtiName=${dtiFile::-11}
  fixed_image=${dir_anat_native}/sub-${subject}_ses-${session}_site-${site}_T2w_brain.nii.gz
  moving_image=${dtiName}_dwi_hifi_eddy_Scalar_FA.nii.gz

  antsRegistration \
    -d 3 \
    --float 1 \
    --verbose 1 \
    -u 1 \
    -w [0.01,0.99] \
    -z 1 \
    -r [${fixed_image},${moving_image},1] \
    -t Rigid[0.1] \
    -m Mattes[${fixed_image},${moving_image},1,32,Regular,0.25] \
    -c [2100x1200x1200x0,1e-6,10] \
    -f 4x2x2x1 \
    -s 3x2x1x0 \
    -o ${dtiName}_temp_

  for j in ${dtiName}*Scalar*.nii.gz; do
    ScalarFile=$j
    ScalarName=${ScalarFile::-7}
    antsApplyTransforms -d 3 \
      -i ${moving_image} \
      -o ${ScalarName}_prep-rigid.nii.gz \
      -t ${dtiName}_temp_0GenericAffine.mat \
      -r ${moving_image}
  done
  mv ${dtiName}_temp_0GenericAffine.mat ${dir_xfm}/
done

#------------------------------------------------------------------------------
# 5. Move Results
#------------------------------------------------------------------------------
for i in ${dir_prep}/*Scalar*; do
  mv $i ${dir_scalar}/
done



```
### Citations:
>Jenkinson M, Beckmann CF, Behrens TE, Woolrich MW, & Smith SM. (2012). FSL. Neuroimage, 62(2), 782-790. DOI:10.1016/j.neuroimage.2011.09.015 PMID:21979382
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

# DWI Processing
## Output:
```
**Not coded yet**
${researcher}/${project}/derivatives/dwi/native
  ∟sub-${subject}_ses-${session}_*_${mod}_
  ∟sub-${subject}_ses-${session}_*_${mod}_
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

#dir_native=${researcher}/${project}/derivatives/dwi/native
#dir_mask=${researcher}/${project}/derivatives/dwi/mask
dir_prep=${researcher}/${project}/derivatives/dwi/prep/sub-${subject}/ses-${session}
dir_results=${researcher}/${project}/derivatives/dwi/results/sub-${subject}/ses-${session}
dir_raw=${researcher}/${project}/sub-${subject}/ses-${session}/dwi

#mkdir -p ${dir_native}
#mkdir -p ${dir_mask}
mkdir -p ${dir_prep}
mkdir -p ${dir_results}

#------------------------------------------------------------------------------
# 1. B0 Extraction
#------------------------------------------------------------------------------
cd ${dir_raw}
rm ./*_b0.nii.gz \
  ./*_hifi.nii.gz \
  ./*_eddy.nii.gz \
  ./All_b0s.nii.gz \
  ./allB0sAcqParams.txt \
  ./*B0sAcqParams.txt

unset allB0Files
declare -a allB0Files
touch allB0sAcqParams.txt

for i in *dwi.nii.gz; do
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
  for j in "${B0s[@]}"; do
    if [ $j -eq 0 ]
      then 
      let numB0s=numB0s+1;
      echo "0 ${PED} 0 ${readoutTime}" >> ${dtiName}_B0sAcqParams.txt
    fi
   done
  fslroi ${dtiFile} ${dtiName}_b0.nii.gz 0 ${numB0s}
  allB0Files+=(${dtiName}_b0.nii.gz)
done

cat *_B0sAcqParams.txt >> allB0sAcqParams.txt
fslmerge -t All_b0s.nii.gz ${allB0Files[@]}

#------------------------------------------------------------------------------
# 2. Topup, Eddy Correction, and DWI Brain Mask
#------------------------------------------------------------------------------
topup \
  --imain=All_b0s.nii.gz \
  --datain=allB0sAcqParams.txt \
  --config=b02b0.cnf \
  --out=topup_results \
  --iout=all_b0s_hifif_b0.nii.gz

for i in *dwi.nii.gz; do
  dtiFile=$i
  dtiName=${dtiFile::-11}
  rm ${dtiName}_dwi_hifi.nii.gz
  applytopup \
    --imain=${dtiFile} \
    --datain=${dtiName}_B0sAcqParams.txt \
    --inindex=1 \
    --topup=topup_results \
    --method=jac \
    --out=${dtiName}_dwi_hifi.nii.gz
  rm ${dtiName}_dwi_hifi_eddy.nii.gz ${dtiName}_dwi_hifi_eddy.ecclog
  eddy_correct ${dtiName}_dwi_hifi.nii.gz ${dtiName}_dwi_hifi_eddy.nii.gz 0
  rm ${dtiName}_dwi_hifi_eddy_BET.nii.gz ${dtiName}_dwi_hifi_eddy_BET_mask.nii.gz
  bet \
    ${dtiName}_dwi_hifi_eddy.nii.gz \
    ${dtiName}_dwi_hifi_eddy_BET.nii.gz \
    -m -R
done

#------------------------------------------------------------------------------
# 3. DWI Scalars
#------------------------------------------------------------------------------
for i in *eddy.nii.gz; do
  rm ./*Scalar*.nii.gz
  dtiFile=$i
  dtiEddyName=${dtiFile::-7}
  dtiName=${dtiFile::-17}
  dtifit \
    -k ${dtiFile} \
    -o ${dtiEddyName}_Scalar \
    -r ${dtiName}.bvec \
    -b ${dtiName}.bval \
    -m ${dtiEddyName}_BET_mask.nii.gz
done

```
### Citations:
>Jenkinson M, Beckmann CF, Behrens TE, Woolrich MW, & Smith SM. (2012). FSL. Neuroimage, 62(2), 782-790. DOI:10.1016/j.neuroimage.2011.09.015 PMID:21979382

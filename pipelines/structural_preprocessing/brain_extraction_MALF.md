# Brain extraction
## MALF - Majority Vote between AFNI, ANTS, BET
## Output:
```
${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/
    ∟sub-${subject}_ses-${session}_*_prep-bex0MALF.nii.gz     #preliminary
    ∟sub-${subject}_ses-${session}_*_prep-bexMALF.nii.gz     #final
```
## Code:
```bash
unset brain_mask
brain_mask[0]=${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz
brain_mask[1]=${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz
brain_mask[2]=${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz
suffix=bex0

echo 'task: brain_extraction_MALF' >> ${subject_log}
echo 'input: '${t1_image} >> ${subject_log}
echo 'input: '${t2_image} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

# Majority-vote brain mask
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -thr 2 -bin -ero -dilM -dilM -ero ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

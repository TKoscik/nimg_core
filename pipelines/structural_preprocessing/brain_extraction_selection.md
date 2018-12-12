# Brain extraction
## Selecting Best output combination
## Output:
```
${researcher}/${project}/derivatives/anat/
  ∟prep/sub-${subject}/ses-${session}/
    ∟sub-${subject}_ses-${session}_*_prep-bex0Brain.nii.gz     #preliminary
  ∟mask/
    ∟sub-${subject}_ses-${session}_*_mask-brain.nii.gz     #final
    ∟sub-${subject}_ses-${session}_*_mask-tissue.nii.gz     #final
```
## Code:
```bash
which_bex="MALF"

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task: structural_brain_extraction_selection' >> ${subject_log}
echo 'input: '${t1_image} >> ${subject_log}
echo 'input: '${t2_image} >> ${subject_log}
echo 'software: FSL' >> ${subject_log}
echo 'version: '${fsl_version} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

output_mask=${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz
if [[ "${which_mask,,}" = "malf" ]]; then
  cp ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "afni" ]]; then
  cp ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "ants" ]]; then
  cp ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "bet" ]]; then
  cp ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "afni&ants" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "afni&bet" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "afni&malf" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "ants&afni" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "ants&bet" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "ants&malf" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "bet&afni" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "bet&ants" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "bet&malf" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "malf&afni" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "malf&ants" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "malf&bet" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz -mul ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz ${output_mask}
elif [[ "${which_mask,,}" = "afni|ants" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "afni|bet" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "afni|malf" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "ants|afni" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "ants|bet" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "ants|malf" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "bet|afni" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "bet|ants" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "bet|malf" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "malf|afni" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "malf|ants" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz -bin ${output_mask}
elif [[ "${which_mask,,}" = "malf|bet" ]]; then
  fslmaths ${dir_prep}/${prefix}_prep-${suffix}MALF.nii.gz -add ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -bin ${output_mask}
fi

# Invert brain mask
fslmaths ${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz -sub 1 -mul 1 ${dir_prep}/${prefix}_prep-${suffix}Tissue.nii.gz

if [[ "${suffix}"="bex" ]]; then
  mv ${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz ${dir_mask}/${prefix}_mask-brain.nii.gz
  mv ${dir_prep}/${prefix}_prep-${suffix}Tissue.nii.gz ${dir_mask}/${prefix}_mask-tissue.nii.gz
fi

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

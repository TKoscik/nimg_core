# Brain extraction
## FSL BET2
## Output:
```
${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/
    ∟sub-${subject}_ses-${session}_*_prep-bex0BET.nii.gz     #preliminary
    ∟sub-${subject}_ses-${session}_*_prep-bexBET.nii.gz     #final
```
## Code:
```bash
t1_image=${dir_prep}/${t1_prefix}_prep-denoise.nii.gz
t2_image=${dir_prep}/${t2_prefix}_prep-denoise.nii.gz
suffix=bex0  #change as needed to differentiate iterations, final iteration is bex (no number)

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task: structural_brain_extraction_bet' >> ${subject_log}
echo 'input: '${t1_image} >> ${subject_log}
echo 'input: '${t2_image} >> ${subject_log}
echo 'software: FSL' >> ${subject_log}
echo 'version: '${fsl_version} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

# FSL brain extraction tool ----
bet ${t1_image} ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz -A2 ${t2_image} -m -R
mv ${dir_prep}/${prefix}_prep-${suffix}BET_mask.nii.gz \
  ${dir_prep}/${prefix}_prep-${suffix}BET.nii.gz
rm ${dir_prep}/${prefix}*${suffix}BET_*skull*
rm ${dir_prep}/${prefix}*${suffix}BET_mesh*
rm ${dir_prep}/${prefix}*${suffix}BET_out*

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations:
### FSL Brain Extraction Tool:
>Smith SM. (2002). Fast robust automated brain extraction. Human Brain Mapping, 17(3), 143-155. DOI:10.1002/hbm.10062 PMCID:12391568

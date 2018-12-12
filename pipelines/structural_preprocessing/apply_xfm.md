# Normalization to template space
## Output:
```
${researcherRoot}/${projectName}/derivatives/${appropriate_dir}
    ∟sub-${subject}_ses-${session}_*_reg_to-${fixed}.nii.gz
```
## Code:
```bash
unset input_image
input_image[0]=${dir_native}/${prefix}_T1w.nii.gz
input_image[1]=${dir_native}/${prefix}_T1w_brain.nii.gz
input_image[2]=${dir_native}/${prefix}_T1w_tissue.nii.gz
unset output_image
output_image[0]=${dir_norm}/${prefix}_reg-${space}+${template}_T1w.nii.gz
output_image[1]=${dir_norm}/${prefix}_reg-${space}+${template}_T1w_brain.nii.gz
output_image[2]=${dir_norm}/${prefix}_reg-${space}+${template}_T1w_tissue.nii.gz
unset xfm
xfm=${dir_xfm}/${prefix}_from-T1w+rigid_to-${space}+${template}_xfm-stack.nii.gz
ref_image=${dir_template}/${space}/${template}/${space}_${template}_T1w.nii.gz

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task: structural_apply_transform' >> ${subject_log}
for ((i = 0; i < ${#input_image[@]}; ++i)); do
  echo 'input_image: '${input_image[${i}]} >> ${subject_log}
  echo 'output_image: '${output_image[${i}]} >> ${subject_log}
done
echo 'xfm: '${xfm} >> ${subject_log}
echo 'software: ANTS' >> ${subject_log}
echo 'version: '${ants_version} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

for ((i = 0; i < ${#input_image[@]}; ++i)); do
  antsApplyTransforms -d 3 \
    -i ${input_image[${i}]} \
    -o ${output_image[${i}]} \
    -t ${xfm} \
    -r ${ref_image}
done

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations:
### ANTs Registration
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

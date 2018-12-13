# Apply brain and tissue masks
## Output:
```
${researcher}/${project}/derivatives/anat/native/
  ∟sub-${subject}_ses-${session}_*_${mod}_brain.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_tissue.nii.gz
```
## Code:
```bash
input_image=${dir_native}/${prefix}_T1w.nii.gz
unset mask
mask[0]=${dir_mask}/${prefix}_mask-brain.nii.gz
mask[1]=${dir_mask}/${prefix}_mask-tissue.nii.gz
unset output_image
output_image[0]=${dir_native}/${prefix}_T1w_brain.nii.gz
output_image[1]=${dir_native}/${prefix}_T1w_tissue.nii.gz

echo 'task: structural_apply_mask' >> ${subject_log}
echo 'input_image: '${input_image} >> ${subject_log}
for ((i = 0; i < ${#mask[@]}; ++i)); do
  echo 'input_mask: '${i} >> ${subject_log}
done
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

for ((i = 0; i < ${#mask[@]}; ++i)); do
  fslmaths ${input_image} -mas ${mask[${i}]} ${output_image[${i}]}
done

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
### Citations:
>Jenkinson M, Beckmann CF, Behrens TE, Woolrich MW, & Smith SM. (2012). FSL. Neuroimage, 62(2), 782-790. DOI:10.1016/j.neuroimage.2011.09.015 PMID:21979382

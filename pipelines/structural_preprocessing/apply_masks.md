# Apply brain and tissue masks
## Output:
```
${researcher}/${project}/derivatives/anat/native/
  ∟sub-${subject}_ses-${session}_*_${mod}_brain.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_tissue.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep/${subject}/${session}/
which_img=sub-${subject}_ses-${session}_T1w_prep-biasN4.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-brain.nii.gz
tissue_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-tissue.nii.gz
output_prefix=sub-${subject}_ses-${session}_T1w_

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_bias_correction_T1T2' >> ${subject_log}
echo 'input_image:'${researcher}/${project}/${input_dir}/${which_img} >> ${subject_log}
echo 'brain_mask:'${brain_mask} >> ${subject_log}
echo 'tissue_mask:'${tissue_mask} >> ${subject_log}
echo 'software:FSL' >> ${subject_log}
echo 'version:5.10.0' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

fslmaths \
  ${researcher}/${project}/${input_dir}/${which_img} \
  -mas ${brain_mask} \
  ${researcher}/${project}/derivatives/anat/native/${output_prefix}brain.nii.gz

fslmaths \
  ${researcher}/${project}/${input_dir}/${which_img} \
  -mas ${tissue_mask} \
  ${researcher}/${project}/derivatives/anat/native/${output_prefix}tissue.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
### Citations:
>Jenkinson M, Beckmann CF, Behrens TE, Woolrich MW, & Smith SM. (2012). FSL. Neuroimage, 62(2), 782-790. DOI:10.1016/j.neuroimage.2011.09.015 PMID:21979382

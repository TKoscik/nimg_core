#  ACPC Alignment  
## Output:
```
 ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-acpc.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep/sub-${subject}/ses-${session}/     # location relative to researcher/project/
which_img=sub-${subject}_ses-${session}_T1w_prep-denoise.nii.gz
output_prefix==sub-${subject}_ses-${session}_T1w_

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_acpc_alignment' >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/${which_image}.nii.gz >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsRegistrationSyN.sh \
  -d 3 \
  -f ${template_dir}/${space}/${template}.nii.gz \
  -m ${researcher}/${project}/${input_dir}/${which_image}.nii.gz \
  -t r \
  -o ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/sub-${session}/${output_prefix}_prep-acpc
    
mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_prep-acpcWarped.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_prep-acpc.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_prep-acpc0GenericAffine.mat \
  ${researcher}/${project}/derivatives/tform/${output_prefix}_ref-${space}_tform-0rigid.mat
rm ${output_prefix}_prep-acpcInverseWarped.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

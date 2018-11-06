# Within-session, multimodal registration
## Output:
```
${researcher}/${project}/derivatives/
  ∟anat/
    ∟prep/sub-${subject}/ses-${session}/
      ∟sub-${subject}_ses-${session}_*_${mod}_prep-T1reg.nii.gz
  ∟tform/
    ∟sub-${subject}_ses-${session}_*_${mod}_reg-T1_tform-0affine.nii.gz
    ∟sub-${subject}_ses-${session}_*_${mod}_reg-T1_tform-1syn.nii.gz
    ∟sub-${subject}_ses-${session}_*_${mod}_reg-T1_tform-1inverse.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep/${subject}/${session}/
fixed_img=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz
moving_img=sub-${subject}_ses-${session}_T2w_prep-avg.nii.gz
output_prefix=sub-${subject}_ses-${session}_T2w

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_within_session_multimodal_average' >> ${subject_log}
echo 'fixed:'${researcher}/${project}/${input_dir}/${fixed_img} >> ${subject_log}
echo 'moving:'${researcher}/${project}/${input_dir}/${moving_img} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsRegistrationSyN.sh -d 3 \
  -f ${researcher}/${project}/${input_dir}/${fixed_img} \
  -m ${researcher}/${project}/${input_dir}/${moving_img} \
  -o ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_temp_ \
  -t s

# Edit final output names as necesary
mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_temp_Warped.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_prep-T1reg.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_temp_0GenericAffine.mat \
  ${researcher}/${project}/derivatives/tform/${output_prefix}_reg-T1_tform-0affine.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_temp_1Warp.nii.gz \
  ${researcher}/${project}/derivatives/tform/${output_prefix}_reg-T1_tform-1syn.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_temp_1InverseWarp.nii.gz \
  ${researcher}/${project}/derivatives/tform/${output_prefix}_reg-T1_tform-1inverse.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations:
### ANTs Registration
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

>Avants BB, Tustison NJ, Song G, Cook PA, Klein A, & Gee JC. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. Neuroimage, 54(3), 2033-2044. DOI:10.1016/j.neuroimage.2010.09.025 PMCID:PMC3065962

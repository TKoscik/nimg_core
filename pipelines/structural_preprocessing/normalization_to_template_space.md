# Normalization to template space
## Output:
```
∟reg_${space}_${template}/
    ∟sub-${subject}_ses-${session}_*_${mod}_reg-${space}_${template}.nii.gz
  ∟tform/
    ∟sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat
    ∟sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.nii.gz
    ∟sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1inverse.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/native
brain_img[0]=sub-${subject}_ses-${session}_T1w_brain.nii.gz
tissue_img[0]=sub-${subject}_ses-${session}_T1w_tissue.nii.gz
brain_img[1]=sub-${subject}_ses-${session}_T2w_brain.nii.gz
tissue_img[1]=sub-${subject}_ses-${session}_T2w_tissue.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-brain.nii.gz
tissue_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-tissue.nii.gz
template_mod[0]=MNI_T1_0.8mm
template_mod[1]=MNI_T2_0.8mm
output_prefix[0]=sub-${subject}_ses-${session}_T1w_
output_prefix[1]=sub-${subject}_ses-${session}_T2w_

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_normalization' >> ${subject_log}
echo 'input_brain_image:'${researcher}/${project}/${input_dir}/${brain_img[0]} >> ${subject_log}
echo 'input_tissue_image:'${researcher}/${project}/${input_dir}/${tissue_img[0]} >> ${subject_log}
echo 'template_space:'${nimg_core_root}/templates/${space}/${template[0]} >> ${subject_log}
echo 'input_brain_image:'${researcher}/${project}/${input_dir}/${brain_img[1]} >> ${subject_log}
echo 'input_tissue_image:'${researcher}/${project}/${input_dir}/${tissue_img[1]} >> ${subject_log}
echo 'template_space:'${nimg_core_root}/templates/${space}/${template[1]} >> ${subject_log}
echo 'brain_mask:'${brain_mask} >> ${subject_log}
echo 'tissue_mask:'${tissue_mask} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

template_space=${nimg_core_root}/templates/${space}
img_path=${researcher}/${project}/${input_dir}

antsRegistration \
  -d 3 \
  --float 1 \
  --verbose 1 \
  -u 1 \
  -w [0.01,0.99] \
  -z 1 \
  -r [${template_space}/${template[0]}.nii.gz,${img_path}/${brain_img[0]},1] \
  -t Rigid[0.1] \
  -m MI[${template_space}/${template_mod[0]}_brain.nii.gz,${img_path}/${brain_img[0]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[0]}_tissue.nii.gz,${img_path}/${tissue_img[0]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[1]}_brain.nii.gz,${img_path}/${brain_img[1]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[1]}_tissue.nii.gz,${img_path}/${tissue_img[1]},1,32,Regular,0.25] \
  -c [1000x500x250x0,1e-6,10] \
  -f 6x4x2x1 \
  -s 4x2x1x0 \
  -t Affine[0.1] \
  -m MI[${template_space}/${template_mod[0]}_brain.nii.gz,${img_path}/${brain_img[0]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[0]}_tissue.nii.gz,${img_path}/${tissue_img[0]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[1]}_brain.nii.gz,${img_path}/${brain_img[1]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[1]}_tissue.nii.gz,${img_path}/${tissue_img[1]},1,32,Regular,0.25] \
  -c [1000x500x250x0,1e-6,10] \
  -f 6x4x2x1 \
  -s 4x2x1x0 \
  -t SyN[0.1,3,0] \
  -m CC[${template_space}/${template_mod[0]}_brain.nii.gz,${img_path}/${brain_img[0]},1,4] \
  -m CC[${template_space}/${template_mod[0]}_tissue.nii.gz,${img_path}/${tissue_img[0]},1,4] \
  -m CC[${template_space}/${template_mod[1]}_brain.nii.gz,${img_path}/${brain_img[1]},1,4] \
  -m CC[${template_space}/${template_mod[1]}_tissue.nii.gz,${img_path}/${tissue_img[1]},1,4] \
  -c [100x100x70x20,1e-9,10] \
  -f 6x4x2x1 \
  -s 3x2x1x0vox \
  -o ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/sub-${subject}_ses-${session}_temp_

mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/sub-${subject}_ses-${session}_temp_0GenericAffine.mat \
  ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat
mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/sub-${subject}_ses-${session}_temp_1Warp.nii.gz \
  ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat
mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/sub-${subject}_ses-${session}_temp_1InverseWarp.nii.gz \
  ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1inverse.mat

antsApplyTransforms \
  -d 3 \
  --float 1 \
  -i ${img_path}/${brain_img[0]} \
  -o ${researcher}/${project}/derivatives/anat/reg_${space}_${template}/${output_prefix[0]}brain.nii.gz \
  -r ${template_space}/${template_mod[0]}_brain.nii.gz \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat

antsApplyTransforms \
  -d 3 \
  --float 1 \
  -i ${img_path}/${tissue_img[0]} \
  -o ${researcher}/${project}/derivatives/anat/reg_${space}_${template}/${output_prefix[0]}tissue.nii.gz \
  -r ${template_space}/${template_mod[0]}_tissue.nii.gz \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat

antsApplyTransforms \
  -d 3 \
  --float 1 \
  -i ${img_path}/${brain_img[1]} \
  -o ${researcher}/${project}/derivatives/anat/reg_${space}_${template}/${output_prefix[1]}brain.nii.gz \
  -r ${template_space}/${template_mod[1]}_brain.nii.gz \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat

antsApplyTransforms \
  -d 3 \
  --float 1 \
  -i ${img_path}/${tissue_img[1]} \
  -o ${researcher}/${project}/derivatives/anat/reg_${space}_${template}/${output_prefix[1]}tissue.nii.gz \
  -r ${template_space}/${template_mod[1]}_tissue.nii.gz \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat

# make air mask
antsApplyTransforms \
  -d 3 \
  -i ${nimg_core_root}/templates/${space}/${template}_air_mask.nii.gz \
  -o ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-air.nii.gz \
  -r ${tissue_mask} \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1inverse.mat \
  -t [${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat,1]

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations:
### ANTs Registration
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

>Avants BB, Tustison NJ, Song G, Cook PA, Klein A, & Gee JC. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. Neuroimage, 54(3), 2033-2044. DOI:10.1016/j.neuroimage.2010.09.025 PMCID:PMC3065962

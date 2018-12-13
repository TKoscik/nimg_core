#  RIGID Alignment
__RETAIN ORIGINAL GRID SPACING__
## Output:
```
 ${researcher}/${project}/derivatives/
   ∟anat/prep/sub-${subject}/ses-${session}/
     ∟sub-${subject}_ses-${session}_*_${mod}_prep-rigid.nii.gz
   ∟xfm/sub-${subject}/ses-${session}/
     ∟sub-${subject}_ses-${session}_*_from-${target}+raw_to-${space}+${template}_xfm-rigid.nii.gz
```
## Code:
```bash
target=T1w
moving_image=${dir_raw}/${t1_prefix}.nii.gz
fixed_image=${dir_template}/${space}/${template}/${space}_${template}_${target}.nii.gz
output_prefix=${t1_prefix}

echo 'task: structural_rigid_alignment' >> ${subject_log}
echo 'fixed_image: '${fixed_image} >> ${subject_log}
echo 'moving_image: '${moving_image} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsRegistration \
  -d 3 \
  --float 1 \
  --verbose 1 \
  -u 1 \
  -w [0.01,0.99] \
  -z 1 \
  -r [${fixed_image},${moving_image},1] \
  -t Rigid[0.1] \
  -m MI[${fixed_image},${moving_image},1,32,Regular,0.25] \
  -c [1000x500x250x0,1e-6,10] \
  -f 6x4x2x1 \
  -s 4x2x1x0 \
  -o ${dir_prep}/temp_

antsApplyTransforms -d 3 \
  -i ${moving_image} \
  -o ${dir_prep}/${output_prefix}_prep-rigid.nii.gz \
  -t ${dir_prep}/temp_0GenericAffine.mat \
  -r ${moving_image}

mv ${dir_prep}/temp_0GenericAffine.mat ${dir_xfm}/${prefix}_from-${target}+raw_to-${space}+${template}_xfm-rigid.mat

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

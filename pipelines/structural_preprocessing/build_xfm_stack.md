# Stack Transformations into single file
## Output:
```
${researcherRoot}/${projectName}/derivatives/xfm/sub-${subject}/ses-${session}/
    ∟sub-${subject}_ses-${session}_*_from-${moving}_to-${fixed}_xfm-stack.nii.gz
```
## Code:
```bash
moving=T1w+rigid
fixed=${space}+${template}
unset xfm
xfm[0]=${dir_xfm}/${prefix}_from-${moving}_to-${fixed}_xfm-affine.mat
xfm[1]=${dir_xfm}/${prefix}_from-${moving}_to-${fixed}_xfm-syn.nii.gz
ref_image=${dir_template}/${space}/${template}/${space}_${template}_T1w.nii.gz

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task: structural_transform_stack' >> ${subject_log}
echo 'xfm: '${xfm[0]} >> ${subject_log}
echo 'xfm: '${xfm[1]} >> ${subject_log}
echo 'software: ANTS' >> ${subject_log}
echo 'version: '${ants_version} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsApplyTransforms -d 3 \
  -o [${dir_xfm}/${prefix}_from-${moving}_to-${fixed}_xfm-stack.nii.gz,1] \
  -t ${xfm[1]} \
  -t ${xfm[0]} \
  -r ${ref_image}

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations:
### ANTs Registration
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

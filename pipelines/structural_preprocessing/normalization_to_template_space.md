# Normalization to template space
## Output:
```
${researcherRoot}/${projectName}/derivatives/xfm/sub-${subject}/ses-${session}/
    ∟sub-${subject}_ses-${session}_*_from-T1w+rigid_to-${space}+${template}_xfm-affine.mat
    ∟sub-${subject}_ses-${session}_*_from-T1w+rigid_to-${space}+${template}_xfm-syn.nii.gz
    ∟sub-${subject}_ses-${session}_*_from-${space}+${template}_to-T1w+rigid_xfm-syn.nii.gz
```
## Code:
```bash
moving_brain=${dir_native}/${prefix}_T1w_brain.nii.gz
moving_tissue=${dir_native}/${prefix}_T1w_tissue.nii.gz
fixed_brain=${dir_template}/${space}/${template}/${space}_${template}_T1w_brain.nii.gz
fixed_tissue=${dir_template}/${space}/${template}/${space}_${template}_T1w_tissue.nii.gz
output_prefix=${prefix}

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task: structural_normalization' >> ${subject_log}
echo 'moving_brain_image: '${moving_brain} >> ${subject_log}
echo 'moving_tissue_image: '${moving_tissue} >> ${subject_log}
echo 'moving_brain_image: '${fixed_brain} >> ${subject_log}
echo 'moving_tissue_image: '${fixed_tissue} >> ${subject_log}
echo 'software: ANTS' >> ${subject_log}
echo 'version: '${ants_version} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsRegistration \
  -d 3 \
  --float 1 \
  --verbose 1 \
  -u 1 \
  -w [0.01,0.99] \
  -z 1 \
  -r [${fixed_brain},${moving_brain},1] \
  -t Rigid[0.1] \
  -m MI[${fixed_brain},${moving_brain},1,32,Regular,0.25] \
  -m MI[${fixed_tissue},${moving_tissue},1,32,Regular,0.25] \
  -c [1000x500x250x0,1e-6,10] \
  -f 6x4x2x1 \
  -s 4x2x1x0 \
  -t Affine[0.1] \
  -m MI[${fixed_brain},${moving_brain},1,32,Regular,0.25] \
  -m MI[${fixed_tissue},${moving_tissue},1,32,Regular,0.25] \
  -c [1000x500x250x0,1e-6,10] \
  -f 6x4x2x1 \
  -s 4x2x1x0 \
  -t SyN[0.1,3,0] \
  -m CC[${fixed_brain},${moving_brain},1,4] \
  -m CC[${fixed_tissue},${moving_tissue},1,4] \
  -c [100x100x70x20,1e-9,10] \
  -f 6x4x2x1 \
  -s 3x2x1x0vox \
  -o ${dir_prep}/temp_

mv ${dir_prep}/temp_0GenericAffine.mat \
  ${dir_xfm}/${output_prefix}_from-T1w+rigid_to-${space}+${template}_xfm-affine.mat
mv ${dir_prep}/temp_1Warp.nii.gz \
  ${dir_xfm}/${output_prefix}_from-T1w+rigid_to-${space}+${template}_xfm-syn.nii.gz
mv ${dir_prep}/temp_1InverseWarp.nii.gz \
  ${dir_xfm}/${output_prefix}_from-${space}+${template}_to-T1w+rigid_xfm-syn.nii.gz

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations:
### ANTs Registration
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

>Avants BB, Tustison NJ, Song G, Cook PA, Klein A, & Gee JC. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. Neuroimage, 54(3), 2033-2044. DOI:10.1016/j.neuroimage.2010.09.025 PMCID:PMC3065962

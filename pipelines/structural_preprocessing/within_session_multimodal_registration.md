# Within-session, multimodal registration
## Output:
```
${researcher}/${project}/derivatives/
  ∟anat/prep/sub-${subject}/ses-${session}/
      ∟sub-${subject}_ses-${session}_*_${mod}_prep-rigid.nii.gz
  ∟xfm/sub-${subject}/ses-${session}/
    ∟sub-${subject}_ses-${session}_*_from-${mod}+raw_to-T1w+rigid_xfm-affine.mat
    ∟sub-${subject}_ses-${session}_*_from-${mod}+raw_to-T1w+rigid_xfm-syn.nii.gz
    ∟sub-${subject}_ses-${session}_*_from-T1w+rigid_to-${mod}+raw_xfm-syn.nii.gz
```
## Code:
```bash
fixed_image=${dir_prep}/${t1_prefix}_prep-rigid.nii.gz
moving_image=${dir_raw}/${t2_prefix}.nii.gz
output_prefix=${t2_prefix}

echo 'task: within-session_T2w_to_T1w' >> ${subject_log}
echo 'fixed: '${fixed_image} >> ${subject_log}
echo 'moving: '${moving_image} >> ${subject_log}
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
  -t Affine[0.1] \
  -m MI[${fixed_image},${moving_image},1,32,Regular,0.25] \
  -c [1000x500x250x0,1e-6,10] \
  -f 6x4x2x1 \
  -s 4x2x1x0 \
  -t SyN[0.1,3,0] \
  -m CC[${fixed_image},${moving_image},1,4] \
  -c [100x100x70x20,1e-9,10] \
  -f 6x4x2x1 \
  -s 3x2x1x0vox \
  -o [${dir_prep}/temp_,${dir_prep}/${output_prefix}_prep-rigid.nii.gz]

mv ${dir_prep}/temp_0GenericAffine.mat ${dir_xfm}/${prefix}_from-T2w+raw_to-T1w+rigid_xfm-affine.mat
mv ${dir_prep}/temp_1Warp.nii.gz ${dir_xfm}/${prefix}_from-T2w+raw_to-T1w+rigid_xfm-syn.nii.gz
mv ${dir_prep}/temp_1InverseWarp.nii.gz ${dir_xfm}/${prefix}_from-T1w+rigid_to-T2w+raw_xfm-syn.nii.gz

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

## Citations:
### ANTs Registration
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

>Avants BB, Tustison NJ, Song G, Cook PA, Klein A, & Gee JC. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. Neuroimage, 54(3), 2033-2044. DOI:10.1016/j.neuroimage.2010.09.025 PMCID:PMC3065962

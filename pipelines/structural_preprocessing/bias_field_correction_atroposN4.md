# Bias field correction - Iterative N4 debiasing and segmentation [*atroposN4*]  
## Output:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/${subject}/${session}/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasAtroposN4.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-seg.nii.gz 
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-segPosteriors.nii.gz
```
## Code:
```bash
t1_image=${dir_prep}/${t1_prefix}_prep-denoise.nii.gz
brain_mask=${dir_prep}/${prefix}_prep-bex0Brain.nii.gz

echo "task: bias_correction_AtroposN4" >> ${subject_log}
echo "input_image: "${t1_image} >> ${subject_log}
echo "brain_mask: "${brain_mask} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsAtroposN4.sh \
  -d 3 \
  -a ${t1_image} \
  -x ${brain_mask} \
  -c 3 \
  -o ${dir_prep}/atroposN4_temp_

mv ${dir_prep}/atroposN4_temp_Segmentation0N4.nii.gz \
  ${dir_native}/${prefix}_T1w.nii.gz
#mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-tempSegmentation.nii.gz \
#  ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-seg.nii.gz
#mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-tempSegmentationPosteriors.nii.gz \
#  ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-segPosteriors.nii.gz
rm ${dir_prep}/atroposN4_temp*

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo "" >> ${subject_log}
```
### Citations:
>Tustison NJ, Avants BB, Cook PA, Zheng Y, Egan A, Yushkevich PA, & Gee JC. (2010). N4ITK: Improved N3 bias correction, IEEE Transactions on Medical Imaging, 29(6), 1310-1320. DOI:10.1109/TMI.2010.2046908 PMCID:PMC3071855

>Avants BB, Tustison NJ, Wu J, Cook PA, & Gee JC. (2011). An open source multivariate framework for n-tissue segmentation with evaluation on public data. Neuroinformatics, 9(4). DOI:10.1007/s12021-011-9109-y PMCID:PMC3297199

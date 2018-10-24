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
# User-defined (as necessary)
input_dir=derivatives/anat/prep/${subject}/${session}/
which_img=sub-${subject}_ses-${session}_T1w_prep-biasT1T2.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_prep-bex0Mask.nii.gz
output_prefix=sub-${subject}_ses-${session}_T1w_prep

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_bias_correction_AtroposN4' >> ${subjectect_log}
echo 'input_image:'${researcher}/${project}/${input_dir}/${which_img} >> ${subject_log}
echo 'brain_mask:'${brain_mask} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsAtroposN4.sh \
  -d 3 \
  -a ${researcher}/${project}/${input_dir}/${which_img} \
  -x ${brain_mask} \
  -c 3 \
  -o ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-temp

mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-tempN4Corrected.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-biasAtroposN4.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-tempSegmentation.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-seg.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-tempSegmentationPosteriors.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}-segPosteriors.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
### Citations:
>Tustison NJ, Avants BB, Cook PA, Zheng Y, Egan A, Yushkevich PA, & Gee JC. (2010). N4ITK: Improved N3 bias correction, IEEE Transactions on Medical Imaging, 29(6), 1310-1320. DOI:10.1109/TMI.2010.2046908 PMCID:PMC3071855

>Avants BB, Tustison NJ, Wu J, Cook PA, & Gee JC. (2011). An open source multivariate framework for n-tissue segmentation with evaluation on public data. Neuroinformatics, 9(4). DOI:10.1007/s12021-011-9109-y PMCID:PMC3297199

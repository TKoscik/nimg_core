# Tissue segmentation  
## Output:
```
${researcher}/${project}/derivatives/anat/
  ∟segmentation/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-CSF.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-GM.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-label.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-WM.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep/${subject}/${session}/
t1_img=sub-${subject}_ses-${session}_T1w_prep-biasN4.nii.gz
t2_img=sub-${subject}_ses-${session}_T2w_prep-biasN4.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-brain.nii.gz
output_prefix=sub-${subject}_ses-${session}_T1w_

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_segmentation_atropos' >> ${subjectect_log}
echo 'input_T1_image:'${researcher}/${project}/${input_dir}/${t1_img} >> ${subject_log}
echo 'input_T2_image:'${researcher}/${project}/${input_dir}/${t2_img} >> ${subject_log}
echo 'brain_mask:'${brain_mask} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsAtroposN4.sh \
  -d 3 \
  -a ${researcher}/${project}/${input_dir}/${t1_img} \
  -a ${researcher}/${project}/${input_dir}/${t2_img} \
  -x ${brain_mask} \
  -c 3 \
  -o ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}prep-temp

mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}prep-tempSegmentation.nii.gz \
  ${researcher}/${project}/derivatives/anat/segmentation/${output_prefix}seg-label.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}prep-tempSegmentationPosteriors1.nii.gz \
  ${researcher}/${project}/derivatives/anat/segmentation/${output_prefix}seg-CSF.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}prep-tempSegmentationPosteriors2.nii.gz \
  ${researcher}/${project}/derivatives/anat/segmentation/${output_prefix}seg-GM.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}prep-tempSegmentationPosteriors3.nii.gz \
  ${researcher}/${project}/derivatives/anat/segmentation/${output_prefix}seg-WM.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}prep-tempSegmentation0N4.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}prep-tempSegmentation1N4.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_prefix}prep-tempSegmentationConvergence.txt

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
### Citations:
>Avants BB, Tustison NJ, Wu J, Cook PA, & Gee JC. (2011). An open source multivariate framework for n-tissue segmentation with evaluation on public data. Neuroinformatics, 9(4). DOI:10.1007/s12021-011-9109-y PMCID:PMC3297199

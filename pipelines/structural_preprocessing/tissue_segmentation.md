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
t1_image=${dir_native}/${prefix}_T1w.nii.gz
t2_image=${dir_native}/${prefix}_T2w.nii.gz
brain_mask=${dir_mask}/${prefix}_mask-brain.nii.gz

echo 'task: structural_segmentation_atropos' >> ${subject_log}
echo 'input_image: '${t1_image} >> ${subject_log}
echo 'input_image: '${t2_image} >> ${subject_log}
echo 'brain_mask: '${brain_mask} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

Atropos \
-d 3 \
-a ${t1_image} \
-a ${t2_image} \
-x ${brain_mask} \
-o [${dir_seg}/${prefix}_seg-label.nii.gz,${dir_seg}/${prefix}_seg-Posterior%d.nii.gz] \
-c [5,0.0] \
-i kmeans[3] \
-k Gaussian \
-m [0.1,1x1x1] \
-r 1 \
-p Socrates[0] \
-v 1

mv ${dir_seg}/${prefix}_seg-Posterior1.nii.gz ${dir_seg}/${prefix}_seg-CSF.nii.gz
mv ${dir_seg}/${prefix}_seg-Posterior2.nii.gz ${dir_seg}/${prefix}_seg-GM.nii.gz
mv ${dir_seg}/${prefix}_seg-Posterior3.nii.gz ${dir_seg}/${prefix}_seg-WM.nii.gz

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
### Citations:
>Avants BB, Tustison NJ, Wu J, Cook PA, & Gee JC. (2011). An open source multivariate framework for n-tissue segmentation with evaluation on public data. Neuroinformatics, 9(4). DOI:10.1007/s12021-011-9109-y PMCID:PMC3297199

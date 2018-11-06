# Bias field correction - N4
## Output:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/sub-${subject}/ses-${session}/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasN4.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasN4.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep/sub-${subject}/ses-${session}/
which_img=sub-${subject}_ses-${session}_T1w_prep-biasT1T2.nii.gz
output_prefix=sub-${subject}_ses-${session}_T1w

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_bias_correction_N4' >> ${subject_log}
echo 'input_img:'${researcher}/${project}/${input_dir}/${which_img} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

N4BiasFieldCorrection \
  -d 3 \
  -i ${researcher}/${project}/${input_dir}/${which_img}
  -r 1 \
  -o [${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_prep-biasN4.nii.gz,${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/${output_prefix}_prep-biasFieldN4.nii.gz]

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
### Citations:
>Tustison NJ, Avants BB, Cook PA, Zheng Y, Egan A, Yushkevich PA, & Gee JC. (2010). N4ITK: Improved N3 bias correction, IEEE Transactions on Medical Imaging, 29(6), 1310-1320. DOI:10.1109/TMI.2010.2046908 PMCID:PMC3071855

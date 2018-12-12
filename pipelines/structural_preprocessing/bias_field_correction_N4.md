# Bias field correction - N4
## Output:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/sub-${subject}/ses-${session}/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasN4.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasFieldN4.nii.gz
```
## Code:
```bash
input_image=${dir_prep}/${t1_prefix}_prep-biasT1T2.nii.gz
output_dir=${dir_native}
output_prefix=${prefix}_T1w

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task: structural_bias_correction_N4' >> ${subject_log}
echo 'input_image: '${input_image} >> ${subject_log}
echo 'software: ANTS' >> ${subject_log}
echo 'version: '${ants_version} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

N4BiasFieldCorrection \
  -d 3 \
  -i ${input_image} \
  -r 1 \
  -o [${output_dir}/${output_prefix}.nii.gz,${dir_prep}/${output_prefix}_prep-biasFieldN4.nii.gz]

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
### Citations:
>Tustison NJ, Avants BB, Cook PA, Zheng Y, Egan A, Yushkevich PA, & Gee JC. (2010). N4ITK: Improved N3 bias correction, IEEE Transactions on Medical Imaging, 29(6), 1310-1320. DOI:10.1109/TMI.2010.2046908 PMCID:PMC3071855

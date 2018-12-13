# Bias field correction - T1/T2
## Output:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/sub-${subject}/ses-${session}/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasT1T2.nii.gz
  ∟sub-${subject}_ses-${session}_*_prep-biasFieldT1T2.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
t1_image=${dir_prep}/${t1_prefix}_prep-denoise.nii.gz
t2_image=${dir_prep}/${t2_prefix}_prep-denoise.nii.gz
brain_mask=${dir_prep}/${prefix}_prep-bex0Brain.nii.gz

echo 'task: bias_correction_T1T2' >> ${subject_log}
echo 'input_T1: '${t1_image} >> ${subject_log}
echo 'input_T2: '${t2_image} >> ${subject_log}
echo 'brain_mask: '${brain_mask} >> ${subject_log}
date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}

${nimg_core_root}/bias_field_correct_t1t2.sh \
  -a ${t1_image} \
  -b ${t2_image} \
  -m ${brain_mask} \
  -o ${dir_prep}

mv ${dir_prep}/biasT1T2_Field.nii.gz ${dir_prep}/${prefix}_prep-biasFieldT1T2.nii.gz
mv ${dir_prep}/biasT1T2_T1w.nii.gz ${dir_prep}/${t1_prefix}_prep-biasT1T2.nii.gz
mv ${dir_prep}/biasT1T2_T2w.nii.gz ${dir_prep}/${t2_prefix}_prep-biasT1T2.nii.gz

date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}
echo '' >> ${subject_log}
```
### Citations:
> Glasser MF & Van Essen DC. (2011). Mapping human cortical areas in vivo based on myelin content as revealed by T1- and T2-weighted MRI. The Journal of Neuroscience, 31(32), 11597-11616, DOI:10.1523/JNEUROSCI.2180-11.2011 PMCID:PMC3167149

>Rilling JK, Glasser MF, Jbabdi S, Andersson J, Preuss TM. (2011). Continuity, divergence, and the evolution of brain language pathways. Frontiers in Evolutionary Neuroscience, 3, 11. DOI:10.3389/fnevo.2011.00011 PMCID:PMC3249609

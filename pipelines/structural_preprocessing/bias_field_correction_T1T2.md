# Bias field correction - T1/T2
## Output:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/${subject}/${session}/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasT1T2.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasFieldT1T2.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep/${subject}/${session}/
t1_img=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz
t2_img=sub-${subject}_ses-${session}_T2w_prep-T1reg.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_prep-bex0Mask.nii.gz

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_bias_correction_T1T2' >> ${subject_log}
echo 'input_T1:'${researcher}/${project}/${input_dir}/${t1_img} >> ${subject_log}
echo 'input_T2:'${researcher}/${project}/${input_dir}/${t2_img} >> ${subject_log}
echo 'brain_mask:'${brain_mask} >> ${subject_log}
echo 'software:FSL' >> ${subject_log}
echo 'version:5.10.0' >> ${subject_log}
echo 'software:bias_field_correct_t1t2.sh' >> ${subject_log}
echo 'version:0' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

${nimg_core_root}/bias_field_correct_t1t2.sh \
  -a ${researcher}/${project}/${input_dir}/${t1_img} \
  -b ${researcher}/${project}/${input_dir}/${t2_img} \
  -m ${researcher}/${project}/${input_dir}/${brain_mask} \
  -o ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/

mv ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/sub-${subject}_ses-${session}_T1w_prep-biasFieldT1T2.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/sub-${subject}_ses-${session}_prep-biasFieldT1T2.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
### Citations:
> Glasser MF & Van Essen DC. (2011). Mapping human cortical areas in vivo based on myelin content as revealed by T1- and T2-weighted MRI. The Journal of Neuroscience, 31(32), 11597-11616, DOI:10.1523/JNEUROSCI.2180-11.2011 PMCID:PMC3167149

>Rilling JK, Glasser MF, Jbabdi S, Andersson J, Preuss TM. (2011). Continuity, divergence, and the evolution of brain language pathways. Frontiers in Evolutionary Neuroscience, 3, 11. DOI:10.3389/fnevo.2011.00011 PMCID:PMC3249609

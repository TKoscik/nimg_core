# Brain extraction
## AFNI 3dSkullStrip
## Output:
```
${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/
    ∟sub-${subject}_ses-${session}_*_prep-bex0AFNI.nii.gz     #preliminary
    ∟sub-${subject}_ses-${session}_*_prep-bexAFNI.nii.gz     #final
```
## Code:
```bash
t1_image=${dir_prep}/${t1_prefix}_prep-denoise.nii.gz
suffix=bex0  #change as needed to differentiate iterations, final iteration is bex (no number)

echo 'task: brain_extraction_AFNI' >> ${subject_log}
echo 'input: '${t1_image} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

# AFNI skull strip ----
3dSkullStrip \
  -input ${t1_image} \
  -prefix ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz
fslmaths ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz -bin ${dir_prep}/${prefix}_prep-${suffix}AFNI.nii.gz

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

## Citations:
### AFNI 3dSkullStrip:
>Cox RW. (1996). AFNI: Software for analysis and visualization of functional magnetic resonance neuroimages. Computational Biomedical Research, 29(3), 162-173. PMCID:8812068

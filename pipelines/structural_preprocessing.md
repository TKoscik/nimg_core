# Structural Preprocessing Pipeline

0. DICOM conversion to NIfTI  
  * Initialize folder structures  
  * Extract, sort, and name NIfTIs
  * Initialize log file with extraction entry
```
${researcherRoot}/${projectName}/nifti/${subject}/${ssession}/anat/
```

Everything below will be stored in the deriviatives folder:
```
${researcherRoot}/${projectName}/derivatives/
```

1. Gradient distortion unwarping [*GradUnwarp [Freesurfer?] https://surfer.nmr.mgh.harvard.edu/fswiki/GradUnwarp*]  
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-gradunwarp.nii.gz
```

2. Readout distortion correction [*figure out what this is*]  
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-readout.nii.gz
```

3. Rician denoising  
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-denoise.nii.gz
```
```
DenoiseImage \
  -d 3 \
  -i ${input_dir}/${input_file} \
  -n Rician \
  -o ${output_dir}/${output_prefix}_prep-denoise.nii.gz

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural image denoising: '${input_dir}/${input_file} >> ${subject_log}
echo 'timestamp: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo '' >> ${subject_log}
```
| *arguments* | *description* | *values* | *default* |
|-----------|-------------|--------|---------|
| -d | dimensionality | 2/3/4 | - |
| -i | input image | - | - |
| -n | noise model | Rician/Guassian | Gaussian |
| -o | output | [correctedImage,*noiseImage*] | - |
| -x | mask image | - | - |
| -s | shrink factor | 1/2/3/... | 1 |  
| -p | patch radius | 1 {1x1x1} | 1 |
| -r | search radius | 2 {2x2x2} | 2 |
| -v | verbose | 0/1 | 0 |  


4. ACPC Alignment  
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-acpc.nii.gz
```

5. Brain extraction (preliminary)  
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-bex0.nii.gz
```

6. Bias field correction  
  a. T1/T2 debiasing [*T1 and T2 co-acquisition*]  
  b. N4 debiasing [*T1 only acquisition*]  
  c. Iterative N4 debiasing and segmentation [*atroposN4*]  
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-bc.nii.gz
```

7. Within-session, within-modality averaging  
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-avg.nii.gz
```

8. Brain extraction  
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟mask/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_mask-brain.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_mask-tissue.nii.gz
```

9. Tissue segmentation  
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟segmentation/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-CSF.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-GM.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-WM.nii.gz
  ∟prep/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-?.nii.gz
```

10. Coregistration  [*within-session only*]  
  - coregistering multiple acquisitions of the same modality within a scanning session  
  - coregistering multiple modalities within scanning sessions  
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟native/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_native.nii.gz
  ∟tform/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${acq}${mod}_tform-0affine.mat
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${acq}${mod}_tform-1syn.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${acq}${mod}_tform-1inverse.nii.gz
```

11. Normalization
  - between session registrations, i.e., register to participant baseline or average  
  - registration to common space  
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟reg_${space}/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_reg-${space}.nii.gz
  ∟tform/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-0affine.mat
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-1syn.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-1inverse.nii.gz
```

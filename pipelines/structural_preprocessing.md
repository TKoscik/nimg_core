# Structural Preprocessing Pipeline

1. DICOM conversion to NIfTI  
```
${researcherRoot}/
  ∟${projectName}/
    ∟nifti/
      ∟${subject}/
        ∟${ssession}/
          ∟anat/
```

Everything below will be stored in the deriviatives folder:
```
${researcherRoot}/
  ∟${projectName}/
    ∟derivatives/
```
2. Gradient distortion unwarping [*GradUnwarp [Freesurfer?] https://surfer.nmr.mgh.harvard.edu/fswiki/GradUnwarp*]  
```
      ∟anat/
        ∟prep/ [optional]
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-gradunwarp.nii.gz
```
3. Readout distortion correction [*figure out what this is*]  
```
      ∟anat/
        ∟prep/ [optional]
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-readout.nii.gz
```
4. Rician denoising  
```
      ∟anat/
        ∟prep/ [optional]
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-denoise.nii.gz
```
5. ACPC Alignment  
```
      ∟anat/
        ∟prep/ [optional]
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-acpc.nii.gz
```
6. Brain extraction (preliminary)  
```
      ∟anat/
        ∟prep/ [optional]
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-bex0.nii.gz
```
7. Bias field correction  
  a. T1/T2 debiasing [*T1 and T2 co-acquisition*]  
  b. N4 debiasing [*T1 only acquisition*]  
  c. Iterative N4 debiasing and segmentation [*atroposN4*]  
```
      ∟anat/
        ∟prep/ [optional]
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-bc.nii.gz
```
8. Within-session, within-modality averaging  
```
      ∟anat/
        ∟prep/ [optional]
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-avg.nii.gz
```
9. Brain extraction  
```
      ∟anat/
        ∟mask/
        | ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_mask-brain.nii.gz
        | ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_mask-tissue.nii.gz
        ∟prep/ [optional]
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-bex.nii.gz
```
10. Tissue segmentation  
```
      ∟anat/
        ∟segmentation/
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-CSF.nii.gz
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-GM.nii.gz
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-WM.nii.gz
        ∟prep/ [optional]
          ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-?.nii.gz
```
11. Coregistration  [*within-session only*]  
  - coregistering multiple acquisitions of the same modality within a scanning session  
  - coregistering multiple modalities within scanning sessions  
```
      ∟anat/
      | ∟native/
      |   ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_native.nii.gz
      ∟tform/
        ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${acq}${mod}_tform-affine.mat
        ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${acq}${mod}_tform-syn.nii.gz
```
12. Normalization
  - between session registrations, i.e., register to participant baseline or average  
  - registration to common space  
```
      ∟anat/
      | ∟reg_${space}/
      |   ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_reg-${space}.nii.gz
      ∟tform/
        ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-0affine.mat
        ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-1syn.nii.gz
        ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-inverse.nii.gz
```

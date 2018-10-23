# Structural Preprocessing Pipeline

## 0. DICOM conversion to NIfTI  
  * Initialize folder structures  
  * Extract, sort, and name NIfTIs
  * Initialize log file with extraction entry
```
${researcherRoot}/${projectName}/nifti/${subject}/${ssession}/anat/
```

***

## 1. Gradient distortion unwarping
[*GradUnwarp [Freesurfer?] https://surfer.nmr.mgh.harvard.edu/fswiki/GradUnwarp*]  

### Save location:
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-gradunwarp.nii.gz
```

## 2. Readout distortion correction [*figure out what this is*]  

### Save location:
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-readout.nii.gz
```

## 3. Denoising  
Denoise an image using a spatially adaptive filter.  
> Manjon JV, Coupe P, Marti-Bonmati L, Collins DL, & Robles M. (2010). Adaptive non-local means denoising of MR images with spatially varying noise levels. Journal of Magnetic Resonance Imaging, 31, 192-203.  

### Save location:
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-denoise.nii.gz
```

### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_image_denoising: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

input_image=${input_dir}/${input_file}
output_image=${output_dir}/${output_prefix}_prep-denoise.nii.gz

DenoiseImage -d 3 -i ${input_image} -n Rician -o ${output_image}

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

| *arguments* | *description* | *values* | *default* |
|---|---|---|---|
| -d | dimensionality | 2/3/4 | - |  
| -i | input image | - | - |
| -n | noise model | Rician/Guassian | Gaussian |
| -o | output | [correctedImage,*noiseImage*] | - |
| -x | mask image | - | - |
| -s | shrink factor | 1/2/3/... | 1 |  
| -p | patch radius | 1 {1x1x1} | 1 |
| -r | search radius | 2 {2x2x2} | 2 |
| -v | verbose | 0/1 | 0 |  


##  4. ACPC Alignment  

### Save location:
```
 ${researcher}/${project}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-acpc.nii.gz
```

### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_acpc_alignment: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

input_dir=derivatives/anat/prep
which_image=<which image to process>
template_dir=${nimg_core}/templates
space=<which space>         # e.g., HCP2009c
template=<which template>   # e.g., MNI152_T1_0.8mm

input_image=${researcher}/${project}/${input_dir}/sub-${subject}_ses-${session}_${which_image}.nii.gz
output_prefix=${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_${which_image}_prep-acpc
tform_dir=${researcher}/${project}/derivatives/tform

antsRegistrationSyN.sh \
  -d 3 \
  -f ${template_dir}/${space}/${template} \
  -m ${input_image} \
  -t r \
  -o ${output_prefix}
    
mv ${output_prefix}Warped.nii.gz ${output_prefix}.nii.gz
mv ${output_prefix}0GenericAffine.mat ${tform_dir}/sub-${subject}_ses-${session}_ref-${space}_tform-0rigid.mat
rm ${output_prefix}InverseWarped.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

## 5. Brain extraction (preliminary)  

### Save location:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-bex0.nii.gz
```

## 6. Bias field correction  
  a. T1/T2 debiasing [*T1 and T2 co-acquisition*]  
  b. N4 debiasing [*T1 only acquisition*]  
  c. Iterative N4 debiasing and segmentation [*atroposN4*]  

### Save location:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-bc.nii.gz
```

## 7. Within-session, within-modality averaging  

### Save location:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-avg.nii.gz
```

## 8. Brain extraction  

### Save location:
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟mask/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_mask-brain.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_mask-tissue.nii.gz
```

## 9. Tissue segmentation  

### Save location:
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟segmentation/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-CSF.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-GM.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-WM.nii.gz
  ∟prep/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-?.nii.gz
```

## 10. Coregistration  [*within-session only*]  
  - coregistering multiple acquisitions of the same modality within a scanning session  
  - coregistering multiple modalities within scanning sessions  

### Save location:
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟native/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_native.nii.gz
  ∟tform/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${acq}${mod}_tform-0affine.mat
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${acq}${mod}_tform-1syn.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${acq}${mod}_tform-1inverse.nii.gz
```

## 11. Normalization
  - between session registrations, i.e., register to participant baseline or average  
  - registration to common space  

### Save location:
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟reg_${space}/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_reg-${space}.nii.gz
  ∟tform/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-0affine.mat
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-1syn.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-1inverse.nii.gz
```

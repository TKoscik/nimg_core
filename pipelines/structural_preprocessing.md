# Structural Preprocessing Pipeline

## DICOM conversion to NIfTI  
  * Initialize folder structures  
  * Extract, sort, and name NIfTIs
  * Initialize log file with extraction entry
```
${researcherRoot}/${projectName}/nifti/${subject}/${ssession}/anat/
```

***

## Script Parameters
### Neuroimaging core root directory
```bash
nimg_core_root=/Shared/nopoulos/nimg_core
```
### Root directory for project
${researcher}/${project} must give you the root directory for all processing steps
```bash
researcher=/Shared/researcher
project=imaging_project
```
### Template Space
```bash
template_dir=${nimg_core}/templates
space=HCP                            # folder name for template space to use
template=MNI_T1_0.8mm                # which template space to use
```

***

## Gradient distortion unwarping
[*GradUnwarp [Freesurfer?] https://surfer.nmr.mgh.harvard.edu/fswiki/GradUnwarp*]  
### Save location:
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-gradunwarp.nii.gz
```

***

## Readout distortion correction [*figure out what this is*]  
### Save location:
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-readout.nii.gz
```

***

## Denoising  
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

# User-defined (as necessary)
input_dir=/nifti/${subject}/${session}/anat
which_img=sub-${subject}_ses-${session}_T1w

DenoiseImage \
  -d 3 \
  -i ${researcher}/${project}/${input_dir}/${which_img}.nii.gz \
  -n Rician \
  -o ${researcher}/${project}/derivatives/anat/prep/${which_img}_prep-denoise.nii.gz

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

***

##  ACPC Alignment  
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

# User-defined (as necessary)
input_dir=derivatives/anat/prep     # location relative to researcher/project/
which_img=sub-${subject}_ses-${session}_T1w_prep-denoise.nii.gz

antsRegistrationSyN.sh \
  -d 3 \
  -f ${template_dir}/${space}/${template}.nii.gz \
  -m ${researcher}/${project}/${input_dir}/${which_image}.nii.gz \
  -t r \
  -o ${researcher}/${project}/derivatives/anat/prep/${which_image}_prep-acpc
    
mv ${output_prefix}Warped.nii.gz ${output_prefix}.nii.gz
mv ${output_prefix}0GenericAffine.mat ${researcher}/${project}/derivatives/tform/${which_img}_ref-${space}_tform-0rigid.mat
rm ${output_prefix}InverseWarped.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Within-modality averaging
### Save location:
```
 ${researcher}/${project}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-avg.nii.gz
```
### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_within_modality_averaging: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

# User-defined (as necessary)
input_dir=derivatives/anat/prep     # location relative to researcher/project/
which_imgs[0]=sub-${subject}_ses-${session}_run-1_T1w_prep-acpc.nii.gz
which_imgs[1]=sub-${subject}_ses-${session}_run-2_T1w_prep-acpc.nii.gz

# Find smallest pixel dimensions in each direction
pixdim[0]=1000 # arbitrarily large value (must be bigger than actual input)
pixdim[1]=1000
pixdim[2]=1000
for i in ${which_imgs[@]}; do
  IFS='x' read -r -a pixdimTemp <<< $(PrintHeader ${researcher}/${project}/${input_dir}/${i} 1)
  for j in {0..2}; do
    if (( $(echo "${pixdimTemp[${j}]} < ${pixdim[${j}]}" | bc -l) )); then
      pixdim[${j}]=${pixdimTemp[${j}]} 
    fi
  done
done

# Resample images to highest resolution
rs_imgs=()
for i in ${which_imgs[@]}; do
  new_prefix=$(basename -- "$i")
  new_prefix="${oname%_*}"
  rs_imgs+=${new_prefix}_prep-resample.nii.gz # append to new array for next step
  ResampleImage 3 ${researcher}/${project}/${input_dir}/${i} ${researcher}/${project}/derivatives/anat/prep/${new_prefix}_prep-resample.nii.gz 0 0
done

# create unbiased average of images
buildtemplateparallel.sh \
  -d 3 /
  -o ${prepdir}/sub-${subject}_ses-${session}_T${i}w_prep-avg.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${rs_imgs}

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

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

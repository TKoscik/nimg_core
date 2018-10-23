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
### ARGON HPC header
```bash
#! /bin/bash
#$ -N sub-subject_ses-session_jobDescription
#$ -M email-address@for.log
#$ -m bes
#$ -q CCOM,PINC,UI
#$ -pe smp 56
#$ -j y
#$ -o /Shared/researcher/imaging_project/log/hpc_output
```
| HPC Operator | Description |  
|---|---|  
| -N | job name, appended to output stream filename |  
| -M | email address for logging |  
| -m | email options |  
| -q | processing queue(s) |  
| -pe | number of slots, [see also -pe 56cpn 56 (full node)] |  
| -j | merge HPC error output into standard output stream |  
| -o | location to save output stream |  
| -e | location to save error stream |  
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
### Output:
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-gradunwarp.nii.gz
```

***

## Readout distortion correction [*figure out what this is*]  
### Output:
```
 ${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-readout.nii.gz
```

***

## Denoising  
Denoise an image using a spatially adaptive filter.  
> Manjon JV, Coupe P, Marti-Bonmati L, Collins DL, & Robles M. (2010). Adaptive non-local means denoising of MR images with spatially varying noise levels. Journal of Magnetic Resonance Imaging, 31, 192-203.  
### Output:
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
### Output:
```
 ${researcher}/${project}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-acpc.nii.gz
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
### Output:
```
 ${researcher}/${project}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-avg.nii.gz
```
### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_within_modality_average: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

# User-defined (as necessary)
input_dir=derivatives/anat/prep     # location relative to researcher/project/
which_imgs[0]=sub-${subject}_ses-${session}_run-1_T1w_prep-acpc.nii.gz
which_imgs[1]=sub-${subject}_ses-${session}_run-2_T1w_prep-acpc.nii.gz
output_name=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz

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
  -o {researcher}/${project}/derivatives/anat/prep/${output_name}_prep-avg.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${rs_imgs}

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Within-session, multimodal registration
### Output:
```
${researcher}/${project}/derivatives/
  ∟anat/
    ∟prep/
      ∟sub-${subject}_ses-${session}_*_${mod}_prep-T1reg.nii.gz
  ∟tform/
    ∟sub-${subject}_ses-${session}_*_${mod}_reg-T1_tform-0affine.nii.gz
    ∟sub-${subject}_ses-${session}_*_${mod}_reg-T1_tform-1syn.nii.gz
```
### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_within_session_multimodal_average: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

# User-defined (as necessary)
input_dir=derivatives/anat/prep
fixed_img=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz
moving_img=sub-${subject}_ses-${session}_T2w_prep-avg.nii.gz
output_prefix=sub-${subject}_ses-${session}_T2w

antsRegistrationSyN.sh -d 3 \
  -f ${researcher}/${project}/${input_dir}/${fixed_img} \
  -m ${researcher}/${project}/${input_dir}/${moving_img} \
  -o ${researcher}/${project}/derivatives/anat/prep/${output_prefix}_temp_ \
  -t s

# Edit final output names as necesary
mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}_temp_Warped.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${output_prefix}_prep-T1reg.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}_temp_0GenericAffine.mat \
  ${researcher}/${project}/derivatives/tform/${output_prefix}_reg-T1_tform-0affine.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}_temp_1Warp.nii.gz \
  ${researcher}/${project}/derivatives/tform/${output_prefix}_reg-T1_tform-1syn.nii.gz

rm ${researcher}/${project}/derivatives/anat/prep/${output_prefix}_temp_InverseWarped.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Brain extraction  
### Output:
```
${researcher}/${project}/derivatives/anat/
  ∟mask/
    ∟sub-${subject}_ses-${session}_mask-bex0.nii.gz     #preliminary
    ∟sub-${subject}_ses-${session}_mask-bex0Inverse.nii.gz  #preliminary
    ∟sub-${subject}_ses-${session}_mask-bex.nii.gz      #final
    ∟sub-${subject}_ses-${session}_mask-bexInverse.nii.gz   #final
  ∟prep/
    ∟sub-${subject}_ses-${session}_*_${mod}_prep-bex0.nii.gz  #preliminary
    ∟sub-${subject}_ses-${session}_*_${mod}_prep-bex.nii.gz   #final
    ∟sub-${subject}_ses-${session}_*_${mod}_prep-tissue.nii.gz   #final
```
### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_within_session_multimodal_average: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo 'software: FSL' >> ${subject_log}
echo 'version: 5.10.0' >> ${subject_log}
echo 'software: AFNI' >> ${subject_log}
echo 'version: 17.2.07' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

# User-defined (as necessary)
input_dir=derivatives/anat/prep
t1_img=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz
t2_img=sub-${subject}_ses-${session}_T2w_prep-T1reg.nii.gz
suffix=bex0  #change as needed to differentiate iterations, final iteration is bex (no number)

# ANTs brain extraction
antsBrainExtraction.sh \
  -d 3 \
  -a ${researcher}/${project}/${input_dir}/${t1_img} \
  -a ${researcher}/${project}/${input_dir}/${t2_img} \
  -e ${template_dir}/OASIS/T_template0.nii.gz \
  -m ${template_dir}/OASIS/T_template0_BrainCerebellumProbabilityMask.nii.gz \
  -f ${template_dir}/OASIS/T_template0_BrainCerebellumRegistrationMask.nii.gz \
  -o ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}

mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}BrainExtractionMask.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}ANTS.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}BrainExtractionBrain.nii.gz 
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}BrainExtractionPrior0GenericAffine.mat

# FSL brain extraction tool
bet \
  ${researcher}/${project}/${input_dir}/${t1_img} \
  ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}BET.nii.gz \
  -A2 ${researcher}/${project}/${input_dir}/${t2_img} \
  -m

mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}BET_mask.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}BET.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}*${suffix}BET_*skull*
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}*${suffix}BET_mesh*
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}*${suffix}BET_out*

# AFNI skull strip
3dSkullStrip \
  -input ${researcher}/${project}/${input_dir}/${t1_img} \
  -prefix ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}AFNI.nii.gz
fslmaths ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}AFNI.nii.gz \
  -bin ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}AFNI.nii.gz

# Majority-vote brain mask
fslmaths ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}ANTS.nii.gz \
  -add ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}BET.nii.gz \
  -add ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-${suffix}AFNI.nii.gz \
  -thr 2 -bin -ero -dilM -dilM -ero \
  ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-${suffix}.nii.gz

# Invert brain mask
fslmaths ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-${suffix}.nii.gz \
  -sub 1 -mul 1 \
  ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-${suffix}Inverse.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Bias field correction - T1/T2
### Output:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasT1T2.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasFieldT1T2.nii.gz
```
### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_bias_correction_T1T2: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: FSL' >> ${subject_log}
echo 'version: 5.10.0' >> ${subject_log}
echo 'software: bias_field_correct_t1t2.sh' >> ${subject_log}
echo 'version: 0' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

# User-defined (as necessary)
input_dir=derivatives/anat/prep
t1_img=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz
t2_img=sub-${subject}_ses-${session}_T2w_prep-T1reg.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_prep-bex0Mask.nii.gz

${nimg_core_root}/bias_field_correct_t1t2.sh \
  -a ${researcher}/${project}/${input_dir}/${t1_img} \
  -b ${researcher}/${project}/${input_dir}/${t2_img} \
  -m ${researcher}/${project}/${input_dir}/${brain_mask} \
  -o ${researcher}/${project}/derivatives/anat/prep

mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_T1w_prep-biasFieldT1T2.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_prep-biasFieldT1T2.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Bias field correction - N4
### Output:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasN4.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasN4.nii.gz
```
### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_bias_correction_N4: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

# User-defined (as necessary)
input_dir=derivatives/anat/prep
which_img=sub-${subject}_ses-${session}_T1w_prep-biasT1T2.nii.gz
output_prefix=sub-${subject}_ses-${session}_T1w

N4BiasFieldCorrection \
  -d 3 \
  -i ${researcher}/${project}/${input_dir}/${which_img}
  -r 1 \
  -o [${researcher}/${project}/derivatives/anat/prep/${output_prefix}_prep-biasN4.nii.gz,${researcher}/${project}/derivatives/anat/prep/${output_prefix}_prep-biasFieldN4.nii.gz]

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Bias field correction - Iterative N4 debiasing and segmentation [*atroposN4*]  
### Output:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-biasAtroposN4.nii.gz
  ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-biasFieldAtroposN4.nii.gz
```
### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_bias_correction_AtroposN4: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

# User-defined (as necessary)

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Tissue segmentation  
### Output:
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟segmentation/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-CSF.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-GM.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-WM.nii.gz
  ∟prep/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-?.nii.gz
```

## 11. Normalization
  *between session registrations, i.e., register to participant baseline or average  
  *registration to common space  
### Output:
```
${researcherRoot}/${projectName}/derivatives/anat/
  ∟reg_${space}/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_reg-${space}.nii.gz
  ∟tform/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-0affine.mat
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-1syn.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_ref-${space}_tform-1inverse.nii.gz
```


***

## Make Air Mask (for QC)
### Output:
```
${researcher}/${project}/derivatives/anat/
  ∟mask/
    ∟sub-${subject}_ses-${session}_mask-bex0Air.nii.gz  #preliminary
    ∟sub-${subject}_ses-${session}_mask-bexAir.nii.gz   #final
  ∟prep/
    ∟sub-${subject}_ses-${session}_*_${mod}_prep-bex0Air.nii.gz  #preliminary
    ∟sub-${subject}_ses-${session}_*_${mod}_prep-bexAir.nii.gz   #final
```
### Code:
```bash
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'structural_within_session_multimodal_average: '${input_dir}/${input_file} >> ${subject_log}
echo 'software: ANTs' >> ${subject_log}
echo 'version: 2.3.1' >> ${subject_log}
echo 'start_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

# User-defined (as necessary)
input_dir=derivatives/anat/prep
which_img=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz

antsRegistrationSyN.sh -d 3 \
  -f ${template_dir}/${space}/${template}_tissue_mask.nii.gz \
  -m ${researcher}/${project}/${input_dir}/${which_img} \
  -t s \
  -x ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-bexInverse.nii.gz \
  -o ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_T1w_prep-temp
rm ${researcher}/${project}/derivatives/anat/prep/*temp*.nii.gz

antsApplyTransforms -d 3 \
  -i ${progdir}/templates/${space}/${template}_air_mask.nii.gz \
  -r ${progdir}/templates/${space}/${template}_tissue_mask.nii.gz \
  -o ${prepdir}/sub-${subject}_ses-${session}_prep-air.nii.gz \
  -t [${prepdir}/sub-${subject}_ses-${session}_T1w_prep-normTissue0GenericAffine.mat,1] \
  -n NearestNeighbor
```

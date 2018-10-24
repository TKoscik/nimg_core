# Structural Preprocessing Pipeline
## Script Parameters
### ARGON HPC header
```bash
#! /bin/bash
#$ -N sub-subject_ses-session_prep-anat
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
 ${researcher}/${project}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-gradunwarp.nii.gz
```

***

## Readout distortion correction [*figure out what this is*]  
### Output:
```
 ${researcher}/${project}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-readout.nii.gz
```

***

## Denoising  
Denoise an image using a spatially adaptive filter.  
### Citations
> Manjon JV, Coupe P, Marti-Bonmati L, Collins DL, & Robles M. (2010). Adaptive non-local means denoising of MR images with spatially varying noise levels. Journal of Magnetic Resonance Imaging, 31, 192-203.  
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.
### Output:
```
 ${researcher}/${project}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-denoise.nii.gz
```
### Code:
```bash
# User-defined (as necessary)
input_dir=/nifti/${subject}/${session}/anat
which_img=sub-${subject}_ses-${session}_T1w

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_image_denoising' >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/${which_img}.nii.gz >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

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
# User-defined (as necessary)
input_dir=derivatives/anat/prep     # location relative to researcher/project/
which_img=sub-${subject}_ses-${session}_T1w_prep-denoise.nii.gz

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_acpc_alignment' >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/${which_image}.nii.gz >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

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
### Citations:
#### buildtemplateparallel.sh
>Avants BB, Yushkevich P, Pluta J, Minkoff D, Korczykowski M, Detre J, & Gee JC. (2010). The optimal template effect in hippocampus studies of diseased populations. Neuroimage, 49(3), 2957-2466. DOI:10.1016/j.neuroimage.2009.09.062 PMCID:PMC2818274
>Avants BB, Tustison NJ, Song G, Cook PA, Klein A, & Gee JC. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. Neuroimage, 54(3), 2033-2044. DOI:10.1016/j.neuroimage.2010.09.025 PMCID:PMC3065962
#### ANTs Registration
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.
>Avants BB, Tustison NJ, Song G, Cook PA, Klein A, & Gee JC. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. Neuroimage, 54(3), 2033-2044. DOI:10.1016/j.neuroimage.2010.09.025 PMCID:PMC3065962
### Output:
```
 ${researcher}/${project}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-avg.nii.gz
```
### Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep     # location relative to researcher/project/
which_imgs[0]=sub-${subject}_ses-${session}_run-1_T1w_prep-acpc.nii.gz
which_imgs[1]=sub-${subject}_ses-${session}_run-2_T1w_prep-acpc.nii.gz
output_name=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_within_modality_average' >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/sub-${subject}_ses-${session}_run-1_T1w_prep-acpc.nii.gz >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/sub-${subject}_ses-${session}_run-2_T1w_prep-acpc.nii.gz >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

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
### Citations:
#### ANTs Registration
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.
>Avants BB, Tustison NJ, Song G, Cook PA, Klein A, & Gee JC. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. Neuroimage, 54(3), 2033-2044. DOI:10.1016/j.neuroimage.2010.09.025 PMCID:PMC3065962
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
# User-defined (as necessary)
input_dir=derivatives/anat/prep
fixed_img=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz
moving_img=sub-${subject}_ses-${session}_T2w_prep-avg.nii.gz
output_prefix=sub-${subject}_ses-${session}_T2w

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_within_session_multimodal_average' >> ${subject_log}
echo 'fixed:'${researcher}/${project}/${input_dir}/${fixed_img} >> ${subject_log}
echo 'moving:'${researcher}/${project}/${input_dir}/${moving_img} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

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
### Citations:
### Output:
```
${researcher}/${project}/derivatives/anat/
  ∟mask/
    ∟sub-${subject}_ses-${session}_mask-bex0Brain.nii.gz     #preliminary
    ∟sub-${subject}_ses-${session}_mask-bex0Tissue.nii.gz  #preliminary
    ∟sub-${subject}_ses-${session}_mask-bexBrain.nii.gz      #final
    ∟sub-${subject}_ses-${session}_mask-bexTissue.nii.gz   #final
  ∟prep/
    ∟sub-${subject}_ses-${session}_*_${mod}_prep-bex0.nii.gz  #preliminary
    ∟sub-${subject}_ses-${session}_*_${mod}_prep-bex.nii.gz   #final
    ∟sub-${subject}_ses-${session}_*_${mod}_prep-tissue.nii.gz   #final
```
### Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep
t1_img=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz
t2_img=sub-${subject}_ses-${session}_T2w_prep-T1reg.nii.gz
suffix=bex0  #change as needed to differentiate iterations, final iteration is bex (no number)

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_within_session_multimodal_average' >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/${t1_img} >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/${t2_img} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'software:FSL' >> ${subject_log}
echo 'version:5.10.0' >> ${subject_log}
echo 'software:AFNI' >> ${subject_log}
echo 'version:17.2.07' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

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
  ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-${suffix}Brain.nii.gz

# Invert brain mask
fslmaths ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-${suffix}Brain.nii.gz \
  -sub 1 -mul 1 \
  ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-${suffix}Tissue.nii.gz

if [[ "${suffix}"="bex" ]]; then
  mv ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-${suffix}Brain.nii.gz \
    ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-brain.nii.gz
  mv ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-${suffix}Tissue.nii.gz \
    ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-tissue.nii.gz
fi

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
# User-defined (as necessary)
input_dir=derivatives/anat/prep
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
# User-defined (as necessary)
input_dir=derivatives/anat/prep
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
  -o [${researcher}/${project}/derivatives/anat/prep/${output_prefix}_prep-biasN4.nii.gz,${researcher}/${project}/derivatives/anat/prep/${output_prefix}_prep-biasFieldN4.nii.gz]

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Bias field correction - Iterative N4 debiasing and segmentation [*atroposN4*]  
### Output:
```
${researcherRoot}/${projectName}/derivatives/anat/prep/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasAtroposN4.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-seg.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-segPosteriors.nii.gz
```
### Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep
which_img=sub-${subject}_ses-${session}_T1w_prep-biasT1T2.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_prep-bex0Mask.nii.gz
output_prefix=sub-${subject}_ses-${session}_T1w_prep

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_bias_correction_AtroposN4' >> ${subjectect_log}
echo 'input_image:'${researcher}/${project}/${input_dir}/${which_img} >> ${subject_log}
echo 'brain_mask:'${brain_mask} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsAtroposN4.sh \
  -d 3 \
  -a ${researcher}/${project}/${input_dir}/${which_img} \
  -x ${brain_mask} \
  -c 3 \
  -o ${researcher}/${project}/derivatives/anat/prep/${output_prefix}-temp

mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}-tempN4Corrected.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${output_prefix}-biasAtroposN4.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}-tempSegmentation.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${output_prefix}-seg.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}-tempSegmentationPosteriors.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${output_prefix}-segPosteriors.nii.gz
  

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Tissue segmentation  
### Output:
```
${researcher}/${project}/derivatives/anat/
  ∟segmentation/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-CSF.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-CSF.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-GM.nii.gz
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_seg-WM.nii.gz
  ∟prep/
    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-?.nii.gz
```
### Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep
t1_img=sub-${subject}_ses-${session}_T1w_prep-biasN4.nii.gz
t2_img=sub-${subject}_ses-${session}_T2w_prep-biasN4.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-brain.nii.gz
output_prefix=sub-${subject}_ses-${session}_T1w_

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_segmentation_atropos' >> ${subjectect_log}
echo 'input_T1_image:'${researcher}/${project}/${input_dir}/${t1_img} >> ${subject_log}
echo 'input_T2_image:'${researcher}/${project}/${input_dir}/${t2_img} >> ${subject_log}
echo 'brain_mask:'${brain_mask} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

antsAtroposN4.sh \
  -d 3 \
  -a ${researcher}/${project}/${input_dir}/${t1_img} \
  -a ${researcher}/${project}/${input_dir}/${t2_img} \
  -x ${brain_mask} \
  -c 3 \
  -o ${researcher}/${project}/derivatives/anat/prep/${output_prefix}prep-temp

mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}prep-tempSegmentation.nii.gz \
  ${researcher}/${project}/derivatives/anat/segmentation/${output_prefix}seg-label.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}prep-tempSegmentationPosteriors1.nii.gz \
  ${researcher}/${project}/derivatives/anat/segmentation/${output_prefix}seg-CSFposterior.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}prep-tempSegmentationPosteriors2.nii.gz \
  ${researcher}/${project}/derivatives/anat/segmentation/${output_prefix}seg-GMposterior.nii.gz
mv ${researcher}/${project}/derivatives/anat/prep/${output_prefix}prep-tempSegmentationPosteriors3.nii.gz \
  ${researcher}/${project}/derivatives/anat/segmentation/${output_prefix}seg-WMposterior.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/${output_prefix}prep-tempSegmentation0N4.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/${output_prefix}prep-tempSegmentation1N4.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/${output_prefix}prep-tempSegmentationConvergence.txt

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

***

## Apply brain and tissue masks
### Output:
```
${researcher}/${project}/derivatives/anat/native/
  ∟sub-${subject}_ses-${session}_*_${mod}_brain.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_tissue.nii.gz
```
### Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep
which_img=sub-${subject}_ses-${session}_T1w_prep-biasN4.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-brain.nii.gz
tissue_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-tissue.nii.gz
output_prefix=sub-${subject}_ses-${session}_T1w_

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_bias_correction_T1T2' >> ${subject_log}
echo 'input_image:'${researcher}/${project}/${input_dir}/${which_img} >> ${subject_log}
echo 'brain_mask:'${brain_mask} >> ${subject_log}
echo 'tissue_mask:'${tissue_mask} >> ${subject_log}
echo 'software:FSL' >> ${subject_log}
echo 'version:5.10.0' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

fslmaths \
  ${researcher}/${project}/${input_dir}/${which_img} \
  -mas ${brain_mask} \
  ${researcher}/${project}/derivatives/anat/native/${output_prefix}brain.nii.gz

fslmaths \
  ${researcher}/${project}/${input_dir}/${which_img} \
  -mas ${tissue_mask} \
  ${researcher}/${project}/derivatives/anat/native/${output_prefix}tissue.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

## Normalization
### Output:
```
∟reg_${space}_${template}/
    ∟sub-${subject}_ses-${session}_*_${mod}_reg-${space}_${template}.nii.gz
  ∟tform/
    ∟sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat
    ∟sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.nii.gz
    ∟sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1inverse.nii.gz
```
### Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/native
brain_img[0]=sub-${subject}_ses-${session}_T1w_brain.nii.gz
tissue_img[0]=sub-${subject}_ses-${session}_T1w_tissue.nii.gz
brain_img[1]=sub-${subject}_ses-${session}_T2w_brain.nii.gz
tissue_img[1]=sub-${subject}_ses-${session}_T2w_tissue.nii.gz
brain_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-brain.nii.gz
tissue_mask=${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-tissue.nii.gz
template_mod[0]=MNI_T1_0.8mm
template_mod[1]=MNI_T2_0.8mm
output_prefix[0]=sub-${subject}_ses-${session}_T1w_
output_prefix[1]=sub-${subject}_ses-${session}_T2w_


echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_normalization' >> ${subject_log}
echo 'input_brain_image:'${researcher}/${project}/${input_dir}/${brain_img[0]} >> ${subject_log}
echo 'input_tissue_image:'${researcher}/${project}/${input_dir}/${tissue_img[0]} >> ${subject_log}
echo 'template_space:'${nimg_core_root}/templates/${space}/${template[0]} >> ${subject_log}
echo 'input_brain_image:'${researcher}/${project}/${input_dir}/${brain_img[1]} >> ${subject_log}
echo 'input_tissue_image:'${researcher}/${project}/${input_dir}/${tissue_img[1]} >> ${subject_log}
echo 'template_space:'${nimg_core_root}/templates/${space}/${template[1]} >> ${subject_log}
echo 'brain_mask:'${brain_mask} >> ${subject_log}
echo 'tissue_mask:'${tissue_mask} >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

template_space=${nimg_core_root}/templates/${space}
img_path=${researcher}/${project}/${input_dir}

antsRegistration \
  -d 3 \
  --float 1 \
  --verbose 1 \
  -u 1 \
  -w [0.01,0.99] \
  -z 1 \
  -r [${template_space}/${template[0]}.nii.gz,${img_path}/${brain_img[0]},1] \
  -t Rigid[0.1] \
  -m MI[${template_space}/${template_mod[0]}_brain.nii.gz,${img_path}/${brain_img[0]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[0]}_tissue.nii.gz,${img_path}/${tissue_img[0]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[1]}_brain.nii.gz,${img_path}/${brain_img[1]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[1]}_tissue.nii.gz,${img_path}/${tissue_img[1]},1,32,Regular,0.25] \
  -c [1000x500x250x0,1e-6,10] \
  -f 6x4x2x1 \
  -s 4x2x1x0 \
  -t Affine[0.1] \
  -m MI[${template_space}/${template_mod[0]}_brain.nii.gz,${img_path}/${brain_img[0]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[0]}_tissue.nii.gz,${img_path}/${tissue_img[0]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[1]}_brain.nii.gz,${img_path}/${brain_img[1]},1,32,Regular,0.25] \
  -m MI[${template_space}/${template_mod[1]}_tissue.nii.gz,${img_path}/${tissue_img[1]},1,32,Regular,0.25] \
  -c [1000x500x250x0,1e-6,10] \
  -f 6x4x2x1 \
  -s 4x2x1x0 \
  -t SyN[0.1,3,0] \
  -m CC[${template_space}/${template_mod[0]}_brain.nii.gz,${img_path}/${brain_img[0]},1,4] \
  -m CC[${template_space}/${template_mod[0]}_tissue.nii.gz,${img_path}/${tissue_img[0]},1,4] \
  -m CC[${template_space}/${template_mod[1]}_brain.nii.gz,${img_path}/${brain_img[1]},1,4] \
  -m CC[${template_space}/${template_mod[1]}_tissue.nii.gz,${img_path}/${tissue_img[1]},1,4] \
  -c [100x100x70x20,1e-9,10] \
  -f 6x4x2x1 \
  -s 3x2x1x0vox \
  -o ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_temp_

mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_temp_0GenericAffine.mat \
  ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat
mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_temp_1Warp.nii.gz \
  ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat
mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}_ses-${session}_temp_1InverseWarp.nii.gz \
  ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1inverse.mat

antsApplyTransforms \
  -d 3 \
  --float 1 \
  -i ${img_path}/${brain_img[0]} \
  -o ${researcher}/${project}/derivatives/anat/reg_${space}_${template}/${output_prefix[0]}brain.nii.gz \
  -r ${template_space}/${template_mod[0]}_brain.nii.gz \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat

antsApplyTransforms \
  -d 3 \
  --float 1 \
  -i ${img_path}/${tissue_img[0]} \
  -o ${researcher}/${project}/derivatives/anat/reg_${space}_${template}/${output_prefix[0]}tissue.nii.gz \
  -r ${template_space}/${template_mod[0]}_tissue.nii.gz \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat

antsApplyTransforms \
  -d 3 \
  --float 1 \
  -i ${img_path}/${brain_img[1]} \
  -o ${researcher}/${project}/derivatives/anat/reg_${space}_${template}/${output_prefix[1]}brain.nii.gz \
  -r ${template_space}/${template_mod[1]}_brain.nii.gz \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat

antsApplyTransforms \
  -d 3 \
  --float 1 \
  -i ${img_path}/${tissue_img[1]} \
  -o ${researcher}/${project}/derivatives/anat/reg_${space}_${template}/${output_prefix[1]}tissue.nii.gz \
  -r ${template_space}/${template_mod[1]}_tissue.nii.gz \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1syn.mat \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat

# make air mask
antsApplyTransforms \
  -d 3 \
  -i ${nimg_core_root}/templates/${space}/${template}_air_mask.nii.gz \
  -o ${researcher}/${project}/derivatives/anat/mask/sub-${subject}_ses-${session}_mask-air.nii.gz \
  -r ${tissue_mask} \
  -t ${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-1invers.mat \
  -t [${researcher}/${project}/derivatives/tform/sub-${subject}_ses-${session}_reg-${space}_${template}_tform-0affine.mat,1]

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```

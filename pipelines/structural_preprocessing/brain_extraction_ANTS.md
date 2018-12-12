# Brain extraction
## ANTs
## Output:
```
${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/
    ∟sub-${subject}_ses-${session}_*_prep-bex0ANTS.nii.gz     #preliminary
    ∟sub-${subject}_ses-${session}_*_prep-bexANTS.nii.gz     #final
```
## Code:
```bash
t1_image=${dir_prep}/${t1_prefix}_prep-denoise.nii.gz
t2_image=${dir_prep}/${t2_prefix}_prep-denoise.nii.gz
suffix=bex0  #change as needed to differentiate iterations, final iteration is bex (no number)

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task: structural_brain_extraction_ ANTS' >> ${subject_log}
echo 'input: '${t1_image} >> ${subject_log}
echo 'input: '${t2_image} >> ${subject_log}
echo 'software: ANTS' >> ${subject_log}
echo 'version: '${ants_version} >> ${subject_log}
date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}

# ANTs brain extraction ----
antsBrainExtraction.sh \
  -d 3 \
  -a ${t1_image} \
  -a ${t2_image} \
  -e ${dir_template}/OASIS/T_template0.nii.gz \
  -m ${dir_template}/OASIS/T_template0_BrainCerebellumProbabilityMask.nii.gz \
  -f ${dir_template}/OASIS/T_template0_BrainCerebellumRegistrationMask.nii.gz \
  -o ${dir_prep}/${prefix}_prep-${suffix}
mv ${dir_prep}/${prefix}_prep-${suffix}BrainExtractionMask.nii.gz \
  ${dir_prep}/${prefix}_prep-${suffix}ANTS.nii.gz
rm ${dir_prep}/${prefix}_prep-${suffix}BrainExtractionBrain.nii.gz 
rm ${dir_prep}/${prefix}_prep-${suffix}BrainExtractionPrior0GenericAffine.mat

date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations:
### ANTs Brain Extraction:
> Avants BB & Tustison NJ. (2018). ANTs/ANTsR brain templates. https://figshare.com/articles/ANTs_ANTsR_Brain_Templates/915436 DOI:10.6084/m9.figshare.915436.v2

>Tustison NJ, Cook PA, Klein A, Song G, Das SR, Dud JT, Kandel BM, van Strien N, Stone JR, Gee JC, & Avants BB. (2014). Large-scale evaluation of ANTs and FreeSurfer cortical thickness measurements. Neuroimage, 99, 166-179. DOI:10.1016/j.neuroimage.2014.05.044 PMCID:24879923
### FSL Brain Extraction Tool:

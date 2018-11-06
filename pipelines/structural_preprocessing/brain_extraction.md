# Brain extraction
## Output:
```
${researcher}/${project}/derivatives/anat/
  ∟mask/
    ∟sub-${subject}_ses-${session}_mask-bex0Brain.nii.gz     #preliminary
    ∟sub-${subject}_ses-${session}_mask-bex0Tissue.nii.gz  #preliminary
    ∟sub-${subject}_ses-${session}_mask-brain.nii.gz      #final
    ∟sub-${subject}_ses-${session}_mask-tissue.nii.gz   #final
```
## Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep/sub-${subject}/ses-${session}/
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
  -o ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}

mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}BrainExtractionMask.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}ANTS.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}BrainExtractionBrain.nii.gz 
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}BrainExtractionPrior0GenericAffine.mat

# FSL brain extraction tool
bet \
  ${researcher}/${project}/${input_dir}/${t1_img} \
  ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}BET.nii.gz \
  -A2 ${researcher}/${project}/${input_dir}/${t2_img} \
  -m

mv ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}BET_mask.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}BET.nii.gz
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}*${suffix}BET_*skull*
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}*${suffix}BET_mesh*
rm ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}*${suffix}BET_out*

# AFNI skull strip
3dSkullStrip \
  -input ${researcher}/${project}/${input_dir}/${t1_img} \
  -prefix ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}AFNI.nii.gz
fslmaths ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}AFNI.nii.gz \
  -bin ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}AFNI.nii.gz

# Majority-vote brain mask
fslmaths ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}ANTS.nii.gz \
  -add ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}BET.nii.gz \
  -add ${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}/sub-${subject}_ses-${session}_prep-${suffix}AFNI.nii.gz \
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
## Citations:
### ANTs Brain Extraction:
> Avants BB & Tustison NJ. (2018). ANTs/ANTsR brain templates. https://figshare.com/articles/ANTs_ANTsR_Brain_Templates/915436 DOI:10.6084/m9.figshare.915436.v2

>Tustison NJ, Cook PA, Klein A, Song G, Das SR, Dud JT, Kandel BM, van Strien N, Stone JR, Gee JC, & Avants BB. (2014). Large-scale evaluation of ANTs and FreeSurfer cortical thickness measurements. Neuroimage, 99, 166-179. DOI:10.1016/j.neuroimage.2014.05.044 PMCID:24879923
### FSL Brain Extraction Tool:
>Smith SM. (2002). Fast robust automated brain extraction. Human Brain Mapping, 17(3), 143-155. DOI:10.1002/hbm.10062 PMCID:12391568
### AFNI 3dSkullStrip:
>Cox RW. (1996). AFNI: Software for analysis and visualization of functional magnetic resonance neuroimages. Computational Biomedical Research, 29(3), 162-173. PMCID:8812068

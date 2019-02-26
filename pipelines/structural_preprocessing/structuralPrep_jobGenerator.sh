#! /bin/bash

# Edit Here -------------------------------------------------------------------
researcher=/Shared/researcher
project=project_name
group=Research-grouplab
subject=123
session=12345abcde
site=00001
t1_prefix=sub-${subject}_ses-${session}_site-${site}_acq-sagMPRAGEPROMO_T1w
t2_prefix=sub-${subject}_ses-${session}_site-${site}_acq-sagCUBEPROMO_T2w
prefix=sub-${subject}_ses-${session}_site-${site}
space=NIHPDa045085
template=1mm
email="timothy-koscik@uiowa.edu"
queue=CCOM,UI,PINC
parallel="-pe 56cpn 56"
# -----------------------------------------------------------------------------

job_dir=${researcher}/${project}/code/structuralPrep_jobs
mkdir -p ${job_dir}
job_name=${job_dir}/sub-${subject}_ses-${session}_site-${site}_structuralPrep.job

echo 'Writing '${job_name}
echo '#! /bin/bash' > ${job_name}
echo '#$ -M '${email} >> ${job_name}
echo '#$ -m es' >> ${job_name}
echo '#$ -q '${queue} >> ${job_name}
echo '#$ '${parallel} >> ${job_name}
echo '#$ -j y' >> ${job_name}
echo '#$ -o '${researcher}/${project}'/log/hpc_output/' >> ${job_name}
echo '' >> ${job_name}
echo 'pipeline_start=$(date +%Y-%m-%dT%H:%M:%S%z)' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Set Up Software' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'module load OpenBLAS' >> ${job_name}
echo 'nimg_core_root=/Shared/nopoulos/nimg_core' >> ${job_name}
echo 'source /Shared/pinc/sharedopt/apps/sourcefiles/afni_source.sh' >> ${job_name}
echo 'afni_version=${AFNIDIR##*/}' >> ${job_name}
echo 'source /Shared/pinc/sharedopt/apps/sourcefiles/ants_source.sh' >> ${job_name}
echo 'ants_version=$(echo "${ANTSPATH}" | cut -d "/" -f9)' >> ${job_name}
echo 'fsl_version=6.0.0_multicore' >> ${job_name}
echo 'source /Shared/pinc/sharedopt/apps/sourcefiles/fsl_source.sh ${fsl_source}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Specify Analysis Variables' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'researcher='${researcher} >> ${job_name}
echo 'project='${project} >> ${job_name}
echo 'subject='${subject} >> ${job_name}
echo 'session='${session} >> ${job_name}
echo 'site='${site} >> ${job_name}
echo 'space='${space} >> ${job_name}
echo 'template='${template} >> ${job_name}
echo 'group='${group} >> ${job_name}
echo '' >> ${job_name}
echo '# Set file prefixes' >> ${job_name}
echo 't1_prefix='${t1_prefix} >> ${job_name}
echo 't2_prefix='${t2_prefix} >> ${job_name}
echo 'prefix='${prefix} >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Initial Log Entry' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'mkdir -p ${researcher}/${project}/log/hpc_output' >> ${job_name}
echo 'subject_log=${researcher}/${project}/log/sub-${subject}_ses-${session}_site-${site}.log' >> ${job_name}
echo 'echo "#--------------------------------------------------------------------------------" >> ${subject_log}' >> ${job_name}
echo 'echo "task: structural_preprocessing_pipeline_T1T2" >> ${subject_log}' >> ${job_name}
echo 'echo "software: AFNI" >> ${subject_log}' >> ${job_name}
echo 'echo "version: "${afni_version} >> ${subject_log}' >> ${job_name}
echo 'echo "software: ANTs" >> ${subject_log}' >> ${job_name}
echo 'echo "version: "${ants_version} >> ${subject_log}' >> ${job_name}
echo 'echo "software: FSL" >> ${subject_log}' >> ${job_name}
echo 'echo "version: "${fsl_version} >> ${subject_log}' >> ${job_name}
echo 'echo "start_time: "${pipeline_start} >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Initialize Output Folders' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'dir_raw=${researcher}/${project}/nifti/sub-${subject}/ses-${session}/anat' >> ${job_name}
echo 'dir_native=${researcher}/${project}/derivatives/anat/native' >> ${job_name}
echo 'dir_mask=${researcher}/${project}/derivatives/anat/mask' >> ${job_name}
echo 'dir_prep=${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session}'>> ${job_name}
echo 'dir_xfm=${researcher}/${project}/derivatives/xfm/sub-${subject}/ses-${session}'>> ${job_name}
echo 'dir_template=${nimg_core_root}/templates_human' >> ${job_name}
echo 'dir_norm=${researcher}/${project}/derivatives/anat/reg_${space}_${template}' >> ${job_name}
echo 'dir_jac=${researcher}/${project}/derivatives/anat/jac_${space}_${template}' >> ${job_name}
echo 'dir_seg=${researcher}/${project}/derivatives/anat/segmentation' >> ${job_name}
echo '' >> ${job_name}
echo 'if [ ! -d "${researcher}/${project}/derivatives" ]; then' >> ${job_name}
echo 'mkdir -p ${researcher}/${project}/derivatives' >> ${job_name}
echo 'chgrp -R ${group} ${researcher}/${project}/derivatives' >> ${job_name}
echo 'chmod -R g+rw ${researcher}/${project}/derivatives' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${researcher}/${project}/derivatives/anat" ]; then' >> ${job_name}
echo 'mkdir -p ${researcher}/${project}/derivatives/anat' >> ${job_name}
echo 'chgrp -R ${group} ${researcher}/${project}/derivatives/anat' >> ${job_name}
echo 'chmod -R g+rw ${researcher}/${project}/derivatives/anat' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${researcher}/${project}/derivatives/anat/prep" ]; then' >> ${job_name}
echo 'mkdir -p ${researcher}/${project}/derivatives/anat/prep' >> ${job_name}
echo 'chgrp -R ${group} ${researcher}/${project}/derivatives/anat/prep' >> ${job_name}
echo 'chmod -R g+rw ${researcher}/${project}/derivatives/anat/prep' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${researcher}/${project}/derivatives/anat/prep/sub-${subject}" ]; then' >> ${job_name}
echo 'mkdir -p ${researcher}/${project}/derivatives/anat/prep/sub-${subject}' >> ${job_name}
echo 'chgrp -R ${group} ${researcher}/${project}/derivatives/anat/prep/sub-${subject}' >> ${job_name}
echo 'chmod -R g+rw ${researcher}/${project}/derivatives/anat/prep/sub-${subject}' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${researcher}/${project}/derivatives/xfm" ]; then' >> ${job_name}
echo 'mkdir -p ${researcher}/${project}/derivatives/xfm' >> ${job_name}
echo 'chgrp -R ${group} ${researcher}/${project}/derivatives/xfm' >> ${job_name}
echo 'chmod -R g+rw ${researcher}/${project}/derivatives/xfm' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${dir_native}" ]; then' >> ${job_name}
echo 'mkdir -p ${dir_native}' >> ${job_name}
echo 'chgrp -R ${group} ${dir_native}' >> ${job_name}
echo 'chmod -R g+rw ${dir_native}' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${dir_mask}" ]; then' >> ${job_name}
echo 'mkdir -p ${dir_mask}' >> ${job_name}
echo 'chgrp -R ${group} ${dir_mask}' >> ${job_name}
echo 'chmod -R g+rw ${dir_mask}' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${dir_prep}" ]; then' >> ${job_name}
echo 'mkdir -p ${dir_prep}' >> ${job_name}
echo 'chgrp -R ${group} ${dir_prep}' >> ${job_name}
echo 'chmod -R g+rw ${dir_prep}' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${dir_xfm}" ]; then' >> ${job_name}
echo 'mkdir -p ${dir_xfm}' >> ${job_name}
echo 'chgrp -R ${group} ${dir_xfm}' >> ${job_name}
echo 'chmod -R g+rw ${dir_xfm}' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${dir_norm}" ]; then' >> ${job_name}
echo 'mkdir -p ${dir_norm}' >> ${job_name}
echo 'chgrp -R ${group} ${dir_norm}' >> ${job_name}
echo 'chmod -R g+rw ${dir_norm}' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${dir_jac}" ]; then' >> ${job_name}
echo 'mkdir -p ${dir_jac}' >> ${job_name}
echo 'chgrp -R ${group} ${dir_jac}' >> ${job_name}
echo 'chmod -R g+rw ${dir_jac}' >> ${job_name}
echo 'fi' >> ${job_name}
echo 'if [ ! -d "${dir_seg}" ]; then' >> ${job_name}
echo 'mkdir -p ${dir_seg}' >> ${job_name}
echo 'chgrp -R ${group} ${dir_seg}' >> ${job_name}
echo 'chmod -R g+rw ${dir_seg}' >> ${job_name}
echo 'fi' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Rigid Alignment - T1' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'target=T1w' >> ${job_name}
echo 'moving_image=${dir_raw}/${t1_prefix}.nii.gz' >> ${job_name}
echo 'fixed_image=${dir_template}/${space}/${template}/${space}_${template}_${target}.nii.gz' >> ${job_name}
echo 'output_prefix=${t1_prefix}' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: rigid_alignment" >> ${subject_log}' >> ${job_name}
echo 'echo "fixed_image: "${fixed_image} >> ${subject_log}' >> ${job_name}
echo 'echo "moving_image: "${moving_image} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'antsRegistration \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  --float 1 \' >> ${job_name}
echo '  --verbose 1 \' >> ${job_name}
echo '  -u 1 \' >> ${job_name}
echo '  -z 1 \' >> ${job_name}
echo '  -q [${fixed_image},${moving_image},1] \' >> ${job_name}
echo '  -t Rigid[0.1] \' >> ${job_name}
echo '  -m MI[${fixed_image},${moving_image},1,32,Regular,0.25] \' >> ${job_name}
echo '  -c [1000x500x250x100,1e-6,10] \' >> ${job_name}
echo '  -f 8x4x2x1 \' >> ${job_name}
echo '  -s 3x2x1x0vox \' >> ${job_name}
echo '  -o ${dir_prep}/temp_' >> ${job_name}
echo '' >> ${job_name}
echo 'antsApplyTransforms -d 3 \' >> ${job_name}
echo '  -i ${moving_image} \' >> ${job_name}
echo '  -o ${dir_prep}/${output_prefix}_prep-rigid.nii.gz \' >> ${job_name}
echo '  -t ${dir_prep}/temp_0GenericAffine.mat \' >> ${job_name}
echo '  -r ${moving_image}' >> ${job_name}
echo '' >> ${job_name}
echo 'mv ${dir_prep}/temp_0GenericAffine.mat ${dir_xfm}/${prefix}_from-${target}+raw_to-${space}+${template}_xfm-rigid.mat' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Denoising - T1' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'input_image=${dir_prep}/${t1_prefix}_prep-rigid.nii.gz' >> ${job_name}
echo 'output_prefix=${t1_prefix}' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: image_denoising" >> ${subject_log}' >> ${job_name}
echo 'echo "input: "${input_image} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'DenoiseImage \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  -i ${input_image} \' >> ${job_name}
echo '  -n Rician \' >> ${job_name}
echo '  -o [${dir_prep}/${output_prefix}_prep-denoise.nii.gz,${dir_prep}/${output_prefix}_prep-noise.nii.gz] \' >> ${job_name}
echo '  -s 1 \' >> ${job_name}
echo '  -p 1 \' >> ${job_name}
echo '  -r 2 \' >> ${job_name}
echo '  -v 1' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Within-Session, Multimodal Registration' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'fixed_image=${dir_prep}/${t1_prefix}_prep-rigid.nii.gz' >> ${job_name}
echo 'moving_image=${dir_raw}/${t2_prefix}.nii.gz' >> ${job_name}
echo 'output_prefix=${t2_prefix}' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: within-session_T2w_to_T1w" >> ${subject_log}' >> ${job_name}
echo 'echo "fixed: "${fixed_image} >> ${subject_log}' >> ${job_name}
echo 'echo "moving: "${moving_image} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'antsRegistration \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  --float 1 \' >> ${job_name}
echo '  --verbose 1 \' >> ${job_name}
echo '  -u 1 \' >> ${job_name}
echo '  -z 1 \' >> ${job_name}
echo '  -r [${fixed_image},${moving_image},1] \' >> ${job_name}
echo '  -t Rigid[0.1] \' >> ${job_name}
echo '  -m MI[${fixed_image},${moving_image},1,32,Regular,0.25] \' >> ${job_name}
echo '  -c [1000x500x250x100,1e-6,10] \' >> ${job_name}
echo '  -f 8x4x2x1 \' >> ${job_name}
echo '  -s 3x2x1x0vox \' >> ${job_name}
echo '  -t Affine[0.1] \' >> ${job_name}
echo '  -m MI[${fixed_image},${moving_image},1,32,Regular,0.25] \' >> ${job_name}
echo '  -c [1000x500x250x100,1e-6,10] \' >> ${job_name}
echo '  -f 8x4x2x1 \' >> ${job_name}
echo '  -s 3x2x1x0vox \' >> ${job_name}
echo '  -o [${dir_prep}/temp_,${dir_prep}/${output_prefix}_prep-rigid.nii.gz]' >> ${job_name}
echo '' >> ${job_name}
echo 'mv ${dir_prep}/temp_0GenericAffine.mat ${dir_xfm}/${prefix}_from-T2w+raw_to-T1w+rigid_xfm-affine.mat' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Denoising - T2' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'input_image=${dir_prep}/${t2_prefix}_prep-rigid.nii.gz' >> ${job_name}
echo 'output_prefix=${t2_prefix}' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: image_denoising" >> ${subject_log}' >> ${job_name}
echo 'echo "input: "${input_image} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'DenoiseImage \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  -i ${input_image} \' >> ${job_name}
echo '  -n Rician \' >> ${job_name}
echo '  -o [${dir_prep}/${output_prefix}_prep-denoise.nii.gz,${dir_prep}/${output_prefix}_prep-noise.nii.gz] \' >> ${job_name}
echo '  -s 1 \' >> ${job_name}
echo '  -p 1 \' >> ${job_name}
echo '  -r 2 \' >> ${job_name}
echo '  -v 1' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo '' >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Preliminary Brain Extraction' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 't1_image=${dir_prep}/${t1_prefix}_prep-denoise.nii.gz' >> ${job_name}
echo 't2_image=${dir_prep}/${t2_prefix}_prep-denoise.nii.gz' >> ${job_name}
echo 'suffix=bex0 #change as needed to differentiate iterations, final iteration is bex (no number)' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: brain_extraction_ANTS" >> ${subject_log}' >> ${job_name}
echo 'echo "input: "${t1_image} >> ${subject_log}' >> ${job_name}
echo 'echo "input: "${t2_image} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'antsBrainExtraction.sh \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  -a ${t1_image} \' >> ${job_name}
echo '  -a ${t2_image} \' >> ${job_name}
echo '  -e ${dir_template}/OASIS/T_template0.nii.gz \' >> ${job_name}
echo '  -m ${dir_template}/OASIS/T_template0_BrainCerebellumProbabilityMask.nii.gz \' >> ${job_name}
echo '  -f ${dir_template}/OASIS/T_template0_BrainCerebellumRegistrationMask.nii.gz \' >> ${job_name}
echo '  -o ${dir_prep}/${prefix}_prep-${suffix}' >> ${job_name}
echo '' >> ${job_name}
echo 'mv ${dir_prep}/${prefix}_prep-${suffix}BrainExtractionMask.nii.gz \' >> ${job_name}
echo '${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz' >> ${job_name}
echo 'rm ${dir_prep}/${prefix}_prep-${suffix}BrainExtractionBrain.nii.gz' >> ${job_name}
echo 'rm ${dir_prep}/${prefix}_prep-${suffix}BrainExtractionPrior0GenericAffine.mat' >> ${job_name}
echo '' >> ${job_name}
echo 'CopyImageHeaderInformation ${t1_image} ${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz ${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz 1 1 1' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Bias Field Correction - T1/T2' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# User-defined (as necessary)' >> ${job_name}
echo 't1_image=${dir_prep}/${t1_prefix}_prep-denoise.nii.gz' >> ${job_name}
echo 't2_image=${dir_prep}/${t2_prefix}_prep-denoise.nii.gz' >> ${job_name}
echo 'brain_mask=${dir_prep}/${prefix}_prep-bex0Brain.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: bias_correction_T1T2" >> ${subject_log}' >> ${job_name}
echo 'echo "input_T1: "${t1_image} >> ${subject_log}' >> ${job_name}
echo 'echo "input_T2: "${t2_image} >> ${subject_log}' >> ${job_name}
echo 'echo "brain_mask: "${brain_mask} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '${nimg_core_root}/bias_field_correct_t1t2.sh \' >> ${job_name}
echo '  -a ${t1_image} \' >> ${job_name}
echo '  -b ${t2_image} \' >> ${job_name}
echo '  -m ${brain_mask} \' >> ${job_name}
echo '  -o ${dir_prep}' >> ${job_name}
echo '' >> ${job_name}
echo 'mv ${dir_prep}/biasT1T2_Field.nii.gz ${dir_prep}/${prefix}_prep-biasFieldT1T2.nii.gz' >> ${job_name}
echo 'mv ${dir_prep}/biasT1T2_T1w.nii.gz ${dir_prep}/${t1_prefix}_prep-biasT1T2.nii.gz' >> ${job_name}
echo 'mv ${dir_prep}/biasT1T2_T2w.nii.gz ${dir_prep}/${t2_prefix}_prep-biasT1T2.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Bias Field Correction - N4 - T1' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'input_image=${dir_prep}/${t1_prefix}_prep-biasT1T2.nii.gz' >> ${job_name}
echo 'output_dir=${dir_native}' >> ${job_name}
echo 'output_prefix=${prefix}_T1w' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: bias_correction_N4" >> ${subject_log}' >> ${job_name}
echo 'echo "input_image: "${input_image} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'N4BiasFieldCorrection \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  -i ${input_image} \' >> ${job_name}
echo '  -r 1 \' >> ${job_name}
echo '  -o [${output_dir}/${output_prefix}.nii.gz,${dir_prep}/${output_prefix}_prep-biasFieldN4.nii.gz]' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Bias Field Correction - N4 - T2' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'input_image=${dir_prep}/${t2_prefix}_prep-biasT1T2.nii.gz' >> ${job_name}
echo 'output_dir=${dir_native}' >> ${job_name}
echo 'output_prefix=${prefix}_T2w' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: bias_correction_N4" >> ${subject_log}' >> ${job_name}
echo 'echo "input_image: "${input_image} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'N4BiasFieldCorrection \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  -i ${input_image} \' >> ${job_name}
echo '  -r 1 \' >> ${job_name}
echo '  -o [${output_dir}/${output_prefix}.nii.gz,${dir_prep}/${output_prefix}_prep-biasFieldN4.nii.gz]' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Brain Extraction' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 't1_image=${dir_native}/${prefix}_T1w.nii.gz' >> ${job_name}
echo 't2_image=${dir_native}/${prefix}_T2w.nii.gz' >> ${job_name}
echo 'suffix=bex #change as needed to differentiate iterations, final iteration is bex (no number)' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: brain_extraction_ANTS" >> ${subject_log}' >> ${job_name}
echo 'echo "input: "${t1_image} >> ${subject_log}' >> ${job_name}
echo 'echo "input: "${t2_image} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'antsBrainExtraction.sh \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  -a ${t1_image} \' >> ${job_name}
echo '  -a ${t2_image} \' >> ${job_name}
echo '  -e ${dir_template}/OASIS/T_template0.nii.gz \' >> ${job_name}
echo '  -m ${dir_template}/OASIS/T_template0_BrainCerebellumProbabilityMask.nii.gz \' >> ${job_name}
echo '  -f ${dir_template}/OASIS/T_template0_BrainCerebellumRegistrationMask.nii.gz \' >> ${job_name}
echo '  -o ${dir_prep}/${prefix}_prep-${suffix}' >> ${job_name}
echo '' >> ${job_name}
echo 'mv ${dir_prep}/${prefix}_prep-${suffix}BrainExtractionMask.nii.gz \' >> ${job_name}
echo '  ${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz' >> ${job_name}
echo 'rm ${dir_prep}/${prefix}_prep-${suffix}BrainExtractionBrain.nii.gz' >> ${job_name}
echo 'rm ${dir_prep}/${prefix}_prep-${suffix}BrainExtractionPrior0GenericAffine.mat' >> ${job_name}
echo '' >> ${job_name}
echo '# Invert brain mask' >> ${job_name}
echo 'fslmaths ${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz -binv ${dir_prep}/${prefix}_prep-${suffix}Tissue.nii.gz' >> ${job_name}
echo 'CopyImageHeaderInformation ${t1_image} ${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz ${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz 1 1 1' >> ${job_name}
echo 'CopyImageHeaderInformation ${t1_image} ${dir_prep}/${prefix}_prep-${suffix}Tissue.nii.gz ${dir_prep}/${prefix}_prep-${suffix}Tissue.nii.gz 1 1 1' >> ${job_name}
echo '' >> ${job_name}
echo 'mv ${dir_prep}/${prefix}_prep-${suffix}Brain.nii.gz ${dir_mask}/${prefix}_mask-brain.nii.gz' >> ${job_name}
echo 'mv ${dir_prep}/${prefix}_prep-${suffix}Tissue.nii.gz ${dir_mask}/${prefix}_mask-tissue.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Tissue Segmentation' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 't1_image=${dir_native}/${prefix}_T1w.nii.gz' >> ${job_name}
echo 't2_image=${dir_native}/${prefix}_T2w.nii.gz' >> ${job_name}
echo 'brain_mask=${dir_mask}/${prefix}_mask-brain.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: segmentation_atropos" >> ${subject_log}' >> ${job_name}
echo 'echo "input_image: "${t1_image} >> ${subject_log}' >> ${job_name}
echo 'echo "input_image: "${t2_image} >> ${subject_log}' >> ${job_name}
echo 'echo "brain_mask: "${brain_mask} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'Atropos \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  -a ${t1_image} \' >> ${job_name}
echo '  -a ${t2_image} \' >> ${job_name}
echo '  -x ${brain_mask} \' >> ${job_name}
echo '  -o [${dir_seg}/${prefix}_seg-label.nii.gz,${dir_seg}/${prefix}_seg-Posterior%d.nii.gz] \' >> ${job_name}
echo '  -c [5,0.0] \' >> ${job_name}
echo '  -i kmeans[3] \' >> ${job_name}
echo '  -k Gaussian \' >> ${job_name}
echo '  -m [0.1,1x1x1] \' >> ${job_name}
echo '  -r 1 \' >> ${job_name}
echo '  -p Socrates[0] \' >> ${job_name}
echo '  -v 1' >> ${job_name}
echo '' >> ${job_name}
echo 'mv ${dir_seg}/${prefix}_seg-Posterior1.nii.gz ${dir_seg}/${prefix}_seg-CSF.nii.gz' >> ${job_name}
echo 'mv ${dir_seg}/${prefix}_seg-Posterior2.nii.gz ${dir_seg}/${prefix}_seg-GM.nii.gz' >> ${job_name}
echo 'mv ${dir_seg}/${prefix}_seg-Posterior3.nii.gz ${dir_seg}/${prefix}_seg-WM.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Apply Masks T1' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'input_image=${dir_native}/${prefix}_T1w.nii.gz' >> ${job_name}
echo 'unset mask' >> ${job_name}
echo 'mask[0]=${dir_mask}/${prefix}_mask-brain.nii.gz' >> ${job_name}
echo 'mask[1]=${dir_mask}/${prefix}_mask-tissue.nii.gz' >> ${job_name}
echo 'unset output_image' >> ${job_name}
echo 'output_image[0]=${dir_native}/${prefix}_T1w_brain.nii.gz' >> ${job_name}
echo 'output_image[1]=${dir_native}/${prefix}_T1w_tissue.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: apply_mask" >> ${subject_log}' >> ${job_name}
echo 'echo "input_image: "${input_image} >> ${subject_log}' >> ${job_name}
echo 'for ((i = 0; i < ${#mask[@]}; ++i)); do' >> ${job_name}
echo '  echo "input_mask: "${i} >> ${subject_log}' >> ${job_name}
echo 'done' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'for ((i = 0; i < ${#mask[@]}; ++i)); do' >> ${job_name}
echo '  fslmaths ${input_image} -mas ${mask[${i}]} ${output_image[${i}]}' >> ${job_name}
echo 'done' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Apply Masks T2' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'input_image=${dir_native}/${prefix}_T2w.nii.gz' >> ${job_name}
echo 'unset mask' >> ${job_name}
echo 'mask[0]=${dir_mask}/${prefix}_mask-brain.nii.gz' >> ${job_name}
echo 'mask[1]=${dir_mask}/${prefix}_mask-tissue.nii.gz' >> ${job_name}
echo 'unset output_image' >> ${job_name}
echo 'output_image[0]=${dir_native}/${prefix}_T2w_brain.nii.gz' >> ${job_name}
echo 'output_image[1]=${dir_native}/${prefix}_T2w_tissue.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: apply_mask" >> ${subject_log}' >> ${job_name}
echo 'echo "input_image: "${input_image} >> ${subject_log}' >> ${job_name}
echo 'for ((i = 0; i < ${#mask[@]}; ++i)); do' >> ${job_name}
echo '  echo "input_mask: "${i} >> ${subject_log}' >> ${job_name}
echo 'done' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'for ((i = 0; i < ${#mask[@]}; ++i)); do' >> ${job_name}
echo '  fslmaths ${input_image} -mas ${mask[${i}]} ${output_image[${i}]}' >> ${job_name}
echo 'done' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Normalization' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'moving_brain=${dir_native}/${prefix}_T1w_brain.nii.gz' >> ${job_name}
echo 'moving_tissue=${dir_native}/${prefix}_T1w_tissue.nii.gz' >> ${job_name}
echo 'fixed_brain=${dir_template}/${space}/${template}/${space}_${template}_T1w_brain.nii.gz' >> ${job_name}
echo 'fixed_tissue=${dir_template}/${space}/${template}/${space}_${template}_T1w_tissue.nii.gz' >> ${job_name}
echo 'output_prefix=${prefix}' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: normalization" >> ${subject_log}' >> ${job_name}
echo 'echo "moving_brain_image: "${moving_brain} >> ${subject_log}' >> ${job_name}
echo 'echo "moving_tissue_image: "${moving_tissue} >> ${subject_log}' >> ${job_name}
echo 'echo "moving_brain_image: "${fixed_brain} >> ${subject_log}' >> ${job_name}
echo 'echo "moving_tissue_image: "${fixed_tissue} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'antsRegistration \' >> ${job_name}
echo '  -d 3 \' >> ${job_name}
echo '  --float 1 \' >> ${job_name}
echo '  --verbose 1 \' >> ${job_name}
echo '  -u 1 \' >> ${job_name}
echo '  -z 1 \' >> ${job_name}
echo '  -r [${fixed_brain},${moving_brain},1] \' >> ${job_name}
echo '  -t Rigid[0.1] \' >> ${job_name}
echo '  -m MI[${fixed_brain},${moving_brain},1,32,Regular,0.25] \' >> ${job_name}
echo '  -m MI[${fixed_tissue},${moving_tissue},1,32,Regular,0.25] \' >> ${job_name}
echo '  -c [1000x500x250x100,1e-6,10] \' >> ${job_name}
echo '  -f 8x4x2x1 \' >> ${job_name}
echo '  -s 3x2x1x0vox \' >> ${job_name}
echo '  -t Affine[0.1] \' >> ${job_name}
echo '  -m MI[${fixed_brain},${moving_brain},1,32,Regular,0.25] \' >> ${job_name}
echo '  -m MI[${fixed_tissue},${moving_tissue},1,32,Regular,0.25] \' >> ${job_name}
echo '  -c [1000x500x250x100,1e-6,10] \' >> ${job_name}
echo '  -f 8x4x2x1 \' >> ${job_name}
echo '  -s 3x2x1x0vox \' >> ${job_name}
echo '  -t SyN[0.1,3,0] \' >> ${job_name}
echo '  -m CC[${fixed_brain},${moving_brain},1,32] \' >> ${job_name}
echo '  -m CC[${fixed_tissue},${moving_tissue},1,32] \' >> ${job_name}
echo '  -c [100x70x50x20,1e-6,10] \' >> ${job_name}
echo '  -f 8x4x2x1 \' >> ${job_name}
echo '  -s 3x2x1x0vox \' >> ${job_name}
echo '  -o ${dir_prep}/temp_' >> ${job_name}
echo '' >> ${job_name}
echo 'mv ${dir_prep}/temp_0GenericAffine.mat \' >> ${job_name}
echo '  ${dir_xfm}/${output_prefix}_from-T1w+rigid_to-${space}+${template}_xfm-affine.mat' >> ${job_name}
echo 'mv ${dir_prep}/temp_1Warp.nii.gz \' >> ${job_name}
echo '  ${dir_xfm}/${output_prefix}_from-T1w+rigid_to-${space}+${template}_xfm-syn.nii.gz' >> ${job_name}
echo 'mv ${dir_prep}/temp_1InverseWarp.nii.gz \' >> ${job_name}
echo '  ${dir_xfm}/${output_prefix}_from-${space}+${template}_to-T1w+rigid_xfm-syn.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Transform Stacks - T1w.rigid to Template' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'moving=T1w+rigid' >> ${job_name}
echo 'fixed=${space}+${template}' >> ${job_name}
echo 'unset xfm' >> ${job_name}
echo 'xfm[0]=${dir_xfm}/${prefix}_from-${moving}_to-${fixed}_xfm-affine.mat' >> ${job_name}
echo 'xfm[1]=${dir_xfm}/${prefix}_from-${moving}_to-${fixed}_xfm-syn.nii.gz' >> ${job_name}
echo 'ref_image=${dir_template}/${space}/${template}/${space}_${template}_T1w.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: build_transform_stack" >> ${subject_log}' >> ${job_name}
echo 'echo "moving: "${moving} >> ${subject_log}' >> ${job_name}
echo 'echo "fixed: "${fixed} >> ${subject_log}' >> ${job_name}
echo 'echo "xfm: "${xfm[0]} >> ${subject_log}' >> ${job_name}
echo 'echo "xfm: "${xfm[1]} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'antsApplyTransforms -d 3 \' >> ${job_name}
echo '  -o [${dir_xfm}/${prefix}_from-${moving}_to-${fixed}_xfm-stack.nii.gz,1] \' >> ${job_name}
echo '  -t ${xfm[1]} \' >> ${job_name}
echo '  -t ${xfm[0]} \' >> ${job_name}
echo '  -r ${ref_image}' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Calculate Jacobian Determinant - T1w.rigid to Template' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'moving=T1w+rigid' >> ${job_name}
echo 'fixed=${space}+${template}' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: calculate_jacobian" >> ${subject_log}' >> ${job_name}
echo 'echo "moving: "${moving} >> ${subject_log}' >> ${job_name}
echo 'echo "fixed: "${fixed} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'CreateJacobianDeterminantImage 3 \' >> ${job_name}
echo '  ${dir_xfm}/${prefix}_from-${moving}_to-${fixed}_xfm-stack.nii.gz \' >> ${job_name}
echo '  ${dir_jac}/${prefix}_from-${moving}_to-${fixed}_jac.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Transform Stacks - Template to T1w.rigid' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'moving=${space}+${template}' >> ${job_name}
echo 'fixed=T1w+rigid' >> ${job_name}
echo 'unset xfm' >> ${job_name}
echo 'xfm[0]=${dir_xfm}/${prefix}_from-${fixed}_to-${moving}_xfm-affine.mat' >> ${job_name}
echo 'xfm[1]=${dir_xfm}/${prefix}_from-${moving}_to-${fixed}_xfm-syn.nii.gz' >> ${job_name}
echo 'ref_image=${dir_native}/${prefix}_T1w_brain.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: build_transform_stack" >> ${subject_log}' >> ${job_name}
echo 'echo "moving: "${moving} >> ${subject_log}' >> ${job_name}
echo 'echo "fixed: "${fixed} >> ${subject_log}' >> ${job_name}
echo 'echo "xfm: "${xfm[0]} >> ${subject_log}' >> ${job_name}
echo 'echo "xfm: "${xfm[1]} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'antsApplyTransforms -d 3 \' >> ${job_name}
echo '  -o [${dir_xfm}/${prefix}_from-${moving}_to-${fixed}_xfm-stack.nii.gz,1] \' >> ${job_name}
echo '  -t ${xfm[1]} \' >> ${job_name}
echo '  -t ${xfm[0],1} \' >> ${job_name}
echo '  -r ${ref_image}' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Apply Transforms - Processed T1w to Template' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'unset input_image' >> ${job_name}
echo 'input_image[0]=${dir_native}/${prefix}_T1w.nii.gz' >> ${job_name}
echo 'input_image[1]=${dir_native}/${prefix}_T1w_brain.nii.gz' >> ${job_name}
echo 'input_image[2]=${dir_native}/${prefix}_T1w_tissue.nii.gz' >> ${job_name}
echo 'unset output_image' >> ${job_name}
echo 'output_image[0]=${dir_norm}/${prefix}_reg-${space}+${template}_T1w.nii.gz' >> ${job_name}
echo 'output_image[1]=${dir_norm}/${prefix}_reg-${space}+${template}_T1w_brain.nii.gz' >> ${job_name}
echo 'output_image[2]=${dir_norm}/${prefix}_reg-${space}+${template}_T1w_tissue.nii.gz' >> ${job_name}
echo 'unset xfm' >> ${job_name}
echo 'xfm=${dir_xfm}/${prefix}_from-T1w+rigid_to-${space}+${template}_xfm-stack.nii.gz' >> ${job_name}
echo 'ref_image=${dir_template}/${space}/${template}/${space}_${template}_T1w.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: apply_transform" >> ${subject_log}' >> ${job_name}
echo 'for ((i = 0; i < ${#input_image[@]}; ++i)); do' >> ${job_name}
echo '  echo "input_image: "${input_image[${i}]} >> ${subject_log}' >> ${job_name}
echo '  echo "output_image: "${output_image[${i}]} >> ${subject_log}' >> ${job_name}
echo 'done' >> ${job_name}
echo 'echo "xfm: "${xfm} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'for ((i = 0; i < ${#input_image[@]}; ++i)); do' >> ${job_name}
echo '  antsApplyTransforms -d 3 \' >> ${job_name}
echo '    -i ${input_image[${i}]} \' >> ${job_name}
echo '    -o ${output_image[${i}]} \' >> ${job_name}
echo '    -t ${xfm} \' >> ${job_name}
echo '    -r ${ref_image}' >> ${job_name}
echo 'done' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Apply Transforms - Processed T2w to Template' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'unset input_image' >> ${job_name}
echo 'input_image[0]=${dir_native}/${prefix}_T2w.nii.gz' >> ${job_name}
echo 'input_image[1]=${dir_native}/${prefix}_T2w_brain.nii.gz' >> ${job_name}
echo 'input_image[2]=${dir_native}/${prefix}_T2w_tissue.nii.gz' >> ${job_name}
echo 'unset output_image' >> ${job_name}
echo 'output_image[0]=${dir_norm}/${prefix}_reg-${space}+${template}_T2w.nii.gz' >> ${job_name}
echo 'output_image[1]=${dir_norm}/${prefix}_reg-${space}+${template}_T2w_brain.nii.gz' >> ${job_name}
echo 'output_image[2]=${dir_norm}/${prefix}_reg-${space}+${template}_T2w_tissue.nii.gz' >> ${job_name}
echo 'unset xfm' >> ${job_name}
echo 'xfm=${dir_xfm}/${prefix}_from-T1w+rigid_to-${space}+${template}_xfm-stack.nii.gz' >> ${job_name}
echo 'ref_image=${dir_template}/${space}/${template}/${space}_${template}_T1w.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: apply_transform" >> ${subject_log}' >> ${job_name}
echo 'for ((i = 0; i < ${#input_image[@]}; ++i)); do' >> ${job_name}
echo '  echo "input_image: "${input_image[${i}]} >> ${subject_log}' >> ${job_name}
echo '  echo "output_image: "${output_image[${i}]} >> ${subject_log}' >> ${job_name}
echo 'done' >> ${job_name}
echo 'echo "xfm: "${xfm} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'for ((i = 0; i < ${#input_image[@]}; ++i)); do' >> ${job_name}
echo '  antsApplyTransforms -d 3 \' >> ${job_name}
echo '    -i ${input_image[${i}]} \' >> ${job_name}
echo '    -o ${output_image[${i}]} \' >> ${job_name}
echo '    -t ${xfm} \' >> ${job_name}
echo '    -r ${ref_image}' >> ${job_name}
echo 'done' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# Apply Transforms - Template Air Mask to T1w.rigid' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'unset input_image' >> ${job_name}
echo 'input_image=${dir_template}/${space}/${template}/${space}_${template}_mask-air.nii.gz' >> ${job_name}
echo 'unset output_image' >> ${job_name}
echo 'output_image=${dir_mask}/${prefix}_mask-air.nii.gz' >> ${job_name}
echo 'unset xfm' >> ${job_name}
echo 'xfm=${dir_xfm}/${prefix}_from-${space}+${template}_to-T1w+rigid_xfm-stack.nii.gz' >> ${job_name}
echo 'ref_image=${dir_native}/${prefix}_T1w.nii.gz' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "task: apply_transform" >> ${subject_log}' >> ${job_name}
echo 'echo "input_image: "${input_image} >> ${subject_log}' >> ${job_name}
echo 'echo "output_image: "${output_image} >> ${subject_log}' >> ${job_name}
echo 'echo "xfm: "${xfm} >> ${subject_log}' >> ${job_name}
echo 'date +"start_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo 'antsApplyTransforms -d 3 \' >> ${job_name}
echo '  -i ${input_image} \' >> ${job_name}
echo '  -o ${output_image} \' >> ${job_name}
echo '  -t ${xfm} \' >> ${job_name}
echo '  -r ${ref_image}' >> ${job_name}
echo '' >> ${job_name}
echo 'date +"end_time: %Y-%m-%d_%H-%M-%S" >> ${subject_log}' >> ${job_name}
echo 'echo "" >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo '# End of Script' >> ${job_name}
echo '#------------------------------------------------------------------------------' >> ${job_name}
echo 'chgrp -R ${group} ${researcher}/${project}/derivatives' >> ${job_name}
echo 'chmod -R g+rw ${researcher}/${project}/derivatives' >> ${job_name}
echo '' >> ${job_name}
echo 'echo "#task: structural_preprocessing_pipeline_T1T2" >> ${subject_log}' >> ${job_name}
echo 'date +"end_time: %Y-%m-%dT%H:%M:%S%z" >> ${subject_log}' >> ${job_name}
echo 'echo "#--------------------------------------------------------------------------------" >> ${subject_log}' >> ${job_name}
echo 'echo '' >> ${subject_log}' >> ${job_name}
echo '' >> ${job_name}
#qsub ${job_name}


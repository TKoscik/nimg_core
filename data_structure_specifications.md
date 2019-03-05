# Data Structure Specifications
## Iowa Imaging Data Science Core

updated: September 25, 2018

## Key:
`[] = optional, ()=example, {}=variable`  
`${subject} = subject identifier`  
`${session} = session identifier -> YYMMDDHHMM`  
`${site} = site/scanner identifier -> #####`  
[site lookup table](https://github.com/TKoscik/nimg_core/blob/master/lut/site_scanner.tsv)  
[modality lookup table](https://github.com/TKoscik/nimg_core/blob/master/lut/modality_labels.tsv)  

# Data Structure
```
${researcherRoot}/
  ∟${projectName}/
    ∟participants.tsv
    ∟code
    ∟dicom/                   Read-only archive
    |  ∟sub-${subject}_ses-${session}_site-${site}.zip
    ∟log/
    |   ∟hpc_output/
    |   |    ∟${job_name}.o######
    |   ∟sub-${subject}_ses-${session}_site-${site}.log
    |   ∟MRtape.log
    ∟lut/
    ∟nifti/                   Read-only archive
    |  ∟sub-${subject}/
    |    ∟ses-${session}/
    |      ∟session_info.tsv
    |      ∟anat/
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_acq-${acq}[_run-${run}]_${mod}.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_acq-${acq}[_run-${run}]_${mod}.nii.gz
    |      ∟cal/
    |      ∟dwi/
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_acq-b${bvalue}v${directions}_dir-${pe}_dwi.bval
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_acq-b${bvalue}v${directions}_dir-${pe}_dwi.bvec
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_acq-b${bvalue}v${directions}_dir-${pe}_dwi.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_acq-b${bvalue}v${directions}_dir-${pe}_dwi.nii.gz
    |      ∟fmap/
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_magnitude.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_magnitude.nii.gz
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_phase.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_phase.nii.gz
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_mod-bold_dir-AP_spinecho.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_mod-bold_dir-AP_spinecho.nii.gz
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_mod-bold_dir-PA_spinecho.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_mod-bold_dir-PA_spinecho.nii.gz
    |      ∟func/
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_run-${run}_bold.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_run-${run}_bold.nii.gz
    |      ∟mrs/
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_roi-${roi}_mrs.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_roi-${roi}_mrs.p
    |      ∟orig/ #raw data from scanner (no on scanner processing)
    |      ∟other/
    |         ∟sub-${subject}_ses-${session}_site-${site}_${mod}.json
    |         ∟sub-${subject}_ses-${session}_site-${site}_${mod}.nii.gz
    ∟derivatives/
    |  ∟anat/
    |  |  ∟analyses/
    |  |  ∟brains2/ #legacy support only
    |  |  |  ∟sub-${ursi}_ses-${mrqid}_brains2.zip
    |  |  ∟baw/
    |  |  |  ∟sub-${subject}_ses-${session}/
    |  |  |  |  ∟ACCUMULATED_POSTERIORS/
    |  |  |  |  ∟ACPCAlign/
    |  |  |  |  ∟JointFusion/
    |  |  |  |   ∟allVol/
    |  |  |  |   ∟lobeVol/
    |  |  |  |  ∟TissueClassify/
    |  |  |  |  ∟WarpedAtlas2Subject/
    |  |  ∟fsurf/
    |  |  |  |  ∟fsaverage/
    |  |  |  |  ∟sub-${subject}_ses-${session}/
    |  |  |  |  ∟resample/
    |  |  ∟native/
    |  |  |  ∟sub-${subject}_ses-${session}_*_${mod}.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_${mod}_air.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_${mod}_brain.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_${mod}_tissue.nii.gz
    |  |  ∟mask/
    |  |  |  ∟sub-${subject}_ses-${session}_*_mask-air.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_mask-brain.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_mask-tissue.nii.gz
    |  |  ∟prep/
    |  |  |  ∟sub-${subject}/
    |  |  |     ∟ses-${session}/
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-acpc.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-avg.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bex0AFNI.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bex0ANTS.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bex0BET.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bex0Brain.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bex0Tissue.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bexAFNI.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bexANTS.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bexBET.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasT1T2.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasT1T2Field.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasN4.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasN4Field.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasAtroposN4.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-biasAtroposN4Field.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-denoise.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-gradunwarp.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-readout.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-resample.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-T1reg.nii.gz
    |  |  ∟reg_${space}_${template}/
    |  |  |  ∟sub-${subject}_ses-${session}_*_reg-${space}_${template}_${mod}.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_reg-${space}_${template}_${mod}_brain.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_reg-${space}_${template}_${mod}_tissue.nii.gz
    |  |  ∟segmentation/
    |  |     ∟sub-${subject}_ses-${session}_*_${mod}_seg-CSF.nii.gz
    |  |     ∟sub-${subject}_ses-${session}_*_${mod}_seg-GM.nii.gz
    |  |     ∟sub-${subject}_ses-${session}_*_${mod}_seg-label.nii.gz
    |  |     ∟sub-${subject}_ses-${session}_*_${mod}_seg-WM.nii.gz
    |  ∟dwi/
    |  |  ∟analyses/
    |  |  ∟corrected/
    |  |  ∟prep/
    |  |  |  ∟sub-${subject}/
    |  |  |     ∟ses-${session}/
    |  |  ∟scalar_${space}_${template}/
    |  |  ∟scalar_native/
    |  ∟func/
    |  |  ∟analyses/
    |  |  ∟full_ts/
    |  |  ∟prep/
    |  |  |  ∟sub-${subject}/
    |  |  |     ∟ses-${session}/
    |  |  ∟rest/
    |  |  ∟stbeta/
    |  ∟mrs/
    |  ∟xfm/
    |  |  ∟sub-${subject}/
    |  |     ∟ses-${session}/
    |  |        ∟sub-${subject}_ses-${session}_from-T1w+raw_to-${space}+${template}_xfm-rigid.mat
    |  |        ∟sub-${subject}_ses-${session}_from-T1w+rigid_to-${space}+${template}_xfm-affine.mat
    |  |        ∟sub-${subject}_ses-${session}_from-T1w+rigid_to-${space}+${template}_xfm-syn.nii.gz
    |  |        ∟sub-${subject}_ses-${session}_from-${space}+${template}_to-T1w+rigid_xfm-syn.nii.gz 
    |  |        ∟sub-${subject}_ses-${session}_from-T2w+raw_to-T1w+rigid_xfm-affine.mat
    |  |        ∟sub-${subject}_ses-${session}_from-T2w+rigid_to-T1w+rigid_xfm-syn.nii.gz 
    |  |        ∟sub-${subject}_ses-${session}_from-T1w+rigid_to-T2w+rigid_xfm-syn.nii.gz 
    |  |        ∟sub-${subject}_ses-${session}_from-${mod}+raw_to-T1w+rigid_xfm-affine.mat
    |  |        ∟sub-${subject}_ses-${session}_from-${mod}+rigid_to-T1w+rigid_xfm-syn.nii.gz 
    |  |        ∟sub-${subject}_ses-${session}_from-T1w+rigid_to-${mod}+rigid_xfm-syn.nii.gz 
    |  |        ∟sub-${subject}_ses-${session}_from-meanbold+${task}_to-spinechoB0_xfm-affine.mat
    |  |        ∟sub-${subject}_ses-${session}_from-meanbold+${task}_to-spinechoB0_xfm-syn.nii.gz  
    |  |        ∟sub-${subject}_ses-${session}_from-spinechoB0_to- meanbold+${task}_xfm-syn.nii.gz  
    |  |        ∟sub-${subject}_ses-${session}_from-spinechoB0_to-T2w+rigid_xfm-affine.mat
    |  |        ∟sub-${subject}_ses-${session}_from-spinechoB0_to-T2w+rigid_xfm-syn.nii.gz
    |  |        ∟sub-${subject}_ses-${session}_from-T2w+rigid_to-spinechoB0_xfm-syn.nii.gz
    |  |        ∟sub-${subject}_ses-${session}_from-dwiB0_to-T2w+rigid_xfm-affine.mat
    |  |        ∟sub-${subject}_ses-${session}_from-dwiB0_to-T2w+rigid_xfm-syn.nii.gz  
    |  |        ∟sub-${subject}_ses-${session}_from-T2w+rigid_to-dwiB0_xfm-syn.nii.gz
    |  |        ∟sub-${subject}_ses-${session}_from-T1w+rigid_to-${space}+${template}_xfm-stack.nii.gz
    |  |        ∟sub-${subject}_ses-${session}_from-${space}+${template}_to-T1w+rigid_xfm-stack.nii.gz
    |  |        ∟sub-${subject}_ses-${session}_from-T2w+raw_to-T1+rigid_xfm-stack.nii.gz
    |  |        ∟sub-${subject}_ses-${session}_from-T2w+rigid_to-${space}+${template}_xfm-stack.nii.gz
    |  |        ∟sub-${subject}_ses-${session}_from-${space}+${template}_to-T2w+raw_xfm-stack.nii.gz
    |  |        ∟sub-${subject}_ses-${session}_from-meanbold+${task}_to-${space}+${template}_xfm-stack.nii.gz 
    |  |        ∟sub-${subject}_ses-${session}_from-dwiB0_to-${space}+${template}_xfm-stack.nii.gz
    |  ∟qc/
    |       ∟scan_quality
    |       ∟anat_prep
    |       ∟func_prep
    |       ∟dwi_prep
    |       ∟label
    |       ∟fsurf
    |       ∟mrs
    ∟stimuli
    ∟summary
        ∟${projectName}_${data_description}_${YYYYMMDD}.csv
        ∟(DM1_bt-volumetrics-wb_20180831.csv)
        ∟(DM1_fsurf-volumetrics-all_20180831.csv)
```
# Common Resources
```
${nimg_core_root}/
  ∟templates/
    ∟${space}/
    |  ∟${template}/
    |     ∟${space}_${template}_mask-air.nii.gz
    |     ∟${space}_${template}_mask-brain.nii.gz
    |     ∟${space}_${template}_mask-tissue.nii.gz
    |     ∟${space}_${template}_T1w.nii.gz
    |     ∟${space}_${template}_T1w_brain.nii.gz
    |     ∟${space}_${template}_T1w_tissue.nii.gz
    |     ∟${space}_${template}_T2w.nii.gz
    |     ∟${space}_${template}_T2w_brain.nii.gz
    |     ∟${space}_${template}_T2w_tissue.nii.gz
    ∟CIT168/
    ∟FSLMNI152/ 
    ∟HCPICBM/     *This is an unbiased average of 1113 HCP subjects,
    |  ∟1mm/       registering tissue and brain together but independently,
    |  ∟2mm/       which has been registered to ICBM2009bna_500um,
    |  ∟500um/     then resample to different sizes.
    |  ∟700um/
    |  ∟800um/
    ∟HCPMNI2009c/
    ∟HCPNOBS1/    #unbiased HCP average, tissue and brain registered
    ∟HCPNOBS1pad/ #unbiased HCP average, tissue and brain registered, 0-padded
    ∟HCPS1200/
    ∟ICBM2009ana/
    ∟ICBM2009bna/
    ∟ICBM2009cna/
    ∟NIHPDa045085
    ∟NIHPDa045185
    ∟NIHPDa070110
    ∟NIHPDa075135
    ∟NIHPDa100140
    ∟NIHPDa130185
    ∟OASIS/        # for ANTs brain extraction
    ∟WU7112bTal/
    ∟xfm/
       ∟from-${space}+${template}_to-${space}+${template}_xfm.nii.gz
       ∟from-FSLMNI152+1mm_to-HCPS1200+1mm_xfm.nii.gz
       ∟from-HCPS1200+800um_to-HCPS1200+1mm_xfm.nii.gz
```
# Filename Fields (and order)
```
anat/
sub-${subject}_ses-${session}[_site-${site}][_acq-${acq}][_run-${#}][_echo-${#}]_${mod}
mod=T1w|T2w|T1rho|T1map|T2map|T2star|FLAIR|FLASH|PD|PDT2|inplaneT1|inplaneT2|angio

dwi/
sub-${subject}_ses-${session}[_site-${site}][_acq-${acq}][_b-${b}][_dir-${dir}][_pe-${pe}][_run-${#}]_dwi.nii.gz

func/
sub-${subject}_ses-${session}[_site-${site}]_task-${task}[_acq-${acq}][_pe-${pe}][_rec-${}][_run-${#}][_echo-${#}]_${mod}.nii.gz
mod=bold|T1rho
```


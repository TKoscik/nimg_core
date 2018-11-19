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
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_dwi.bval
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_dwi.bvec
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_dwi.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_dwi.nii.gz
    |      ∟fmap/
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_magnitude.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_magnitude.nii.gz
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_phase.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_task-${task}_phase.nii.gz
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_pe-AP_spinecho.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_pe-AP_spinecho.nii.gz
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_pe-PA_spinecho.json
    |      |  ∟sub-${subject}_ses-${session}_site-${site}_pe-PA_spinecho.nii.gz
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
    |  |  |  ∟ACCUMULATED_POSTERIORS/
    |  |  |  ∟ACPCAlign/
    |  |  |  ∟JointFusion/
    |  |  |  |  ∟allVol/
    |  |  |  |  ∟lobeVol/
    |  |  |  ∟TissueClassify/
    |  |  |  ∟WarpedAtlas2Subject/
    |  |  ∟fsurf/
    |  |  |   ∟subject_dir/
    |  |  |  |  ∟fsaverage/
    |  |  |  |  ∟sub-$subject}_ses-${session}/
    |  |  |  ∟resample/
    |  |  ∟native/
    |  |  |  ∟sub-${subject}_ses-${session}_*_${mod}_air.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_${mod}_brain.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_${mod}_tissue.nii.gz
    |  |  ∟mask/
    |  |  |  ∟sub-${subject}_ses-${session}_*_mask-air.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_mask-bex0Brain.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_mask-bex0Tissue.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_mask-brain.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_mask-tissue.nii.gz
    |  |  ∟prep/
    |  |  |  ∟sub-${subject}/
    |  |  |     ∟ses-${session}/
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-acpc.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_${mod}_prep-avg.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bex0AFNI.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bex0ANTS.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bex0FSL.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bexAFNI.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bexANTS.nii.gz
    |  |  |        ∟sub-${subject}_ses-${session}_*_prep-bexFSL.nii.gz
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
    |  |  |  ∟sub-${subject}_ses-${session}_*_${mod}_reg-${space}_${template}_brain.nii.gz
    |  |  |  ∟sub-${subject}_ses-${session}_*_${mod}_reg-${space}_${template}_tissue.nii.gz
    |  |  ∟segmentation/
    |  |     ∟sub-${subject}_ses-${session}_*_${mod}_seg-CSF.nii.gz
    |  |     ∟sub-${subject}_ses-${session}_*_${mod}_seg-GM.nii.gz
    |  |     ∟sub-${subject}_ses-${session}_*_${mod}_seg-label.nii.gz
    |  |     ∟sub-${subject}_ses-${session}_*_${mod}_seg-WM.nii.gz
    |  ∟dwi/
    |  |  ∟analyses/
    |  |  ∟prep/
    |  |  |  ∟sub-${subject}/
    |  |  |     ∟ses-${session}/
    |  |  ∟scalar/
    |  |  ∟tensor/
    |  ∟func/
    |  |  ∟analyses/
    |  |  ∟full_ts/
    |  |  ∟prep/
    |  |  |  ∟sub-${subject}/
    |  |  |     ∟ses-${session}/
    |  |  ∟rest/
    |  |  ∟stbeta/
    |  ∟mrs/
    |  ∟tform/
    |  |    ∟sub-${subject}_ses-${session}_*_${mod}_reg-acpc_tform-0rigid.mat
    |  |    |    (initial affine transform)
    |  |    ∟sub-${subject}_ses-${session}_*_${mod}_reg-T1_tform-0affine.mat
    |  |    ∟sub-${subject}_ses-${session}_*_${mod}_reg-T1_tform-1syn.nii.gz
    |  |    ∟sub-${subject}_ses-${session}_*_${mod}_reg-T1_tform-inverse.nii.gz
    |  |    |    (registration between modalities within/between sessions, preceeds normalization)
    |  |    ∟sub-${subject}_ses-${session}_*_${mod}_reg-${subject}_tform-0affine.mat
    |  |    ∟sub-${subject}_ses-${session}_*_${mod}_reg-${subject}_tform-1syn.nii.gz
    |  |    ∟sub-${subject}_ses-${session}_*_${mod}_reg-${subject}_tform-inverse.nii.gz
    |  |    |    (registration to subject template, preceeds normalization)
    |  |    ∟sub-${subject}_ses-${session}_*_reg-${space}_tform-0affine.mat
    |  |    ∟sub-${subject}_ses-${session}_*_reg-${space}_tform-1syn.nii.gz
    |  |    ∟sub-${subject}_ses-${session}_*_reg-${space}_tform-inverse.nii.gz
    |  |         (normalization registration to template space)
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
# Filename Fields (and order)
```
anat/
sub-${ursi}_ses-${mrqid}[_site-${site}][_acq-${acq}][_run-${#}][_echo-${#}]_${mod}
mod=T1w|T2w|T1rho|T1map|T2map|T2star|FLAIR|FLASH|PD|PDT2|inplaneT1|inplaneT2|angio

dwi/
sub-${ursi}_ses-${mrqid}[_site-${site}][_acq-${acq}][_b-${b}][_dir-${dir}][_pe-${pe}][_run-${#}]_dwi.nii.gz

func/
sub-${ursi}_ses-${mrqid}[_site-${site}]_task-${task}[_acq-${acq}][_pe-${pe}][_rec-${}][_run-${#}][_echo-${#}]_${mod}.nii.gz
mod=bold|T1rho
```

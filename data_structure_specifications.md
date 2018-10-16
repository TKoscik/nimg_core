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
        ∟dicom/			Read-only archive
        |    ∟sub-${subject}_ses-${session}_site-${site}.zip
        ∟nifti/			Read-only archive
        |     ∟${subject}/
        |         ∟${session}/
        |              ∟session_info.tsv
        |              ∟anat/
        |              |    ∟sub-${subject}_ses-${session}_acq-${acq}[_run-${run}]_${mod}.json
        |              |    ∟sub-${subject}_ses-${session}_acq-${acq}[_run-${run}]_${mod}.nii.gz
        |              ∟dwi/
        |              |    ∟sub-${subject}_ses-${session}_dwi.bval
        |              |    ∟sub-${subject}_ses-${session}_dwi.bvec
        |              |    ∟sub-${subject}_ses-${session}_dwi.json
        |              |    ∟sub-${subject}_ses-${session}_dwi.nii.gz
        |              ∟fmap/
        |              |    ∟sub-${subject}_ses-${session}_task-${task}_magnitude.json
        |              |    ∟sub-${subject}_ses-${session}_task-${task}_magnitude.nii.gz
        |              |    ∟sub-${subject}_ses-${session}_task-${task}_phase.json
        |              |    ∟sub-${subject}_ses-${session}_task-${task}_phase.nii.gz
        |              |    ∟sub-${subject}_ses-${session}_pe-AP_spinecho.json
        |              |    ∟sub-${subject}_ses-${session}_pe-AP_spinecho.nii.gz
        |              |    ∟sub-${subject}_ses-${session}_pe-PA_spinecho.json
        |              |    ∟sub-${subject}_ses-${session}_pe-PA_spinecho.nii.gz
        |              ∟func/
        |              |    ∟sub-${subject}_ses-${session}_task-${task}_run-${run}_bold.json
        |              |    ∟sub-${subject}_ses-${session}_task-${task}_run-${run}_bold.nii.gz
        |              ∟mrs/
        |              |    ∟sub-${subject}_ses-${session}_roi-${roi}_mrs.json
        |              |    ∟sub-${subject}_ses-${session}_roi-${roi}_mrs.p
        |              ∟orig/ #raw data from scanner (no on scanner processing)
        |              ∟other/
        |              |    ∟sub-${subject}_ses-${session}_${mod}.json
        |              |    ∟sub-${subject}_ses-${session}_${mod}.nii.gz
        |              ∟qa/
        |                   ∟sub-${subject}_ses-${session}_qa_acq-${acq}.json
        |                   ∟sub-${subject}_ses-${session}_qa_acq-${acq}.nii.gz
        ∟derivatives/
        |    ∟anat/
        |    |    ∟native/
        |    |    |    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_brain.nii.gz
        |    |    |    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_tissue.nii.gz
        |    |    ∟prep/
        |    |    |    ∟${subject}
        |    |    |         ∟${session}
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-acpc.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-biasAtroposN4.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-biasAtroposN4Field.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-biasN4.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-biasFieldN4.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-biasT1T2.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-denoise.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-gradunwarp.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-readout.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_prep-resample.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_reg-acpcAffine.mat
        |    |    |              ∟sub-${subject}_ses-${session}_prep-air.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-bex0AFNI.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-bex0ANTS.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-bex0BET.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-bex0Mask.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-bexAFNI.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-bexANTS.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-bexBET.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-bexMask.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-biasFieldT1T2.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-seg.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-segPosterior1.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-segPosterior2.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-segPosterior3.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_prep-tissue.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_reg-${space}_tform-0affine.mat
        |    |    |              ∟sub-${subject}_ses-${session}_reg-${space}_tform-1syn.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_reg-${space}_tform-inverse.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_T2w_prep-avg.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_T1w_prep-norm.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_T2w_prep-norm.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_T2w_prep-T1reg.nii.gz
        |    |    |              ∟sub-${subject}_ses-${session}_T2w_prep-T1reg_tform-0affine.mat
        |    |    ∟reg_[${space}]/
        |    |        ∟sub-${subject}_ses-${session}_${mod}_reg-${space}_brain.nii.gz
        |    |        ∟sub-${subject}_ses-${session}_${mod}_reg-${space}_tissue.nii.gz
        |    ∟b2/   
        |    |    ∟b2_sub-${ursi}_ses-${mrqid}.zip 
        |    ∟baw/  BrainsAutoWorkup-BRAINSTools
        |    |    ∟${ursi}/
        |    |        ∟${mrqid}/
        |    |            ∟ACCUMULATED_POSTERIORS/
        |    |            ∟ACPCAlign/
        |    |            ∟JointFusion/
        |    |            |    ∟allVol/
        |    |            |    ∟lobeVol/
        |    |            ∟TissueClassify/
        |    |            ∟WarpedAtlas2Subject/
        |    ∟dwi/
        |    ∟fsurf/ (Freesurfer subject directory)
        |    |    ∟${ursi}_${mrqid}/
        |    |    |    ∟label/                 
        |    |    |    ∟mri/
        |    |    |    |    ∟orig/
        |    |    |    |    ∟transforms/                
        |    |    |    ∟scripts/               
        |    |    |    ∟stats/           
        |    |    |    ∟surf/                
        |    |    |    ∟tmp/
        |    |    |    |    ∟cw256                  
        |    |    |    ∟touch/                
        |    |    |    ∟trash/
        |    |    ∟fsaverage/
        |    ∟func/
        |    |    ∟ts/
        |    |    |    ∟sub-${ursi}_ses-${mrqid}_task-${task}_[_pre-${order}-${proc}].nii.gz
        |    |    ∟stb/
        |    ∟mrs/
        |    ∟tform/
        |    |    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_reg-acpc_tform-0rigid.mat
        |    |    |    (initial affine transform)
        |    |    ∟sub-${subject}_MOV_ses-${session}_acq-${acq}_${mod}_FIX_ses-${session}_acq-${acq}_${mod}_tform-0affine.mat
        |    |    ∟sub-${subject}_MOV_ses-${session}_acq-${acq}_${mod}_FIX_ses-${session}_acq-${acq}_${mod}_tform-1syn.nii.gz
        |    |    ∟sub-${subject}_MOV_ses-${session}_acq-${acq}_${mod}_FIX_ses-${session}_acq-${acq}_${mod}_tform-inverse.nii.gz
        |    |    |    (registration between modalities within/between sessions, preceeds normalization)
        |    |    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_reg-${subject}_tform-0affine.mat
        |    |    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_reg-${subject}_tform-1syn.nii.gz
        |    |    ∟sub-${subject}_ses-${session}_acq-${acq}_${mod}_reg-${subject}_tform-inverse.nii.gz
        |    |    |    (registration to subject template, preceeds normalization)
        |    |    ∟sub-${subject}_ses-${session}_reg-${space}_tform-0affine.mat
        |    |    ∟sub-${subject}_ses-${session}_reg-${space}_tform-1syn.nii.gz
        |    |    ∟sub-${subject}_ses-${session}_reg-${space}_tform-inverse.nii.gz
        |    |         (normalization registration to template space)
        |    ∟qc/
        |    |    ∟scan_quality
        |    |    ∟anat_prep
        |    |    ∟func_prep
        |    |    ∟dwi_prep
        |    |    ∟label
        |    |    ∟fsurf
        |    |    ∟mrs
        |    ∟log/
        ∟code
        ∟lut
        ∟stimuli
        ∟summary
             ∟${projectName}_${data_description}_${YYYYMMDD}.csv
             ∟(DM1_bt-volumetrics-wb_20180831.csv)
             ∟(DM1_fsurf-volumetrics-all_20180831.csv)
```

# Filename Fields (and order)
```
anat/
sub-${ursi}_ses-${mrqid}_acq-${acq}[_run-${#}][_echo-${#}]_${mod}
mod=T1w|T2w|T1rho|T1map|T2map|T2star|FLAIR|FLASH|PD|PDT2|inplaneT1|inplaneT2|angio

dwi/
sub-${ursi}_ses-${mrqid}[_acq-${acq}][_b-${b}][_dir-${dir}][_pe-${pe}][_run-${#}]_dwi.nii.gz

func/
sub-${ursi}_ses-${mrqid}_task-${task}[_acq-${acq}][_pe-${pe}][_rec-${}][_run-${#}][_echo-${#}]_${mod}.nii.gz
mod=bold|T1rho
```

# Data Structure Specifications
## Iowa Imaging Data Science Core

Author: Timothy R. Koscik, PhD
Date:   September 11, 2018

## Key:
```
[] = optional, ()=example, {}=variable
${ursi}=subject identifier
${mrqid}=session identifier
```
# Data Structure
```
${researcherRoot}/
    ∟${projectName}/
        ∟dicom/			Read-only archive
        |    ∟sub-${ursi}_ses-${mrqid}[_site-${site}].zip
        ∟nifti/			Read-only archive
        |     ∟${ursi}/
        |         ∟${mrqid}/
        |              ∟anat/
        |              |    ∟sub-${ursi}_ses-${mrqid}_${mod}.json
        |              |    ∟sub-${ursi}_ses-${mrqid}_${mod}.nii.gz
        |              ∟dwi/
        |              |    ∟sub-${ursi}_ses-${mrqid}_dwi.bval
        |              |    ∟sub-${ursi}_ses-${mrqid}_dwi.bvec
        |              |    ∟sub-${ursi}_ses-${mrqid}_dwi.json
        |              |    ∟sub-${ursi}_ses-${mrqid}_dwi.nii.gz
        |              ∟fmap/
        |              |    ∟sub-${ursi}_ses-${mrqid}_task-${task}_magnitude.json
        |              |    ∟sub-${ursi}_ses-${mrqid}_task-${task}_magnitude.nii.gz
        |              |    ∟sub-${ursi}_ses-${mrqid}_task-${task}_phase.json
        |              |    ∟sub-${ursi}_ses-${mrqid}_task-${task}_phase.nii.gz
        |              |    ∟sub-${ursi}_ses-${mrqid}_spinecho_pe-AP.json
        |              |    ∟sub-${ursi}_ses-${mrqid}_spinecho_pe-AP.nii.gz
        |              |    ∟sub-${ursi}_ses-${mrqid}_spinecho_pe-PA.json
        |              |    ∟sub-${ursi}_ses-${mrqid}_spinecho_pe-PA.nii.gz
        |              ∟func/
        |              |    ∟sub-${ursi}_ses-${mrqid}_task-${task}_bold.json
        |              |    ∟sub-${ursi}_ses-${mrqid}_task-${task}_bold.nii.gz
        |              ∟mrs/
        |              |    ∟sub-${ursi}_ses-${mrqid}_mrs_roi-${roi}.json
        |              |    ∟sub-${ursi}_ses-${mrqid}_mrs_roi-${roi}.p
        |              ∟other/
        |              |    ∟sub-${ursi}_ses-${mrqid}_${mod}.json
        |              |    ∟sub-${ursi}_ses-${mrqid}_${mod}.nii.gz
        |              ∟qa/
        |                   ∟sub-${ursi}_ses-${mrqid}_qa_acq-${acq}.json
        |                   ∟sub-${ursi}_ses-${mrqid}_qa_acq-${acq}.nii.gz
        ∟deriv/
        |    ∟anat/
        |    |    ∟native/
        |    |    |    ∟sub-${ursi}_ses-${mrqid}_${mod}[_pre-${order}-${proc}].nii.gz
        |    |    |    ∟sub-${ursi}_ses-${mrqid}_${mod}[_mask-${roi}].nii.gz
        |    |    |    ∟(sub-1234_ses-123456_T1w_pre-01-acpc.nii.gz)
        |    |    |    ∟(sub-1234_ses-123456_T1w_pre-02-dn.nii.gz)
        |    |    |    ∟(sub-1234_ses-123456_T1w_pre-03-bc.nii.gz)
        |    |    |    ∟(sub-1234_ses-123456_T1w_pre-04-bex.nii.gz)
        |    |    |    ∟(sub-1234_ses-123456_T1w_pre-05-seg_class-csf.nii.gz)
        |    |    |    ∟(sub-1234_ses-123456_T1w_pre-05-seg_class-gm.nii.gz)
        |    |    |    ∟(sub-1234_ses-123456_T1w_pre-05-seg_class-wm.nii.gz)
        |    |    ∟reg_[${space}]/ (e.g. mni, etc. [accompanying transforms in tform folder])
        |    ∟b2/   
             |    ∟b2_sub-${ursi}_ses-${mrqid}.zip 
        |    ∟baw/  BrainsAutoWorkup-BRAINSTools
             |    ∟${ursi}/
                  |    ∟${mrqid}/
                       |    ∟ACCUMULATED_POSTERIORS/
                            |    ∟POSTERIOR_BACKGROUND_TOTAL.nii.gz
                            |    ∟POSTERIOR_CSF_TOTAL.nii.gz
                            |    ∟POSTERIOR_GLOBUS_TOTAL.nii.gz
                            |    ∟POSTERIOR_GM_TOTAL.nii.gz
                            |    ∟POSTERIOR_VB_TOTAL.nii.gz
                            |    ∟POSTERIOR_WM_TOTAL.nii.gz
                        |    ∟ACPCAlign/
                            |    ∟BCD_ACPC_Landmarks.fcsv
                            |    ∟BCD_Branded2DQCimage.png
                            |    ∟BCD_Original.fcsv
                            |    ∟BCD_Original2ACPC_transform.h5
                            |    ∟Cropped_BCD_ACPC_Aligned.nii.gz
                            |    ∟landmarkInitializer_atlas_to_subject_transform.h5
                        |    ∟JointFusion/
                            |    ∟JointFusion_HDAtlas20_2015_dustCleaned_label.nii.gz
                            |    ∟JointFusion_HDAtlas20_2015_fs_standard_label.nii.gz
                            |    ∟JointFusion_HDAtlas20_2015_lobe_label.nii.gz
                                |    ∟allVol/
                                     |    ∟labelVolume.csv
                                     |    ∟labelVolume.json
                                |    ∟lobeVol/
                                     |    ∟labelVolume.csv
                                     |    ∟labelVolume.json
                        |    ∟TissueClassify/
                            |    ∟POSTERIOR_AIR.nii.gz
                            |    ∟POSTERIOR_BASAL.nii.gz
                            |    ∟POSTERIOR_CRBLGM.nii.gz
                            |    ∟POSTERIOR_CRBLWM.nii.gz
                            |    ∟POSTERIOR_CSF.nii.gz
                            |    ∟POSTERIOR_GLOBUS.nii.gz
                            |    ∟POSTERIOR_HIPPOCAMPUS.nii.gz
                            |    ∟POSTERIOR_NOTCSF.nii.gz
                            |    ∟POSTERIOR_NOTGM.nii.gz
                            |    ∟POSTERIOR_NOTVB.nii.gz
                            |    ∟POSTERIOR_NOTWM.nii.gz
                            |    ∟POSTERIOR_SURFGM.nii.gz
                            |    ∟POSTERIOR_THALAMUS.nii.gz
                            |    ∟POSTERIOR_VB.nii.gz
                            |    ∟POSTERIOR_WM.nii.gz
                            |    ∟atlas_to_subject.h5
                            |    ∟complete_brainlabels_seg.nii.gz
                            |    ∟fixed_headlabels_seg.nii.gz
                            |    ∟t1_average_BRAINSABC.nii.gz
                            |    ∟t2_average_BRAINSABC.nii.gz
                        |    ∟WarpedAtlas2Subject/
                            |    ∟hncma_atlas.nii.gz
                            |    ∟l_accumben_ProbabilityMap.nii.gz
                            |    ∟l_caudate_ProbabilityMap.nii.gz
                            |    ∟l_globus_ProbabilityMap.nii.gz
                            |    ∟l_hippocampus_ProbabilityMap.nii.gz
                            |    ∟l_putamen_ProbabilityMap.nii.gz
                            |    ∟l_thalamus_ProbabilityMap.nii.gz
                            |    ∟left_hemisphere_wm.nii.gz
                            |    ∟phi.nii.gz
                            |    ∟r_accumben_ProbabilityMap.nii.gz
                            |    ∟r_caudate_ProbabilityMap.nii.gz
                            |    ∟r_globus_ProbabilityMap.nii.gz
                            |    ∟r_hippocampus_ProbabilityMap.nii.gz
                            |    ∟r_putamen_ProbabilityMap.nii.gz
                            |    ∟r_thalamus_ProbabilityMap.nii.gz
                            |    ∟rho.nii.gz
                            |    ∟right_hemisphere_wm.nii.gz
                            |    ∟template_WMPM2_labels.nii.gz
                            |    ∟template_headregion.nii.gz
                            |    ∟template_leftHemisphere.nii.gz
                            |    ∟template_nac_labels.nii.gz
                            |    ∟template_rightHemisphere.nii.gz
                            |    ∟template_ventricles.nii.gz
                            |    ∟theta.nii.gz
        |    ∟dwi/
        |    ∟fsurf/ (Freesurfer subject directory)
             |    ∟fsurfexperiment_${ursi}_${mrqid}
                  |    ∟label/
                       |    ∟BA_exvivo.ctab
                       |    ∟BA_exvivo.thresh.ctab
                       |    ∟aparc.annot.DKTatlas.ctab
                       |    ∟aparc.annot.a2009s.ctab
                       |    ∟aparc.annot.ctab
                       |    ∟lh.BA1_exvivo.label
                       |    ∟lh.BA1_exvivo.thresh.label
                       |    ∟lh.BA2_exvivo.label
                       |    ∟lh.BA2_exvivo.thresh.label
                       |    ∟lh.BA3a_exvivo.label
                       |    ∟lh.BA3a_exvivo.thresh.label
                       |    ∟lh.BA3b_exvivo.label
                       |    ∟lh.BA3b_exvivo.thresh.label
                       |    ∟lh.BA44_exvivo.label
                       |    ∟lh.BA44_exvivo.thresh.label
                       |    ∟lh.BA45_exvivo.label
                       |    ∟lh.BA45_exvivo.thresh.label
                       |    ∟lh.BA4a_exvivo.label
                       |    ∟lh.BA4a_exvivo.thresh.label
                       |    ∟lh.BA4p_exvivo.label
                       |    ∟lh.BA4p_exvivo.thresh.label
                       |    ∟lh.BA6_exvivo.label
                       |    ∟lh.BA6_exvivo.thresh.label
                       |    ∟lh.BA_exvivo.annot
                       |    ∟lh.BA_exvivo.thresh.annot
                       |    ∟lh.MT_exvivo.label
                       |    ∟lh.MT_exvivo.thresh.label
                       |    ∟lh.V1_exvivo.label
                       |    ∟lh.V1_exvivo.thresh.label
                       |    ∟lh.V2_exvivo.label
                       |    ∟lh.V2_exvivo.thresh.label
                       |    ∟lh.aparc.DKTatlas.annot
                       |    ∟lh.aparc.a2009s.annot
                       |    ∟lh.aparc.annot
                       |    ∟lh.cortex.label
                       |    ∟lh.entorhinal_exvivo.label
                       |    ∟lh.entorhinal_exvivo.thresh.label
                       |    ∟lh.perirhinal_exvivo.label
                       |    ∟lh.perirhinal_exvivo.thresh.label
                       |    ∟rh.BA1_exvivo.label
                       |    ∟rh.BA1_exvivo.thresh.label
                       |    ∟rh.BA2_exvivo.label
                       |    ∟rh.BA2_exvivo.thresh.label
                       |    ∟rh.BA3a_exvivo.label
                       |    ∟rh.BA3a_exvivo.thresh.label
                       |    ∟rh.BA3b_exvivo.label
                       |    ∟rh.BA3b_exvivo.thresh.label
                       |    ∟rh.BA44_exvivo.label
                       |    ∟rh.BA44_exvivo.thresh.label
                       |    ∟rh.BA45_exvivo.label
                       |    ∟rh.BA45_exvivo.thresh.label
                       |    ∟rh.BA4a_exvivo.label
                       |    ∟rh.BA4a_exvivo.thresh.label
                       |    ∟rh.BA4p_exvivo.label
                       |    ∟rh.BA4p_exvivo.thresh.label
                       |    ∟rh.BA6_exvivo.label
                       |    ∟rh.BA6_exvivo.thresh.label
                       |    ∟rh.BA_exvivo.annot
                       |    ∟rh.BA_exvivo.thresh.annot
                       |    ∟rh.MT_exvivo.label
                       |    ∟rh.MT_exvivo.thresh.label
                       |    ∟rh.V1_exvivo.label
                       |    ∟rh.V1_exvivo.thresh.label
                       |    ∟rh.V2_exvivo.label
                       |    ∟rh.V2_exvivo.thresh.label
                       |    ∟rh.aparc.DKTatlas.annot
                       |    ∟rh.aparc.a2009s.annot
                       |    ∟rh.aparc.annot
                       |    ∟rh.cortex.label
                       |    ∟rh.entorhinal_exvivo.label
                       |    ∟rh.entorhinal_exvivo.thresh.label
                       |    ∟rh.perirhinal_exvivo.label
                       |    ∟rh.perirhinal_exvivo.thresh.label                  
                  |    ∟mri/
                       |    ∟T1.mgz
                       |    ∟T2.mgz
                       |    ∟T2.norm.mgz
                       |    ∟T2.prenorm.mgz
                       |    ∟aparc+aseg.mgz
                       |    ∟aparc.DKTatlas+aseg.mgz
                       |    ∟aparc.a2009s+aseg.mgz
                       |    ∟aseg.auto.mgz
                       |    ∟aseg.auto_noCCseg.label_intensities.txt
                       |    ∟aseg.auto_noCCseg.mgz
                       |    ∟aseg.mgz
                       |    ∟aseg.presurf.hypos.mgz
                       |    ∟aseg.presurf.mgz
                       |    ∟brain.finalsurfs.mgz
                       |    ∟brain.mgz
                       |    ∟brainmask.auto.mgz
                       |    ∟brainmask.mgz
                       |    ∟ctrl_pts.mgz
                       |    ∟filled.mgz
                       |    ∟lh.ribbon.mgz
                       |    ∟mri_nu_correct.mni.log
                       |    ∟mri_nu_correct.mni.log.bak
                       |    ∟norm.mgz
                       |    ∟nu.mgz
                       |    ∟orig/
                            |    ∟001.mgz
                            |    ∟T2raw.mgz                       
                       |    ∟orig.mgz
                       |    ∟orig_nu.mgz
                       |    ∟rawavg.mgz
                       |    ∟rh.ribbon.mgz
                       |    ∟ribbon.mgz
                       |    ∟segment.dat
                       |    ∟talairach.label_intensities.txt
                       |    ∟talairach.log
                       |    ∟talairach_with_skull.log
                       |    ∟transforms/
                            |    ∟T2raw.auto.dat
                            |    ∟T2raw.auto.dat.log
                            |    ∟T2raw.auto.dat.mincost
                            |    ∟T2raw.auto.dat.param
                            |    ∟T2raw.auto.dat.sum
                            |    ∟T2raw.auto.dat~
                            |    ∟T2raw.auto.lta
                            |    ∟T2raw.lta
                            |    ∟bak/
                            |    ∟cc_up.lta
                            |    ∟talairach.auto.xfm
                            |    ∟talairach.auto.xfm.lta
                            |    ∟talairach.lta
                            |    ∟talairach.m3z
                            |    ∟talairach.xfm
                            |    ∟talairach_avi.log
                            |    ∟talairach_avi_QA.log
                            |    ∟talairach_with_skull.lta
                            |    ∟talsrcimg_to_711-2C_as_mni_average_305_t4_vox2vox.txt                       
                            |    ∟wm.asegedit.mgz
                            |    ∟wm.mgz
                            |    ∟wm.seg.mgz
                            |    ∟wmparc.mgz                  
                  |    ∟scripts/
                       |    ∟build-stamp.txt
                       |    ∟lastcall.build-stamp.txt
                       |    ∟patchdir.txt
                       |    ∟pctsurfcon.log
                       |    ∟pctsurfcon.log.old
                       |    ∟ponscc.cut.log
                       |    ∟recon-all-status.log
                       |    ∟recon-all.cmd
                       |    ∟recon-all.done
                       |    ∟recon-all.env
                       |    ∟recon-all.env.bak
                       |    ∟recon-all.local-copy
                       |    ∟recon-all.log                  
                  |    ∟stats/
                  |    ∟surf/
                  |    ∟tmp/
                  |    ∟touch/
                  |    ∟trash/
        |    ∟func/
        |    |    ∟ts/
        |    |    |    ∟sub-${ursi}_ses-${mrqid}_task-${task}_[_pre-${order}-${proc}].nii.gz
        |    |    ∟stb/
        |    ∟mrs/
        |    ∟tform/
        |    ∟qc/
        |    ∟log/
        ∟scripts
        |    ∟dicom_idx
        |    |    ∟master_dicom-idx.tsv
        |    |    |    - have a master for each study, copy and make changes for each subject
        |    |    ∟sub-${ursi}_ses-${mrqid}_dicom-idx.tsv (tab-separated)
        |    |         - column 1: scan directory inside zip file, e.g. /SCAN/1/DICOM,
        |    |         - column 2: destination folder: anat, dwi, fmap, func, mrs, other, qa
        |    |         - column 3: field name, e.g., mod, acq, task, roi, rec, run, echo, etc
        |    |         - column 4: field value, e.g., [${mod}] T1w, [${task}] rest, etc.
        ∟summary
             ∟${projectName}_${data_description}_${YYYYMMDD}.csv
             ∟(DM1_bt-volumetrics-wb_20180831.csv)
             ∟(DM1_fsurf-volumetrics-all_20180831.csv)
```

# Filename Fields (and order)
```
anat/
sub-${ursi}_ses-${mrqid}[_acq-${acq}][_run-${#}][_echo-${#}]_${mod}
mod=T1w|T2w|T1rho|T1map|T2map|T2star|FLAIR|FLASH|PD|PDT2|inplaneT1|inplaneT2|angio

dwi/
sub-${ursi}_ses-${mrqid}[_acq-${acq}][_b-${b}][_dir-${dir}][_pe-${pe}][_run-${#}]_dwi.nii.gz

func/
sub-${ursi}_ses-${mrqid}_task-${task}[_acq-${acq}][_pe-${pe}][_rec-${}][_run-${#}][_echo-${#}]_${mod}.nii.gz
mod=bold|T1rho
```

# Modality Labels - ${mod}
```
T1 weighted               T1w
T2 weighted               T2w
T1 rho                    T1rho
quantitative T1 map       T1map
quantitative T2 map       T2map
T2*/SWE                   T2star
FLAIR                     FLAIR
FLASH                     FLASH
Proton density            PD
Proton density map        PDmap
Combined PD/T2            PDT2
Inplane T1                inplaneT1	          T1-weighted matched to functional acquisition
Inplane T2                inplaneT2	          T2-weighted matched to functional acquisition
Angiography               angio
Spectroscopy              MRS
```

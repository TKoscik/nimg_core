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
                       |    ∟aseg.stats
                       |    ∟lh.BA_exvivo.stats
                       |    ∟lh.BA_exvivo.thresh.stats
                       |    ∟lh.aparc.DKTatlas.stats
                       |    ∟lh.aparc.a2009s.stats
                       |    ∟lh.aparc.pial.stats
                       |    ∟lh.aparc.stats
                       |    ∟lh.curv.stats
                       |    ∟lh.w-g.pct.stats
                       |    ∟rh.BA_exvivo.stats
                       |    ∟rh.BA_exvivo.thresh.stats
                       |    ∟rh.aparc.DKTatlas.stats
                       |    ∟rh.aparc.a2009s.stats
                       |    ∟rh.aparc.pial.stats
                       |    ∟rh.aparc.stats
                       |    ∟rh.curv.stats
                       |    ∟rh.w-g.pct.stats
                       |    ∟wmparc.stats            
                  |    ∟surf/
                       |    ∟lh.area
                       |    ∟lh.area.fsaverage.mgh
                       |    ∟lh.area.fsaverage.mris_preproc.log
                       |    ∟lh.area.fwhm0.fsaverage.mgh
                       |    ∟lh.area.fwhm10.fsaverage.mgh
                       |    ∟lh.area.fwhm15.fsaverage.mgh
                       |    ∟lh.area.fwhm20.fsaverage.mgh
                       |    ∟lh.area.fwhm25.fsaverage.mgh
                       |    ∟lh.area.fwhm5.fsaverage.mgh
                       |    ∟lh.area.mid
                       |    ∟lh.area.pial
                       |    ∟lh.area.pial.fsaverage.mgh
                       |    ∟lh.area.pial.fsaverage.mris_preproc.log
                       |    ∟lh.area.pial.fwhm0.fsaverage.mgh
                       |    ∟lh.area.pial.fwhm10.fsaverage.mgh
                       |    ∟lh.area.pial.fwhm15.fsaverage.mgh
                       |    ∟lh.area.pial.fwhm20.fsaverage.mgh
                       |    ∟lh.area.pial.fwhm25.fsaverage.mgh
                       |    ∟lh.area.pial.fwhm5.fsaverage.mgh
                       |    ∟lh.avg_curv
                       |    ∟lh.curv
                       |    ∟lh.curv.fsaverage.mgh
                       |    ∟lh.curv.fsaverage.mris_preproc.log
                       |    ∟lh.curv.fwhm0.fsaverage.mgh
                       |    ∟lh.curv.fwhm10.fsaverage.mgh
                       |    ∟lh.curv.fwhm15.fsaverage.mgh
                       |    ∟lh.curv.fwhm20.fsaverage.mgh
                       |    ∟lh.curv.fwhm25.fsaverage.mgh
                       |    ∟lh.curv.fwhm5.fsaverage.mgh
                       |    ∟lh.curv.pial
                       |    ∟lh.defect_borders
                       |    ∟lh.defect_chull
                       |    ∟lh.defect_labels
                       |    ∟lh.inflated
                       |    ∟lh.inflated.H
                       |    ∟lh.inflated.K
                       |    ∟lh.inflated.nofix
                       |    ∟lh.jacobian_white
                       |    ∟lh.jacobian_white.fsaverage.mgh
                       |    ∟lh.jacobian_white.fsaverage.mris_preproc.log
                       |    ∟lh.jacobian_white.fwhm0.fsaverage.mgh
                       |    ∟lh.jacobian_white.fwhm10.fsaverage.mgh
                       |    ∟lh.jacobian_white.fwhm15.fsaverage.mgh
                       |    ∟lh.jacobian_white.fwhm20.fsaverage.mgh
                       |    ∟lh.jacobian_white.fwhm25.fsaverage.mgh
                       |    ∟lh.jacobian_white.fwhm5.fsaverage.mgh
                       |    ∟lh.orig
                       |    ∟lh.orig.nofix
                       |    ∟lh.pial
                       |    ∟lh.qsphere.nofix
                       |    ∟lh.smoothwm
                       |    ∟lh.smoothwm.BE.crv
                       |    ∟lh.smoothwm.C.crv
                       |    ∟lh.smoothwm.FI.crv
                       |    ∟lh.smoothwm.H.crv
                       |    ∟lh.smoothwm.K.crv
                       |    ∟lh.smoothwm.K1.crv
                       |    ∟lh.smoothwm.K2.crv
                       |    ∟lh.smoothwm.S.crv
                       |    ∟lh.smoothwm.nofix
                       |    ∟lh.sphere
                       |    ∟lh.sphere.reg
                       |    ∟lh.sulc
                       |    ∟lh.sulc.fsaverage.mgh
                       |    ∟lh.sulc.fsaverage.mris_preproc.log
                       |    ∟lh.sulc.fwhm0.fsaverage.mgh
                       |    ∟lh.sulc.fwhm10.fsaverage.mgh
                       |    ∟lh.sulc.fwhm15.fsaverage.mgh
                       |    ∟lh.sulc.fwhm20.fsaverage.mgh
                       |    ∟lh.sulc.fwhm25.fsaverage.mgh
                       |    ∟lh.sulc.fwhm5.fsaverage.mgh
                       |    ∟lh.thickness
                       |    ∟lh.thickness.fsaverage.mgh
                       |    ∟lh.thickness.fsaverage.mris_preproc.log
                       |    ∟lh.thickness.fwhm0.fsaverage.mgh
                       |    ∟lh.thickness.fwhm10.fsaverage.mgh
                       |    ∟lh.thickness.fwhm15.fsaverage.mgh
                       |    ∟lh.thickness.fwhm20.fsaverage.mgh
                       |    ∟lh.thickness.fwhm25.fsaverage.mgh
                       |    ∟lh.thickness.fwhm5.fsaverage.mgh
                       |    ∟lh.volume
                       |    ∟lh.volume.fsaverage.mgh
                       |    ∟lh.volume.fsaverage.mris_preproc.log
                       |    ∟lh.volume.fwhm0.fsaverage.mgh
                       |    ∟lh.volume.fwhm10.fsaverage.mgh
                       |    ∟lh.volume.fwhm15.fsaverage.mgh
                       |    ∟lh.volume.fwhm20.fsaverage.mgh
                       |    ∟lh.volume.fwhm25.fsaverage.mgh
                       |    ∟lh.volume.fwhm5.fsaverage.mgh
                       |    ∟lh.w-g.pct.mgh
                       |    ∟lh.w-g.pct.mgh.fsaverage.mgh
                       |    ∟lh.w-g.pct.mgh.fsaverage.mris_preproc.log
                       |    ∟lh.w-g.pct.mgh.fwhm0.fsaverage.mgh
                       |    ∟lh.w-g.pct.mgh.fwhm10.fsaverage.mgh
                       |    ∟lh.w-g.pct.mgh.fwhm15.fsaverage.mgh
                       |    ∟lh.w-g.pct.mgh.fwhm20.fsaverage.mgh
                       |    ∟lh.w-g.pct.mgh.fwhm25.fsaverage.mgh
                       |    ∟lh.w-g.pct.mgh.fwhm5.fsaverage.mgh
                       |    ∟lh.white
                       |    ∟lh.white.H
                       |    ∟lh.white.H.fsaverage.mgh
                       |    ∟lh.white.H.fsaverage.mris_preproc.log
                       |    ∟lh.white.H.fwhm0.fsaverage.mgh
                       |    ∟lh.white.H.fwhm10.fsaverage.mgh
                       |    ∟lh.white.H.fwhm15.fsaverage.mgh
                       |    ∟lh.white.H.fwhm20.fsaverage.mgh
                       |    ∟lh.white.H.fwhm25.fsaverage.mgh
                       |    ∟lh.white.H.fwhm5.fsaverage.mgh
                       |    ∟lh.white.K
                       |    ∟lh.white.K.fsaverage.mgh
                       |    ∟lh.white.K.fsaverage.mris_preproc.log
                       |    ∟lh.white.K.fwhm0.fsaverage.mgh
                       |    ∟lh.white.K.fwhm10.fsaverage.mgh
                       |    ∟lh.white.K.fwhm15.fsaverage.mgh
                       |    ∟lh.white.K.fwhm20.fsaverage.mgh
                       |    ∟lh.white.K.fwhm25.fsaverage.mgh
                       |    ∟lh.white.K.fwhm5.fsaverage.mgh
                       |    ∟lh.white.preaparc
                       |    ∟lh.white.preaparc.H
                       |    ∟lh.white.preaparc.K
                       |    ∟lh.woT2.pial
                       |    ∟rh.area
                       |    ∟rh.area.fsaverage.mgh
                       |    ∟rh.area.fsaverage.mris_preproc.log
                       |    ∟rh.area.fwhm0.fsaverage.mgh
                       |    ∟rh.area.fwhm10.fsaverage.mgh
                       |    ∟rh.area.fwhm15.fsaverage.mgh
                       |    ∟rh.area.fwhm20.fsaverage.mgh
                       |    ∟rh.area.fwhm25.fsaverage.mgh
                       |    ∟rh.area.fwhm5.fsaverage.mgh
                       |    ∟rh.area.mid
                       |    ∟rh.area.pial
                       |    ∟rh.area.pial.fsaverage.mgh
                       |    ∟rh.area.pial.fsaverage.mris_preproc.log
                       |    ∟rh.area.pial.fwhm0.fsaverage.mgh
                       |    ∟rh.area.pial.fwhm10.fsaverage.mgh
                       |    ∟rh.area.pial.fwhm15.fsaverage.mgh
                       |    ∟rh.area.pial.fwhm20.fsaverage.mgh
                       |    ∟rh.area.pial.fwhm25.fsaverage.mgh
                       |    ∟rh.area.pial.fwhm5.fsaverage.mgh
                       |    ∟rh.avg_curv
                       |    ∟rh.curv
                       |    ∟rh.curv.fsaverage.mgh
                       |    ∟rh.curv.fsaverage.mris_preproc.log
                       |    ∟rh.curv.fwhm0.fsaverage.mgh
                       |    ∟rh.curv.fwhm10.fsaverage.mgh
                       |    ∟rh.curv.fwhm15.fsaverage.mgh
                       |    ∟rh.curv.fwhm20.fsaverage.mgh
                       |    ∟rh.curv.fwhm25.fsaverage.mgh
                       |    ∟rh.curv.fwhm5.fsaverage.mgh
                       |    ∟rh.curv.pial
                       |    ∟rh.defect_borders
                       |    ∟rh.defect_chull
                       |    ∟rh.defect_labels
                       |    ∟rh.inflated
                       |    ∟rh.inflated.H
                       |    ∟rh.inflated.K
                       |    ∟rh.inflated.nofix
                       |    ∟rh.jacobian_white
                       |    ∟rh.jacobian_white.fsaverage.mgh
                       |    ∟rh.jacobian_white.fsaverage.mris_preproc.log
                       |    ∟rh.jacobian_white.fwhm0.fsaverage.mgh
                       |    ∟rh.jacobian_white.fwhm10.fsaverage.mgh
                       |    ∟rh.jacobian_white.fwhm15.fsaverage.mgh
                       |    ∟rh.jacobian_white.fwhm20.fsaverage.mgh
                       |    ∟rh.jacobian_white.fwhm25.fsaverage.mgh
                       |    ∟rh.jacobian_white.fwhm5.fsaverage.mgh
                       |    ∟rh.orig
                       |    ∟rh.orig.nofix
                       |    ∟rh.pial
                       |    ∟rh.qsphere.nofix
                       |    ∟rh.smoothwm
                       |    ∟rh.smoothwm.BE.crv
                       |    ∟rh.smoothwm.C.crv
                       |    ∟rh.smoothwm.FI.crv
                       |    ∟rh.smoothwm.H.crv
                       |    ∟rh.smoothwm.K.crv
                       |    ∟rh.smoothwm.K1.crv
                       |    ∟rh.smoothwm.K2.crv
                       |    ∟rh.smoothwm.S.crv
                       |    ∟rh.smoothwm.nofix
                       |    ∟rh.sphere
                       |    ∟rh.sphere.reg
                       |    ∟rh.sulc
                       |    ∟rh.sulc.fsaverage.mgh
                       |    ∟rh.sulc.fsaverage.mris_preproc.log
                       |    ∟rh.sulc.fwhm0.fsaverage.mgh
                       |    ∟rh.sulc.fwhm10.fsaverage.mgh
                       |    ∟rh.sulc.fwhm15.fsaverage.mgh
                       |    ∟rh.sulc.fwhm20.fsaverage.mgh
                       |    ∟rh.sulc.fwhm25.fsaverage.mgh
                       |    ∟rh.sulc.fwhm5.fsaverage.mgh
                       |    ∟rh.thickness
                       |    ∟rh.thickness.fsaverage.mgh
                       |    ∟rh.thickness.fsaverage.mris_preproc.log
                       |    ∟rh.thickness.fwhm0.fsaverage.mgh
                       |    ∟rh.thickness.fwhm10.fsaverage.mgh
                       |    ∟rh.thickness.fwhm15.fsaverage.mgh
                       |    ∟rh.thickness.fwhm20.fsaverage.mgh
                       |    ∟rh.thickness.fwhm25.fsaverage.mgh
                       |    ∟rh.thickness.fwhm5.fsaverage.mgh
                       |    ∟rh.volume
                       |    ∟rh.volume.fsaverage.mgh
                       |    ∟rh.volume.fsaverage.mris_preproc.log
                       |    ∟rh.volume.fwhm0.fsaverage.mgh
                       |    ∟rh.volume.fwhm10.fsaverage.mgh
                       |    ∟rh.volume.fwhm15.fsaverage.mgh
                       |    ∟rh.volume.fwhm20.fsaverage.mgh
                       |    ∟rh.volume.fwhm25.fsaverage.mgh
                       |    ∟rh.volume.fwhm5.fsaverage.mgh
                       |    ∟rh.w-g.pct.mgh
                       |    ∟rh.w-g.pct.mgh.fsaverage.mgh
                       |    ∟rh.w-g.pct.mgh.fsaverage.mris_preproc.log
                       |    ∟rh.w-g.pct.mgh.fwhm0.fsaverage.mgh
                       |    ∟rh.w-g.pct.mgh.fwhm10.fsaverage.mgh
                       |    ∟rh.w-g.pct.mgh.fwhm15.fsaverage.mgh
                       |    ∟rh.w-g.pct.mgh.fwhm20.fsaverage.mgh
                       |    ∟rh.w-g.pct.mgh.fwhm25.fsaverage.mgh
                       |    ∟rh.w-g.pct.mgh.fwhm5.fsaverage.mgh
                       |    ∟rh.white
                       |    ∟rh.white.H
                       |    ∟rh.white.H.fsaverage.mgh
                       |    ∟rh.white.H.fsaverage.mris_preproc.log
                       |    ∟rh.white.H.fwhm0.fsaverage.mgh
                       |    ∟rh.white.H.fwhm10.fsaverage.mgh
                       |    ∟rh.white.H.fwhm15.fsaverage.mgh
                       |    ∟rh.white.H.fwhm20.fsaverage.mgh
                       |    ∟rh.white.H.fwhm25.fsaverage.mgh
                       |    ∟rh.white.H.fwhm5.fsaverage.mgh
                       |    ∟rh.white.K
                       |    ∟rh.white.K.fsaverage.mgh
                       |    ∟rh.white.K.fsaverage.mris_preproc.log
                       |    ∟rh.white.K.fwhm0.fsaverage.mgh
                       |    ∟rh.white.K.fwhm10.fsaverage.mgh
                       |    ∟rh.white.K.fwhm15.fsaverage.mgh
                       |    ∟rh.white.K.fwhm20.fsaverage.mgh
                       |    ∟rh.white.K.fwhm25.fsaverage.mgh
                       |    ∟rh.white.K.fwhm5.fsaverage.mgh
                       |    ∟rh.white.preaparc
                       |    ∟rh.white.preaparc.H
                       |    ∟rh.white.preaparc.K
                       |    ∟rh.woT2.pial                  
                  |    ∟tmp/
                       |    ∟cw256                  
                  |    ∟touch/
                       |    ∟aparc.DKTatlas2aseg.touch
                       |    ∟aparc.a2009s2aseg.touch
                       |    ∟apas2aseg.touch
                       |    ∟asegmerge.touch
                       |    ∟ca_label.touch
                       |    ∟ca_normalize.touch
                       |    ∟ca_register.touch
                       |    ∟conform.touch
                       |    ∟cortical_ribbon.touch
                       |    ∟em_register.touch
                       |    ∟fill.touch
                       |    ∟inorm1.touch
                       |    ∟inorm2.touch
                       |    ∟lh.aparc.touch
                       |    ∟lh.aparc2.touch
                       |    ∟lh.aparcstats.touch
                       |    ∟lh.aparcstats2.touch
                       |    ∟lh.aparcstats3.touch
                       |    ∟lh.area.0.qcache.touch
                       |    ∟lh.area.10.qcache.touch
                       |    ∟lh.area.15.qcache.touch
                       |    ∟lh.area.20.qcache.touch
                       |    ∟lh.area.25.qcache.touch
                       |    ∟lh.area.5.qcache.touch
                       |    ∟lh.area.pial.0.qcache.touch
                       |    ∟lh.area.pial.10.qcache.touch
                       |    ∟lh.area.pial.15.qcache.touch
                       |    ∟lh.area.pial.20.qcache.touch
                       |    ∟lh.area.pial.25.qcache.touch
                       |    ∟lh.area.pial.5.qcache.touch
                       |    ∟lh.avgcurv.touch
                       |    ∟lh.curv.0.qcache.touch
                       |    ∟lh.curv.10.qcache.touch
                       |    ∟lh.curv.15.qcache.touch
                       |    ∟lh.curv.20.qcache.touch
                       |    ∟lh.curv.25.qcache.touch
                       |    ∟lh.curv.5.qcache.touch
                       |    ∟lh.curvstats.touch
                       |    ∟lh.final_surfaces.touch
                       |    ∟lh.inflate.H.K.touch
                       |    ∟lh.inflate1.touch
                       |    ∟lh.inflate2.touch
                       |    ∟lh.jacobian_white.0.qcache.touch
                       |    ∟lh.jacobian_white.10.qcache.touch
                       |    ∟lh.jacobian_white.15.qcache.touch
                       |    ∟lh.jacobian_white.20.qcache.touch
                       |    ∟lh.jacobian_white.25.qcache.touch
                       |    ∟lh.jacobian_white.5.qcache.touch
                       |    ∟lh.jacobian_white.touch
                       |    ∟lh.pctsurfcon.touch
                       |    ∟lh.pial_refine.touch
                       |    ∟lh.pial_surface.touch
                       |    ∟lh.qsphere.touch
                       |    ∟lh.smoothwm1.touch
                       |    ∟lh.smoothwm2.touch
                       |    ∟lh.sphmorph.touch
                       |    ∟lh.sphreg.touch
                       |    ∟lh.sulc.0.qcache.touch
                       |    ∟lh.sulc.10.qcache.touch
                       |    ∟lh.sulc.15.qcache.touch
                       |    ∟lh.sulc.20.qcache.touch
                       |    ∟lh.sulc.25.qcache.touch
                       |    ∟lh.sulc.5.qcache.touch
                       |    ∟lh.surfvolume.touch
                       |    ∟lh.tessellate.touch
                       |    ∟lh.thickness.0.qcache.touch
                       |    ∟lh.thickness.10.qcache.touch
                       |    ∟lh.thickness.15.qcache.touch
                       |    ∟lh.thickness.20.qcache.touch
                       |    ∟lh.thickness.25.qcache.touch
                       |    ∟lh.thickness.5.qcache.touch
                       |    ∟lh.topofix.touch
                       |    ∟lh.volume.0.qcache.touch
                       |    ∟lh.volume.10.qcache.touch
                       |    ∟lh.volume.15.qcache.touch
                       |    ∟lh.volume.20.qcache.touch
                       |    ∟lh.volume.25.qcache.touch
                       |    ∟lh.volume.5.qcache.touch
                       |    ∟lh.w-g.pct.mgh.0.qcache.touch
                       |    ∟lh.w-g.pct.mgh.10.qcache.touch
                       |    ∟lh.w-g.pct.mgh.15.qcache.touch
                       |    ∟lh.w-g.pct.mgh.20.qcache.touch
                       |    ∟lh.w-g.pct.mgh.25.qcache.touch
                       |    ∟lh.w-g.pct.mgh.5.qcache.touch
                       |    ∟lh.white.H.0.qcache.touch
                       |    ∟lh.white.H.10.qcache.touch
                       |    ∟lh.white.H.15.qcache.touch
                       |    ∟lh.white.H.20.qcache.touch
                       |    ∟lh.white.H.25.qcache.touch
                       |    ∟lh.white.H.5.qcache.touch
                       |    ∟lh.white.H.K.touch
                       |    ∟lh.white.K.0.qcache.touch
                       |    ∟lh.white.K.10.qcache.touch
                       |    ∟lh.white.K.15.qcache.touch
                       |    ∟lh.white.K.20.qcache.touch
                       |    ∟lh.white.K.25.qcache.touch
                       |    ∟lh.white.K.5.qcache.touch
                       |    ∟lh.white_surface.touch
                       |    ∟nu.touch
                       |    ∟relabelhypos.touch
                       |    ∟rh.aparc.touch
                       |    ∟rh.aparc2.touch
                       |    ∟rh.aparcstats.touch
                       |    ∟rh.aparcstats2.touch
                       |    ∟rh.aparcstats3.touch
                       |    ∟rh.area.0.qcache.touch
                       |    ∟rh.area.10.qcache.touch
                       |    ∟rh.area.15.qcache.touch
                       |    ∟rh.area.20.qcache.touch
                       |    ∟rh.area.25.qcache.touch
                       |    ∟rh.area.5.qcache.touch
                       |    ∟rh.area.pial.0.qcache.touch
                       |    ∟rh.area.pial.10.qcache.touch
                       |    ∟rh.area.pial.15.qcache.touch
                       |    ∟rh.area.pial.20.qcache.touch
                       |    ∟rh.area.pial.25.qcache.touch
                       |    ∟rh.area.pial.5.qcache.touch
                       |    ∟rh.avgcurv.touch
                       |    ∟rh.curv.0.qcache.touch
                       |    ∟rh.curv.10.qcache.touch
                       |    ∟rh.curv.15.qcache.touch
                       |    ∟rh.curv.20.qcache.touch
                       |    ∟rh.curv.25.qcache.touch
                       |    ∟rh.curv.5.qcache.touch
                       |    ∟rh.curvstats.touch
                       |    ∟rh.final_surfaces.touch
                       |    ∟rh.inflate.H.K.touch
                       |    ∟rh.inflate1.touch
                       |    ∟rh.inflate2.touch
                       |    ∟rh.jacobian_white.0.qcache.touch
                       |    ∟rh.jacobian_white.10.qcache.touch
                       |    ∟rh.jacobian_white.15.qcache.touch
                       |    ∟rh.jacobian_white.20.qcache.touch
                       |    ∟rh.jacobian_white.25.qcache.touch
                       |    ∟rh.jacobian_white.5.qcache.touch
                       |    ∟rh.jacobian_white.touch
                       |    ∟rh.pctsurfcon.touch
                       |    ∟rh.pial_refine.touch
                       |    ∟rh.pial_surface.touch
                       |    ∟rh.qsphere.touch
                       |    ∟rh.smoothwm1.touch
                       |    ∟rh.smoothwm2.touch
                       |    ∟rh.sphmorph.touch
                       |    ∟rh.sphreg.touch
                       |    ∟rh.sulc.0.qcache.touch
                       |    ∟rh.sulc.10.qcache.touch
                       |    ∟rh.sulc.15.qcache.touch
                       |    ∟rh.sulc.20.qcache.touch
                       |    ∟rh.sulc.25.qcache.touch
                       |    ∟rh.sulc.5.qcache.touch
                       |    ∟rh.surfvolume.touch
                       |    ∟rh.tessellate.touch
                       |    ∟rh.thickness.0.qcache.touch
                       |    ∟rh.thickness.10.qcache.touch
                       |    ∟rh.thickness.15.qcache.touch
                       |    ∟rh.thickness.20.qcache.touch
                       |    ∟rh.thickness.25.qcache.touch
                       |    ∟rh.thickness.5.qcache.touch
                       |    ∟rh.topofix.touch
                       |    ∟rh.volume.0.qcache.touch
                       |    ∟rh.volume.10.qcache.touch
                       |    ∟rh.volume.15.qcache.touch
                       |    ∟rh.volume.20.qcache.touch
                       |    ∟rh.volume.25.qcache.touch
                       |    ∟rh.volume.5.qcache.touch
                       |    ∟rh.w-g.pct.mgh.0.qcache.touch
                       |    ∟rh.w-g.pct.mgh.10.qcache.touch
                       |    ∟rh.w-g.pct.mgh.15.qcache.touch
                       |    ∟rh.w-g.pct.mgh.20.qcache.touch
                       |    ∟rh.w-g.pct.mgh.25.qcache.touch
                       |    ∟rh.w-g.pct.mgh.5.qcache.touch
                       |    ∟rh.white.H.0.qcache.touch
                       |    ∟rh.white.H.10.qcache.touch
                       |    ∟rh.white.H.15.qcache.touch
                       |    ∟rh.white.H.20.qcache.touch
                       |    ∟rh.white.H.25.qcache.touch
                       |    ∟rh.white.H.5.qcache.touch
                       |    ∟rh.white.H.K.touch
                       |    ∟rh.white.K.0.qcache.touch
                       |    ∟rh.white.K.10.qcache.touch
                       |    ∟rh.white.K.15.qcache.touch
                       |    ∟rh.white.K.20.qcache.touch
                       |    ∟rh.white.K.25.qcache.touch
                       |    ∟rh.white.K.5.qcache.touch
                       |    ∟rh.white_surface.touch
                       |    ∟rusage.mri_ca_register.dat
                       |    ∟rusage.mri_em_register.dat
                       |    ∟rusage.mri_em_register.skull.dat
                       |    ∟rusage.mri_watershed.dat
                       |    ∟rusage.mris_fix_topology.lh.dat
                       |    ∟rusage.mris_fix_topology.rh.dat
                       |    ∟rusage.mris_inflate.lh.dat
                       |    ∟rusage.mris_inflate.rh.dat
                       |    ∟rusage.mris_register.lh.dat
                       |    ∟rusage.mris_register.rh.dat
                       |    ∟rusage.mris_sphere.lh.dat
                       |    ∟rusage.mris_sphere.rh.dat
                       |    ∟segstats.touch
                       |    ∟skull.lta.touch
                       |    ∟skull_strip.touch
                       |    ∟talairach.touch
                       |    ∟wmaparc.stats.touch
                       |    ∟wmaparc.touch
                       |    ∟wmsegment.touch                  
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

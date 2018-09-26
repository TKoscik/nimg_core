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
        |    ∟b2/   - (Brains2; legacy support only: ${mrqid-baseline} files only exist for longitudinal runs and <trm> mask only for                       manually edited brain masks)
             |    ∟sub-${ursi}_ses-${mrqid}.zip 
                ∟${ursi}/
                    ∟${mrqid}
                        ∟10_AUTO.v020<GE>
                        ${mrqid}_SumGrad.nii.gz
                        ${mrqid}_T1.nii.gz
                        ${mrqid}_T1.xfrm
                        ${mrqid}_T2.mat
                        ${mrqid}_T2.nii.gz
                        ${mrqid}_T2.xfrm
                        ${mrqid}_brain_cut<trm>.mask
                        ${mrqid}_class.nii.gz
                        ${mrqid}_class_Tissue_Class.mdl
                        ${mrqid}_cortex.mask
                        ANNCutOutl_ant_crblAutoSeg.nii.gz
                        ANNCutOutl_caudateAutoSeg.nii.gz
                        ANNCutOutl_corpus_crblAutoSeg.nii.gz
                        ANNCutOutl_hippoAutoSeg.nii.gz
                        ANNCutOutl_infpost_crblAutoSeg.nii.gz
                        ANNCutOutl_putamenAutoSeg.nii.gz
                        ANNCutOutl_suppost_crblAutoSeg.nii.gz
                        ANNCutOutl_thalamusAutoSeg.nii.gz
                        ANNCutOutr_ant_crblAutoSeg.nii.gz
                        ANNCutOutr_caudateAutoSeg.nii.gz
                        ANNCutOutr_corpus_crblAutoSeg.nii.gz
                        ANNCutOutr_hippoAutoSeg.nii.gz
                        ANNCutOutr_infpost_crblAutoSeg.nii.gz
                        ANNCutOutr_putamenAutoSeg.nii.gz
                        ANNCutOutr_suppost_crblAutoSeg.nii.gz
                        ANNCutOutr_thalamusAutoSeg.nii.gz
                        ANNSummedgross_crblAutoSeg.nii.gz
                        ANNThreshgross_crblAutoSeg.mask
                        ANNThreshl_ant_crblAutoSeg.mask
                        ANNThreshl_caudateAutoSeg.mask
                        ANNThreshl_corpus_crblAutoSeg.mask
                        ANNThreshl_hippoAutoSeg.mask
                        ANNThreshl_infpost_crblAutoSeg.mask
                        ANNThreshl_putamenAutoSeg.mask
                        ANNThreshl_suppost_crblAutoSeg.mask
                        ANNThreshl_thalamusAutoSeg.mask
                        ANNThreshr_ant_crblAutoSeg.mask
                        ANNThreshr_caudateAutoSeg.mask
                        ANNThreshr_corpus_crblAutoSeg.mask
                        ANNThreshr_hippoAutoSeg.mask
                        ANNThreshr_infpost_crblAutoSeg.mask
                        ANNThreshr_putamenAutoSeg.mask
                        ANNThreshr_suppost_crblAutoSeg.mask
                        ANNThreshr_thalamusAutoSeg.mask
                        AtlasToSubjectScaleBrainProb255.nii.gz
                        AtlasToSubjectScaleBrainProb255_thresh90_temp.mask
                        AtlasToSubjectScaleBrainProb255_thresh90_temp.mask.of_2018-09-11_at_12-00-34
                        AtlasToSubjectScaledAtlasBrainProb255.xfrm
                        Avg108_ScaledToSizeOfSubject.nii.gz
                        PreMush${mrqid}_UnclippedTissueClass_brain_cut.mask
                        TDWARPBrain_StructuresCut.AS
                        Talairach.bnd
                        UNIQUE_IDENTIFIER.txt
                        blood_plugs.mask
                        csf_plugs.mask
                        white_plugs.mask
                        delete
                            ${mrqid-baseline}_T1_fade15.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1.mat
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1.xfrm
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_T1RawFadedImage_lp0.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_T1RawFadedImage_lp1.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_T1RawSkullStripClippedIntensityImage_lp1.mask
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_T1RawSkullStripClippedIntensityImage_lp1.mask.of_2018-09-11_at_11-48-42
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_T1RawSkullStripClippedIntensityImage_lp1.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_T1RawSkullStripClippedIntensityImage_lp1_mask.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_T1RawToTmplRigidImage_lp1.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1.mat
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1.xfrm
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_T1RawFadedImage_lp2.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_T1RawSkullStripClippedIntensityImage_lp2.mask
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_T1RawSkullStripClippedIntensityImage_lp2.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_T1RawSkullStripClippedIntensityImage_lp2_mask.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_T1RawToTmplRigidImage_lp2.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_lp2.mat
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_lp2.xfrm
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_lp2_T1RawFadedImage_lp3.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_lp2_T1RawSkullStripClippedIntensityImage_lp3.mask
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_lp2_T1RawSkullStripClippedIntensityImage_lp3.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_lp2_T1RawSkullStripClippedIntensityImage_lp3_mask.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_lp2_T1RawToTmplRigidImage_lp3.nii.gz
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_lp2_lp3.mat
                            ${mrqid}_T1RawToTmplBootRotation__int_lp1_lp1_lp2_lp3.xfrm
                            ${mrqid}_T1RawToTmplFreeScale__int.mat
                            ${mrqid}_T1RawToTmplFreeScale__int.xfrm
                            ${mrqid}_T1RawToTmplRigidRotation__int.mat
                            ${mrqid}_T1RawToTmplRigidRotation__int.xfrm
                            ${mrqid}_T1_AlignedTo${mrqid-baseline}.nii.gz
                            ${mrqid}_T1_RAW_Short.nii.gz
                            ${mrqid}_T1_RAW_tempBfc.nii.gz
                            ${mrqid}_T1_RAW_tempBfc.nii.gz.bcoef
                            ${mrqid}_T1_trial_brainMask.nii.gz
                            ${mrqid}_T2_AlignedTo${mrqid-baseline}.nii.gz
                            ${mrqid}_T2_RAW_Short.nii.gz
                            ${mrqid}_T2_RAW_tempBfc.nii.gz
                            ${mrqid}_T2_RAW_tempBfc.nii.gz.bcoef
                            ${mrqid}_T2_trial_brainMask.nii.gz
                            ${mrqid}_UnclippedTissueClass_brain_cut.mask
                            ${mrqid}_UnclippedTissueClass_brain_cut_mush.mask
                            ${mrqid}_Unclipped_T1_AlignedTo${mrqid-baseline}.nii.gz
                            ${mrqid}_Unclipped_T1_AlignedTo${mrqid-baseline}_Bfc.nii.gz
                            ${mrqid}_Unclipped_T2_AlignedTo${mrqid-baseline}.nii.gz
                            ${mrqid}_Unclipped_T2_AlignedTo${mrqid-baseline}_Bfc.nii.gz
                            ${mrqid}_brain_trial.mask
                            ${mrqid}_brain_trial_mush.mask
                            ${mrqid}_class_bobf.nii.gz
                            ${mrqid}_class_clipped.nii.gz
                            ${mrqid}_trial_class.nii.gz
                            ${mrqid}_trial_class_Tissue_Class.mdl
                            ANNCutOutclass_whole_brainIMAGEPreMush${mrqid}_UnclippedTissueClass_brain_cut.nii.gz
                            ANNCutOutclass_whole_brainIMAGEPreMush${mrqid}_brain_trial.nii.gz
                            ANNThreshclass_whole_brainIMAGEPreMush${mrqid}_UnclippedTissueClass_brain_cut.mask
                            ANNThreshclass_whole_brainIMAGEPreMush${mrqid}_brain_trial.mask
                            PreMush${mrqid}_UnclippedTissueClass_brain_cut_TissueClassifiedBrainCut.AS
                            PreMush${mrqid}_brain_trial.mask
                            PreMush${mrqid}_brain_trial_TissueClassifiedBrainCut.AS
                            Talairach_TrialACPC.bnd
                            TmplToACPC_1st.mat
                            TmplToACPC_1st.xfrm
                            TmplToACPC_1st_Initial.mat
                            TmplToACPC_2nd.mat
                            TmplToACPC_2nd.xfrm
                            TmplToACPC_2nd_Initial.mat
                            blood_plugs.mask
                            brain_AlignedTo${mrqid-baseline}.mask
                            csf_plugs.mask
                            eroded_brain_AlignedTo${mrqid-baseline}.mask
                            final_tissueclass_onlyallspectra_AlignedTo${mrqid-baseline}.mask
                            gray_plugs.mask
                            prelim_tissueclass_onlyallspectra_AlignedTo${mrqid-baseline}.mask
                            white_plugs.mask
                            gray_plugs.mask
                        measurements
                            Brain_Class_Volumes.csv
                            Brain_Class_Volumes_Continuous_OneLine
                            Brain_Class_Volumes_Continuous_OneLine.csv
                            Brain_Class_Volumes_Continuous_OneLine.xml
                            Brain_Class_Volumes_Discrete_OneLine
                            Brain_Class_Volumes_Discrete_OneLine.csv
                            Brain_Class_Volumes_Discrete_OneLine.xml
                            Kappas.csv
                            Mask_Class_Volumes
                            Mask_Class_Volumes.csv
                            Mask_Class_Volumes_Continuous_OneLine.csv
                            Mask_Class_Volumes_Discrete_OneLine.csv
                            Standard_Class_Volumes
                            Standard_Class_Volumes.csv
                            Standard_Class_Volumes.xml
                            Standard_Class_Volumes_Continuous_OneLine.csv
                            Standard_Class_Volumes_Continuous_OneLine.xml
                            Standard_Class_Volumes_Discrete_OneLine.csv
                            Standard_Class_Volumes_Discrete_OneLine.xml    
                        raw
                            ${mrqid}_T1_RAW_Bfc.nii.gz
                            ${mrqid}_T1_trial_brain.mask
                            ${mrqid}_T2_RAW_Bfc.nii.gz
                            ${mrqid}_T2_trial_brain.mask
                            COPY_${mrqid}_T1.nii.gz
                            COPY_${mrqid}_T1_LNR.nii.gz
                            COPY_${mrqid}_T1_LNR_NoNk.nii.gz
                            COPY_${mrqid}_T2.nii.gz
        |    ∟baw/  (BrainsAutoWorkup) (a CACHE directory is created for intermediate results and should not be deleted til project is                          complete <BAWEXPERIMENTNAME_CACHE>)
                ∟<BAWEXPERIMENTNAME_Results>/<PROJECTNAME>
                    ∟${ursi}/
                        ∟${mrqid}/
                        ACCUMULATED_POSTERIORS
                            POSTERIOR_BACKGROUND_TOTAL.nii.gz
                            POSTERIOR_CSF_TOTAL.nii.gz
                            POSTERIOR_GLOBUS_TOTAL.nii.gz
                            POSTERIOR_GM_TOTAL.nii.gz
                            POSTERIOR_VB_TOTAL.nii.gz
                            POSTERIOR_WM_TOTAL.nii.gz
                        ACPCAlign
                            BCD_ACPC_Landmarks.fcsv
                            BCD_Branded2DQCimage.png
                            BCD_Original.fcsv
                            BCD_Original2ACPC_transform.h5
                            Cropped_BCD_ACPC_Aligned.nii.gz
                            landmarkInitializer_atlas_to_subject_transform.h5
                        JointFusion
                            JointFusion_HDAtlas20_2015_dustCleaned_label.nii.gz
                            JointFusion_HDAtlas20_2015_fs_standard_label.nii.gz
                            JointFusion_HDAtlas20_2015_lobe_label.nii.gz
                            allVol
                                labelVolume.csv
                                labelVolume.json
                            lobeVol
                                labelVolume.csv
                                labelVolume.json
                        TissueClassify
                            POSTERIOR_AIR.nii.gz
                            POSTERIOR_BASAL.nii.gz
                            POSTERIOR_CRBLGM.nii.gz
                            POSTERIOR_CRBLWM.nii.gz
                            POSTERIOR_CSF.nii.gz
                            POSTERIOR_GLOBUS.nii.gz
                            POSTERIOR_HIPPOCAMPUS.nii.gz
                            POSTERIOR_NOTCSF.nii.gz
                            POSTERIOR_NOTGM.nii.gz
                            POSTERIOR_NOTVB.nii.gz
                            POSTERIOR_NOTWM.nii.gz
                            POSTERIOR_SURFGM.nii.gz
                            POSTERIOR_THALAMUS.nii.gz
                            POSTERIOR_VB.nii.gz
                            POSTERIOR_WM.nii.gz
                            atlas_to_subject.h5
                            complete_brainlabels_seg.nii.gz
                            fixed_headlabels_seg.nii.gz
                            t1_average_BRAINSABC.nii.gz
                            t2_average_BRAINSABC.nii.gz
                        WarpedAtlas2Subject
                            hncma_atlas.nii.gz
                            l_accumben_ProbabilityMap.nii.gz
                            l_caudate_ProbabilityMap.nii.gz
                            l_globus_ProbabilityMap.nii.gz
                            l_hippocampus_ProbabilityMap.nii.gz
                            l_putamen_ProbabilityMap.nii.gz
                            l_thalamus_ProbabilityMap.nii.gz
                            left_hemisphere_wm.nii.gz
                            phi.nii.gz
                            r_accumben_ProbabilityMap.nii.gz
                            r_caudate_ProbabilityMap.nii.gz
                            r_globus_ProbabilityMap.nii.gz
                            r_hippocampus_ProbabilityMap.nii.gz
                            r_putamen_ProbabilityMap.nii.gz
                            r_thalamus_ProbabilityMap.nii.gz
                            rho.nii.gz
                            right_hemisphere_wm.nii.gz
                            template_WMPM2_labels.nii.gz
                            template_headregion.nii.gz
                            template_leftHemisphere.nii.gz
                            template_nac_labels.nii.gz
                            template_rightHemisphere.nii.gz
                            template_ventricles.nii.gz
                            theta.nii.gz
        |    ∟dwi/
        |    ∟fsurf/ (Freesurfer subject directory)
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

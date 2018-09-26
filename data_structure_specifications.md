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

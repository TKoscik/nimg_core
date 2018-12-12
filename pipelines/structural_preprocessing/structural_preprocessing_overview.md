# Structural Preprocessing Pipelines

Each structural preprocessing script/job should be initialized with a set of user-defined parameters as well as operator specifications to interface with the HPC scheduler.  
[Scripting Parameters](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/scripting_parameters.md)

**Follow links for descriptions, citations, and code snippets.**  
copies of citations can be found online [HERE](https://paperpile.com/shared/5aInqX)  

***

## T1 / T2 Pipeline:
[0. Scripting Parameters](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/scripting_parameters.md)  
[1. Gradient distortion unwarping [NOT IMPLEMENTED 2018-10-24]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/gradient_distortion_unwarping.md)  
[2. Readout distortion correction [NOT IMPLEMENTED 2018-10-24]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/readout_distortion_correction.md)  
[3. T1w - rigid alignment to template (retain native spacing)](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/rigid_alignment.md)  
[4. T1w - Denoising (Rician)](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/denoising.md)  
[5. Within-session, T2w coregistration to T1](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_session_multimodal_registration.md)  
[6. T2w - Denoising (Rician)](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/denoising.md)  
[7. T1w - within-modality average [if multiple images]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_modality_average.md)  
[8. T2w - within-modality average [if multiple images]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_modality_average.md)  
[9.1. Preliminary brain extraction - AFNI](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_AFNI.md)  
[9.2. Preliminary brain extraction - ANTs](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_ANTS.md)  
[9.3. Preliminary brain extraction - FSL BET](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_BET.md)  
[9.4. Preliminary brain extraction - MALF](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_MALF.md)  
10. __Preliminary Brain Extraction Quality Control__  
[11. Preliminary brain extraction - Selection]()  
[12. Bias field correction - T1/T2](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_T1T2.md)  
[13.1. T1w - Bias field correction - N4](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_N4.md)  
[13.2. T2w - Bias field correction - N4](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_N4.md)  
[14.1. Brain extraction - AFNI](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_AFNI.md)  
[14.2. Brain extraction - ANTs](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_ANTS.md)  
[14.3. Brain extraction - FSL BET](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_BET.md)  
[14.4. Brain extraction - MALF](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_MALF.md)  
15. __Brain Extraction Quality Control__  
[16. Brain extraction - Selection]()  
[17. Tissue segmentation](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/tissue_segmentation.md)  
[18. T1w - Apply Brain/Tissue Masks](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/apply_masks.md)  
[19. T2w - Apply Brain/Tissue Masks](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/apply_masks.md)  
[20. T1w - Normalization to template space](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/normalization_to_template_space.md)  
[21.1. Build transform stacks - T1w+rigid to Template]()  
[21.2. Build transform stacks - Template to T1w+rigid]()  
[21.3. Build transform stacks - T2w+raw to T1w+rigid]()  
[22.1. Apply transforms - processed T1w to Template]()  
[22.2. Apply transforms - processed T2w to Template]()  
[22.3. Apply transforms - Template Air Mask to T1w+rigid]()  
23. __Quality Control Report__  
  
## T1 Only Pipeline:
[1. Gradient distortion unwarping [NOT IMPLEMENTED 2018-10-24]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/gradient_distortion_unwarping.md)  
[2. Readout distortion correction [NOT IMPLEMENTED 2018-10-24]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/readout_distortion_correction.md)  
[3. Denoising (Rician)](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/denoising.md)  
[4. ACPC alignment](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/acpc_alignment.md)  
[5. Within-modality average [if multiple images]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_modality_average.md)  
[6. Preliminary brain extraction](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction.md)  
[7. Bias field correction - N4](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_N4.md) [[alternatively Iterative N4-segmentation]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_atroposN4.md)  
[8. Brain extraction](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction.md)  
[9. Tissue segmentation](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/tissue_segmentation.md)  
[10. Apply Brain/Tissue Masks](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/apply_masks.md)  
[11. Normalization to template space](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/normalization_to_template_space.md)  

## T1 + Other Anatomical Modalities Pipeline:
[1. Gradient distortion unwarping [NOT IMPLEMENTED 2018-10-24]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/gradient_distortion_unwarping.md)  
[2. Readout distortion correction [NOT IMPLEMENTED 2018-10-24]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/readout_distortion_correction.md)  
[3. Denoising (Rician)](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/denoising.md)  
[4. ACPC alignment](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/acpc_alignment.md)  
[5. Within-modality average [if multiple images]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_modality_average.md)  
[6. Within-session, multimodal coregistration to T1](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_session_multimodal_registration.md)  
[7. Preliminary brain extraction](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction.md)  
[8. Bias field correction - N4](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_N4.md)[[alternatively Iterative N4-segmentation]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_atroposN4.md)    
[9. Brain extraction](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction.md)  
[10. Tissue segmentation](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/tissue_segmentation.md)  
[11. Apply Brain/Tissue Masks](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/apply_masks.md)  
[12. Normalization to template space](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/normalization_to_template_space.md)  

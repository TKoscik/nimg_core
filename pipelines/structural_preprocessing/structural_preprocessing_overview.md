# Structural Preprocessing Pipelines

Each structural preprocessing script/job should be initialized with a set of user-defined parameters as well as operator specifications to interface with the HPC scheduler.  
[Scripting Parameters](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/scripting_parameters.md)

**Follow links for descriptions, citations, and code snippets.**  
copies of citations can be found online [HERE](https://paperpile.com/shared/5aInqX)  

***

## T1 / T2 Pipeline:
[1. Gradient distortion unwarping [NOT IMPLEMENTED 2018-10-24]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/gradient_distortion_unwarping.md)  
[2. Readout distortion correction [NOT IMPLEMENTED 2018-10-24]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/readout_distortion_correction.md)  
[3. Denoising (Rician)](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/denoising.md)  
[4. ACPC alignment](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/acpc_alignment.md)  
[5. Within-modality average [if multiple images]](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_modality_average.md)  
[6. Within-session, multimodal coregistration to T1](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_session_multimodal_registration.md)  
[7. Preliminary brain extraction](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction.md)  
[8. Bias field correction - T1/T2](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_T1T2.md)  
[9. Bias field correction - N4](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_N4.md)  
[10. Brain extraction](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction.md)  
[11. Tissue segmentation](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/tissue_segmentation.md)  
[12. Apply Brain/Tissue Masks](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/apply_masks.md)  
[13. Normalization to template space](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/normalization_to_template_space.md)  

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

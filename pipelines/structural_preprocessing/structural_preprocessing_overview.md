# Structural Preprocessing Pipeline

Each structural preprocessing script/job should be initialized with a set of user-defined parameters as well as operator specifications to interface with the HPC scheduler.  
[Scripting Parameters](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/scripting_parameters.md)

**Follow links for descriptions, citations, and code snippets.**  
copies of citations can be found online [HERE](https://paperpile.com/shared/5aInqX)  

***

### Structural Preprocessing Steps
0. Scripting Parameters [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/scripting_parameters.md)  
1. Gradient Distortion Unwarping [NOT IMPLEMENTED 2018-10-24] [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/gradient_distortion_unwarping.md)  
2. Readout Distortion Correction [NOT IMPLEMENTED 2018-10-24] [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/readout_distortion_correction.md)  
3. Rigid Alignment T1w to Template (retain native spacing) [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/rigid_alignment.md)  
4. Rician Denoising - T1w [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/denoising.md)  
5. Within-session Coregistration to T1w [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_session_multimodal_registration.md)  
   - T2w, OTHER modalities  
6. Rician Denoising [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/denoising.md)  
   - T2w, OTHER modalities    
7. Within-modality Average [if multiple images] [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/within_modality_average.md)  
   - T1w, T2w, OTHER modalities    
8. Brain extraction  
   - Use T1w and T2w as available.  
   1. AFNI [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_AFNI.md)  
   2. ANTS [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_ANTS.md)  
   3. BET [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_BET.md)  
   4. MALF [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_MALF.md)  
   5. __Brain Extraction Quality Control__ (omit in fully automated, non-problematic brain processing)    
   6. Brain Mask Selection [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/brain_extraction_selection.md)    
9. Bias Field Correction - T1/T2 [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_T1T2.md)  
   - Use if T1w AND T2w images are available.  
   - Apply field correction to OTHER modalities [untested]  
10. Bias Field Correction - N4 [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/bias_field_correction_N4.md)  
   - T1w, T2w    
11. __Brain extraction and QC, as needed__ (repeat brain extraction in fully automated script, omit if manual brain extraction is performed)  
12. Tissue segmentation [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/tissue_segmentation.md)  
   - Use T1w and T2w as available  
13. Apply Brain/Tissue Masks [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/apply_masks.md)  
   - T1w, T2w, OTHER modalities  
14. Normalization - T1w to Template [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/normalization_to_template_space.md)  
15. Build Transform Stacks [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/build_xfm_stack.md)  
   - T1w+rigid to Template  
   - Template to T1w+rigid  
   - T2w+raw to T1w+rigid  
   - OTHER+raw to T1w+rigid  
16. Apply Transforms [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/apply_xfm.md)  
   - processed T1w transform and resample to Template  
   - processed T2w transform and resample to Template  
   - processed OTHER transform and resample to Template    
   - Template Air Mask to T1w+rigid  
17. __Quality Control Report__  

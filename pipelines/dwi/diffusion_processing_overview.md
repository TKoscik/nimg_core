# Diffusion Processing Pipeline

Each diffusion processing script/job should be initialized with a set of user-defined parameters as well as operator specifications to interface with the HPC scheduler.  
[Scripting Parameters](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/scripting_parameters.md)

***

### Diffusion Processing Steps

0. Scripting Parameters [code](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/scripting_parameters.md)  
1. Fix odd dimensions (as necessary)  
2. Extract B0s  
3. Gather acquisition parameters (acquisition parameters [B0 and DWI], concatenated bvec and bval files, index)  
4. Concatenate B0 and DWI and parameter files (only concatenate within a single scan session & __only if acquisition__ spacing is identical)  
5. Topup
6. Get average B0
7. Calculate brain mask on topup-corrected, mean B0 - BET or ANTs
8. Eddy correction
9. Recalculate average B0
10. Register corrected, mean B0 to native space T2w
11. Apply transforms to DWI to both DWI-native space and normalized template space  
12. Calculate scalars for both spacings  






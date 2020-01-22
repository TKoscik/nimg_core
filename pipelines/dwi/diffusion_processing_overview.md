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
13. Convert to DSIstudio SRC file: dsi_studio --action=src --source=4d_image.nii --bval=bvals --bvec=bvals --output=1.src.gz
14. ??DSIstudio QC: dsi_studio --action=qc --source=directory_storing_src_files
15. DSIstudio reconstruction:  dsi_studio --action=rec --source=20081006_M025Y_1Shell.src.gz --mask=mask100.nii --method=4 --param0=1.25
16. DSIstudio Fiber Tracking:  
    a. 2 ROIs and wholBrain.nii: dsi_studio --action=trk --source=subject1.fib --seed=wholeBrain.nii --roi=my_roi1.nii --roi2=myroi2.nii --seed_count=5000 --fa_threshold=0.0241 --turning_angle=80 --step_size=.5 --smoothing=0.85 --min_length=20 --max_length=140 --output=track.txt  
    b. dsi_studio --action=trk --source=CMU_60_20130923build.fib.mean.fib.gz --fiber_count=1000000 --output=no_file --connectivity=FreeSurferDKT  
    c. Fibre tracking with output along track FA, stats and TDI: dsi_studio --action=trk --source=CMU_60_20130923build.fib.mean.fib.gz --fiber_count=1000000 --output=tracks.trk.gz --export=qa,dti_fa,stat,tdi  





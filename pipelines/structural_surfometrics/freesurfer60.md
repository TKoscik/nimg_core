# FreeSurfer 6.0 Pipeline

1. FreeSurfer 6.0 Information 
```
Everything one would need to know is at this wiki as far as FreeSurfer ins and outs and documetation, how-tos,
etc:
```

[freesurfer wiki](https://surfer.nmr.mgh.harvard.edu/fswiki)
```
We have found that FreeSurfer works best with Atropos N4 corrected inputs and the following scripts point at 
these in the bids structure.  This is particularly critical for samples with scans acquired on multiple 
scanners

```
2. Create argon submittable jobs scripts for running FreeSurfer and submit jobs
```
If you want to run the T1-T2 pipeline use the following script and template files:

Wrapper script for job creation (creates a separate pbs and sh script for each scan session found):
```
[create T1-T2 FS jobs](https://github.com/TKoscik/nimg_core/tools/createFSjobsT1T2.sh)
```
T1-T2 Template:
```
[T1-T2 FS Template](https://github.com/TKoscik/nimg_core/blob/master/tools/freesurfer/TMPLT1T2FSv60.sh.in)
```
If you want to run the T1 only pipeline use the following script and template files:

Wrapper script for job creation (creates a separate pbs and sh script for each scan session found):
```
[create T1 FS jobs](https://github.com/TKoscik/nimg_core/blob/master/tools/createFSjobsT1.sh)
```
T1-only Template:
```
[T1-only FS Template](https://github.com/TKoscik/nimg_core/tools/TMPLT1FSv60.sh.in)

```
3. FreeSurfer job status and troubleshooting
```
```
FreeSurfer jobs exit with one of two messages as below in the recon-all.log file and argon job
output file:

recon-all -s KIDSHD_v6_N4_121_62484516 finished without error at Thu May 31 13:24:47 CDT 2018
recon-all -s KIDSHD_v6_N4_335_63147515 exited with ERRORS at Wed Mar  7 10:49:58 CST 2018

Main error and get around is outlined here having to do with poor skull stripping:
copy brainmask.auto.mgz (name brainorig.mgz) from non N4 run
Load T1.mgz and brainorig.mgz
Otsu threshold brainorig.mgz 0 1 1
Multiply T1.mgz and thresholded brainorig.mgz interpolation 1
Save output as brainmask.nii.gz
mri_convert -i brainmask.nii.gz -it nii -o brainmask.auto.mgz -ot mgz
cp brainmask.auto.mgz brainmask.mgz
rm brainmask.nii.gz
run recon2 and recon3 

Other fixes one sometimes needs are the following:
Control points:
```
[freeview control points](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/ControlPoints_freeview)
[tksurfer control points](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/ControlPoints_tktools)
```
Pial edits:
```
[freeview pial edits](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/PialEdits_freeview)
[tksurfer pial edits](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/PialEdits_tktools)
```
4. Dataset creation in R via Tim's functions

Examples below of how to generate csv summary datasets for analysis is below
Launch RStudio
###Only 1st time###install.packages("devtools")
###Only 1st time### devtools::install_github("TKoscik/fsurfR")
library(fsurfR)

For global summary variables:
summary.fsurf(data.dir = "/Shared/nopoulos/freesurfer/KIDSHD_v6_2017/FreeSurfer_Subjects",save.dir = "~/",save.csv = TRUE, rois = "peg",file.name = "globalvars" )

For regional summary variables:
summary.fsurf(data.dir = "/Shared/nopoulos/freesurfer/KIDSHD_v6_2017/FreeSurfer_Subjects",save.dir = "~/",save.csv = TRUE, rois = "all",hemi = "t", file.name = "regionaltotals" )

```

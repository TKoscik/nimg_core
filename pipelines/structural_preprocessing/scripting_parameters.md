# Script Parameters
## ARGON HPC header
__ONLY THE HPC HEADER AND VARIABLE SPECIFICATION SHOULD usually BE EDITED__
```bash
#! /bin/bash
#$ -N ses-session_sub-subject_prep-anat
#$ -M email-address@for.log
#$ -m bes
#$ -q CCOM,PINC,UI
#$ -pe smp 56
#$ -j y
#$ -o /Shared/researcher/imaging_project/log/hpc_output
```
[HPC operators description](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_preprocessing/HPC_operators.md)

## Get timestamp for benchmarking
```bash
pipeline_start=$(date +"%Y-%m-%d_%H-%M-%S") # save time stamp of pipeline start
```

## Source directories and sourcefiles for software
```bash
#------------------------------------------------------------------------------
# set up software
#------------------------------------------------------------------------------
module load OpenBLAS
nimg_core_root=/Shared/nopoulos/nimg_core
source /Shared/pinc/sharedopt/apps/sourcefiles/afni_source.sh
afni_version=${AFNIDIR##*/}
source /Shared/pinc/sharedopt/apps/sourcefiles/ants_source.sh
ants_version=$(echo "${ANTSPATH}" | cut -d "/" -f9)
fsl_version=6.0.0_multicore
source /Shared/pinc/sharedopt/apps/sourcefiles/fsl_source.sh ${fsl_source}
```

## Specify variables
${researcher}/${project} must give you the root directory for all processing steps.  
__ONLY THE HPC HEADER AND VARIABLE SPECIFICATION SHOULD usually BE EDITED__
```bash
#------------------------------------------------------------------------------
# specify analysis variables
#------------------------------------------------------------------------------
researcher=/Shared/researcher
project=project_name
subject=123
session=12345abcde
site=00201
space=CIT168
template=700um

# Set file prefixes
t1_prefix=sub-${subject}_ses-${session}_site-${site}_acq-sagMPRAGEPROMO_T1w
t2_prefix=sub-${subject}_ses-${session}_site-${site}_acq-sagCUBEPROMO_T2w
prefix=sub-${subject}_ses-${session}_site-${site}
```

## Initial log entry
```bash
#------------------------------------------------------------------------------
# Initial log entry
#------------------------------------------------------------------------------
mkdir -p ${researcher}/${project}/log/hpc_output
subject_log=${researcher}/${project}/log/sub-${subject}_ses-${session}_site-${site}.log
echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task: structural_preprocessing_pipeline_T1T2' >> ${subject_log}
echo 'start_time: '${pipeline_start} >> ${subject_log}
echo '' >> ${subject_log}
```

## Initialize output folders
```bash
#------------------------------------------------------------------------------
# Initialize output folders
#------------------------------------------------------------------------------
dir_raw=${researcher}/${project}/nifti/sub-${subject}/ses-${session}/anat
dir_native=${researcher}/${project}/derivatives/anat/native
dir_mask=${researcher}/${project}/derivatives/anat/mask
dir_prep=${researcher}/${project}/derivatives/anat/prep/sub-${subject}/ses-${session} 
dir_xfm=${researcher}/${project}/derivatives/xfm/sub-${subject}/ses-${session} 
dir_template=${nimg_core_root}/templates
dir_norm=${researcher}/${project}/derivatives/anat/reg_${space}_${template}
dir_seg=${researcher}/${project}/derivatives/anat/segmentation 

mkdir -p ${dir_native}
mkdir -p ${dir_mask}
mkdir -p ${dir_prep}
mkdir -p ${dir_xfm}
mkdir -p ${dir_norm}
mkdir -p ${dir_seg}
```

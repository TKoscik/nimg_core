# Script Parameters
## ARGON HPC header
```bash
#! /bin/bash
#$ -N sub-subject_ses-session_prep-anat
#$ -M email-address@for.log
#$ -m bes
#$ -q CCOM,PINC,UI
#$ -pe smp 56
#$ -j y
#$ -o /Shared/researcher/imaging_project/log/hpc_output
```
| HPC Operator | Description |  
|---|---|  
| -N | job name, appended to output stream filename |  
| -M | email address for logging |  
| -m | email options |  
| -q | processing queue(s) |  
| -pe | number of slots, [see also -pe 56cpn 56 (full node)] |  
| -j | merge HPC error output into standard output stream |  
| -o | location to save output stream |  
| -e | location to save error stream |  
## Neuroimaging core root directory
```bash
nimg_core_root=/Shared/nopoulos/nimg_core
```
## Root directory for project
${researcher}/${project} must give you the root directory for all processing steps
```bash
researcher=/Shared/researcher
project=imaging_project
```
## Template Space
```bash
template_dir=${nimg_core}/templates
space=HCP                            # folder name for template space to use
template=MNI_T1_0.8mm                # which template space to use
```

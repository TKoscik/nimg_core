# BRAINSTools (BAW) Pipeline

#1. Create .csv database file for sample you want to run through BRAINSTools BAW  
Use this script to find all your T1s and T2s and make the desired csv file:  

  [csv creator](https://github.com/TKoscik/nimg_core/blob/master/tools/baw/BRAINSTools_csvcreator.sh)

#2. Create a config file for the projcect you want to run through BRAINSTools BAW   
Create a config file using this file as your template and edit the lines described in the header:  

  [config file](https://github.com/TKoscik/nimg_core/blob/master/tools/bawBRAINSTools.config)

#3. Login to argon and start your BRAINSTools processing  
You will need the csv file from Step 1, the config file from Step 2, and the following runbaw.sh file:  

  [run script](https://github.com/TKoscik/nimg_core/blob/master/tools/baw/runbaw.sh)  

To start BRAINSTools processing in argon you need to do the following commands  
(described in config header as well):  
```
export PATH=/Shared/pinc/sharedopt/apps/anaconda3/Linux/x86_64/4.3.0/bin:$PATH
bash runbaw.sh -p 1 -s all -r <SGEGraph|SGE> -c <YOURCONFIGFILE>.config
```
Notes on SGE vs SGEGraph: SGE runs each job node of pipeline in serial while SGEGraph farms out all the jobs at 
once and then waits for each dependency to resolve before running next job  

#4. Troubleshooting failures  
Failure cases and workarounds can be found here:  

  [wiki](https://github.com/BRAINSia/BRAINSTools/wiki) 

#5. Dataset creation in R via Tim's functions  
Example below of how to generate csv summary datasets for analysis is below  
```
devtools::install_github("TKoscik/tkmisc")
library(tkmisc)
library(nifti.io)
library(R.utils)

bt_summarizer(data.dir = "/Shared/nopoulos/BRAINSTools_Experiments/20160525_BAW_JointFusion/20160525_Kids_base_Results/KIDSHD",
              scratch="/Shared/nopoulos/BRAINSTools_Experiments/20160525_BAW_JointFusion/data/scratch",
              label.csv="/Shared/nopoulos/kidsHD_btSummaries/brainstools-summary-labels.csv",
              save.dir="/nopoulos/BRAINSTools_Experiments/20160525_BAW_JointFusion/data",
              file.name="KIDSHD_BrainsTools_Summary_20180905.csv")
```

#6. Miscellaneous BAW info  
BRAINSTools build we currently use:  
/Shared/pinc/sharedopt/20170302/RHEL7/NEP-intel  

Word document with all the details of BAW:
  
  [BAW Word Doc](https://github.com/TKoscik/nimg_core/blob/master/pipelines/structural_volumetrics/BRAINSAutoWorkupOutputDescriptions.docx)



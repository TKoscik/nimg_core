# Create group 4D files for each condition (Siemens only, Siemens & GE)
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟?
```
## Code:
```


#Create group 4D files for each condition (Siemens only, Siemens & GE)
  #Have to first create dummy text files

for sub in `cat $groupdir/T1rho/NC_DM1_SiemensGE_list`;
do
ursi=`echo $sub | awk -F"/" '{print $1}'`
mrqid=`echo $sub | awk -F"/" '{print $2}'`
echo "${ursi}/${mrqid}"
echo $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_groupTemplate_s2j.nii.gz >> $groupdir/T1rho/tmpNC_DM1_SiemensGE_list
done

for sub in `cat $groupdir/T1rho/NC_DM1_Siemens_list`;
do
ursi=`echo $sub | awk -F"/" '{print $1}'`
mrqid=`echo $sub | awk -F"/" '{print $2}'`
echo "${ursi}/${mrqid}"
echo $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_groupTemplate_s2j.nii.gz >> $groupdir/T1rho/tmpNC_DM1_Siemens_list
done

#Create 4D files using smooth(2) Jacobian T1rho
fslmerge -t $groupdir/T1rho/SiemensGEgroup4D `cat $groupdir/T1rho/tmpNC_DM1_SiemensGE_list`
fslmerge -t $groupdir/T1rho/Siemensgroup4D `cat $groupdir/T1rho/tmpNC_DM1_Siemens_list`

#Run 5000 iterations of randomise (start with Siemens only)
indir=/Shared/nopoulos/structural/DM1_MR
outdir=/Shared/nopoulos/T1rho/scripts_2017
groupdir=/Shared/nopoulos/biasComp
templatedir=/Shared/nopoulos/biasComp/groupTemplate
designdir=/Shared/nopoulos/biasComp/T1rho/GroupDesignFiles


  #Siemens only
mkdir $groupdir/T1rho/Jac_Stats_Siemens
randomise -i $groupdir/T1rho/Siemensgroup4D -o $groupdir/T1rho/Jac_Stats_Siemens/twoSampT -d $designdir/Siemens_cov.mat -t $designdir/Siemens_cov.con -m /Shared/nopoulos/biasComp/groupTemplate/DM1_NC_groupTemplate_mask.nii.gz -T -D -n 5000 -x --twopass

#2.44663e+11 permutations required for exhaustive test of t-test 1



  #For now, removed the "-x" option (I think I can create corrected p downstream (see what I did with Aaron for rsfMRI)


#No matter what, always fails on permutation 742
  #Try different version of FSL?
  #Watched system monitor, RAM never went above ~8 GB (of 16 total)


export FSLDIR=/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.10
export FSL_DIR=/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.10
export PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH
. ${FSLDIR}/etc/fslconf/fsl.sh
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${FSLDIR}/lib

#Rerunning again, using this version of FSL, also re-incorporating "-x"

/Shared/pinc/sharedopt/apps/ants/Linux/x86_64/2.1.0/antsRegistration \
--dimensionality 3 --float 0 --output \
\[/nopoulos/structural/DM1_MR/961/62946218/T1rho/tmpFiles/TSL10_to_TSL50_,/nopoulos/structural/DM1_MR/961/62946218/T1rho/tmpFiles/TSL10_to_TSL50_Warped.nii.gz\] \
 --interpolation Linear --winsorize-image-intensities 0 --use-histogram-matching 0 \
 --initial-moving-transform \[/nopoulos/structural/DM1_MR/961/62946218/T1rho/tmpFiles/TSL50_brain.nii.gz,/nopoulos/structural/DM1_MR/961/62946218/T1rho/tmpFiles/TSL10_brain.nii.gz,1\] \
 --transform Rigid\[0.1\] --metric \
 Mattes\[/nopoulos/structural/DM1_MR/961/62946218/T1rho/tmpFiles/TSL50_brain.nii.gz,/nopoulos/structural/DM1_MR/961/62946218/T1rho/tmpFiles/TSL10_brain.nii.gz,1,32,Regular,0.25\] \
 --convergence \[1000x500x250x100,1e-6,10\] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox
```




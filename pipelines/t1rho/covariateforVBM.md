# For VBM-like analysis where subs are pushed to template space and multiplied by Jacobian, need covariates
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟Jacobian.nii.gz
```
## Code:
```


#
  #Created a temp file of all subs, will pull out relevent info: /Shared/nopoulos/biasComp/tmpcov.csv

for sub in `cat $outdir/DM1_NC_haveT1rho`;
do
ursi=`echo $sub | awk -F"/" '{print $1}'`
mrqid=`echo $sub | awk -F"/" '{print $2}'`
cat /Shared/nopoulos/biasComp/tmpcov.csv | grep ",${ursi},${mrqid}," >> $outdir/DM1_T1rho_covariates.csv
done

  #Manually added in header line, saved as Excel, removed .csv

 #24 NC, 27 DM1
 #41 Siemens, 10 GE
  #19 Siemens NC, 5 GE NC
   #9 Siemens NC Male, 10 Siemens NC Female
   #4 GE NC Male, 1 GE NC Female
  #22 Siemens DM1, 5 GE DM1
   #7 Siemens DM1 Male, 15 Siemens DM1 Female
   #1 GE DM1 Male, 4 GE DM1 Female

 

#Create a 4D, one set with Siemens & GE, one set Siemens only
#Create binary mask of T1rho, pushed to template
  #Overlap binaries, see coverage
  #Threshold by max overlap/coverage

#Will need to invert T1rho down to raw T1 space
i=2
while [[ $i -le 52 ]];
do
ursi=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $1}'`
mrqid=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $2}'`
mkdir /Shared/nopoulos/biasComp/$ursi/$mrqid/T1rho
echo "${i}/52,${ursi}/${mrqid}"
echo '#!/bin/bash' >> $outdir/temp${i}.sh
pushd $indir/$ursi/$mrqid > /dev/null
if [[ -d 10_AUTO.v020 ]]; then
b2dir=10_AUTO.v020
else
b2dir=10_AUTO.v020GE
fi
pushd $indir/$ursi/$mrqid/T1rho > /dev/null
echo "b2 load Image $indir/$ursi/$mrqid/T1rho/T1rhoMap.nii.gz data-type= Float-single" > tmp.tcl
echo "b2 load Transform $indir/$ursi/$mrqid/$b2dir/${mrqid}_T1.xfrm" >> tmp.tcl
echo "b2 invert affine-transform tx1" >> tmp.tcl
echo "b2 set transform tx2 image i1" >> tmp.tcl
echo "b2 save image $indir/$ursi/$mrqid/T1rho/T1rhoMap_raw.nii.gz nifti i1 data-type= Float-single plane= coronal" >> tmp.tcl
brains2 -b tmp.tcl
rm tmp.tcl
popd > /dev/null
popd > /dev/null
let i=i+1
done





#First, push all T1rho data to groupTemplate space
  #For now, like VBM, smoothing the T1rho data slightly, then multiplying by the Jacobian

indir=/Shared/nopoulos/structural/DM1_MR
outdir=/Shared/nopoulos/T1rho/scripts_2017
groupdir=/Shared/nopoulos/biasComp
templatedir=/Shared/nopoulos/biasComp/groupTemplate

i=2
while [[ $i -le 52 ]];
do
ursi=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $1}'`
mrqid=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $2}'`
mkdir /Shared/nopoulos/biasComp/$ursi/$mrqid/T1rho
echo "${i}/52,${ursi}/${mrqid}"
echo '#!/bin/bash' >> $outdir/temp${i}.sh
echo "" >> $outdir/temp${i}.sh
echo 'PATH=/Shared/pinc/sharedopt/apps/ants/Linux/x86_64/2.1.0:${PATH}' >> $outdir/temp${i}.sh
echo 'export PATH' >> $outdir/temp${i}.sh
echo 'export ANTSPATH=/Shared/pinc/sharedopt/apps/ants/Linux/x86_64/2.1.0' >> $outdir/temp${i}.sh
echo 'export PATH=/Shared/pinc/sharedopt/apps/T1rho/Linux/x86_64/2017_09_05/bin:$PATH' >> $outdir/temp${i}.sh
echo 'export PATH=/Shared/pinc/sharedopt/apps/afni/Linux/x86_64/17.2.07:$PATH' >> $outdir/temp${i}.sh
echo 'export FSLDIR=/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.9' >> $outdir/temp${i}.sh
echo 'export FSL_DIR=/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.9' >> $outdir/temp${i}.sh
echo 'export PATH=${FSLDIR}/bin:${PATH}' >> $outdir/temp${i}.sh
echo 'export FSLDIR PATH' >> $outdir/temp${i}.sh
echo '. ${FSLDIR}/etc/fslconf/fsl.sh' >> $outdir/temp${i}.sh
echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${FSLDIR}/lib' >> $outdir/temp${i}.sh
echo "" >> $outdir/temp${i}.sh
echo "$ANTSPATH/antsApplyTransforms -d 3 -i $indir/$ursi/$mrqid/T1rho/T1rhoMap_raw.nii.gz -r $templatedir/DM1_NC_groupTemplate_template.nii.gz -o $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_groupTemplate.nii.gz  -n Linear -t $templatedir/DM1_NC_groupTemplate_${ursi}_${mrqid}_T1_brainWarp.nii.gz -t $templatedir/DM1_NC_groupTemplate_${ursi}_${mrqid}_T1_brainAffine.txt" >> $outdir/temp${i}.sh
echo "/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.9/bin/fslmaths $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_groupTemplate.nii.gz -bin $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_mask.nii.gz -odt char" >> $outdir/temp${i}.sh
echo "$ANTSPATH/SmoothImage 3 $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_groupTemplate.nii.gz 2 $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_groupTemplate_s2.nii.gz" >> $outdir/temp${i}.sh
echo "$ANTSPATH/ImageMath 3 $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_groupTemplate_s2j.nii.gz m $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_groupTemplate_s2.nii.gz $groupdir/$ursi/$mrqid/Jacobian.nii.gz" >> $outdir/temp${i}.sh
chmod +x $outdir/temp${i}.sh
let i=i+1
done

#Run on cluster
ssh -x brussj@argon.hpc.uiowa.edu
cd /Shared/nopoulos/T1rho/scripts_2017

i=1
while [[ $i -le 52 ]];
do
qsub -q PINC,CCOM -pe smp 8 temp${i}.sh
let i=i+1
done
```



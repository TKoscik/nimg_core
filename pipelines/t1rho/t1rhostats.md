# Generate Stats
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟statsdir (?)
```
## Code:
```


#####################

#Make an output directory for T1rho stats
mkdir $groupdir/T1rho

#Create group overlap masks (all subs, Siemens only)




i=2
while [[ $i -le 52 ]];
do
sub=`cat $outdir/DM1_T1rho_covariates_temp.csv | head -n+${i} | tail -n-1`
ursi=`echo $sub | awk -F"," '{print $1}'`
mrqid=`echo $sub | awk -F"," '{print $2}'`
scanner=`echo $sub | awk -F"," '{print $4}'`
if [[ $i -eq 2 ]]; then
fslmaths $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_mask.nii.gz -bin $groupdir/T1rho/groupSiemensOverlap.nii.gz -odt float
fslmaths $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_mask.nii.gz -bin $groupdir/T1rho/groupSiemensGEOverlap.nii.gz -odt float
else
if [[ $scanner -ne 2 ]]; then
fslmaths $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_mask.nii.gz -bin -add $groupdir/T1rho/groupSiemensOverlap.nii.gz $groupdir/T1rho/groupSiemensOverlap.nii.gz -odt float
fslmaths $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_mask.nii.gz -bin -add $groupdir/T1rho/groupSiemensGEOverlap.nii.gz $groupdir/T1rho/groupSiemensGEOverlap.nii.gz -odt float
else
fslmaths $groupdir/$ursi/$mrqid/T1rho/T1rhoMap_mask.nii.gz -bin -add $groupdir/T1rho/groupSiemensGEOverlap.nii.gz $groupdir/T1rho/groupSiemensGEOverlap.nii.gz -odt float
fi
fi
let i=i+1
done

fslstats $groupdir/T1rho/groupSiemensOverlap.nii.gz -R
fslstats $groupdir/T1rho/groupSiemensGEOverlap.nii.gz -R
```

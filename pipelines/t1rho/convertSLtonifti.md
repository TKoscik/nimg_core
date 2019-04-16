# Convert spin lock files to nifti
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟TSL${lowspintime}.nii.gz
  ∟TSL${highspintime}.nii.gz

```
## Code:
```
indir=/nopoulos/structural/Trio_MR
outdir=/nopoulos/T1rho/scripts_2017
#Convert the SL files to NIfTI
  #Should end up with one SL0, one SL90


#Header on line1, starting on line 2
  #Lines go in groups of 4
    #1 = Path to T1
    #2 = low spin-lock
    #3 = high spin-lock
    #4 = blank line

echo "ursi,mrqid,lowSpinTime,highSpinTime" > $outdir/spinLockTimes_DM1.csv
export FSLDIR=/opt/fsl
. ${FSLDIR}/etc/fslconf/fsl.sh
export PATH=${PATH}:/Shared/pinc/sharedopt/apps/MRIConvert/Linux/x86_64/2.1.0/bin
export PATH=${PATH}:/Shared/pinc/sharedopt/apps/freesurfer/Linux/x86_64/6.0.0/bin
export FREESURFER_HOME=/Shared/pinc/sharedopt/apps/freesurfer/Linux/x86_64/6.0.0
source $FREESURFER_HOME/SetUpFreeSurfer.sh

DM1_info=$outdir/DM1_NC_T1rho_subList.csv
echo -n "" > $outdir/spinLockTimes_DM1.csv
for IDs in `awk -F, 'NR>1{print $1"/"$2}' $DM1_info | sort -u` ; do
   cd $outdir
   echo $IDs
   ursi=${IDs%%/*}
   mrqid=${IDs##*/}
   Dirs=(`awk -F, 'BEGIN{N=0}\
         $2=="'$mrqid'"{N++; print $3; scanner=$4;\
         if(N==2){LowSpin=$5}; if(N==3){HighSpin=$5}}\
         END{print toupper(scanner),LowSpin,HighSpin}' $DM1_info `)
   echo ${Dirs[@]}
   [ ${#Dirs[@]} -ne 6 ] && continue
   rhoDir=$indir/$ursi/$mrqid/T1rho
   if [[ ! -d $rhoDir ]]; then
      mkdir $rhoDir
   fi
   t1dir=${Dirs[0]}
   lowspindir=${Dirs[1]}
   highspindir=${Dirs[2]}
   #set the scanner type, based of lowspin file
   tmpScanner=${Dirs[3]}
   if [[ ! -z `echo $tmpScanner | grep "GE"` ]]; then
      scannerType=GE
   else
      scannerType=SIEMENS
   fi
   #Grep will grab the "1" from T1rho, need to exclude that and grab the true spin-lock time
   lowspintime=`echo ${Dirs[4]} | grep -Eo '[0-9]{2,}'`
   highspintime=`echo ${Dirs[5]} | grep -Eo '[0-9]{2,}'`
   #Log the spin-lock times
   echo "${ursi},${mrqid},${lowspintime},${highspintime}" >> $outdir/spinLockTimes_DM1.csv
   #Copy over T1, T2

   echo "...copying over T1, T2 data"
   [ ! -e $rhoDir/T1.nii.gz ] && cp $t1dir/${mrqid}_T1.nii.gz $rhoDir/T1.nii.gz
   [ ! -e $rhoDir/T2.nii.gz ] && cp $t1dir/${mrqid}_T2.nii.gz $rhoDir/T2.nii.gz
   #Check for T1mask.  Create if needed, copy over, skull-strip T1 and T2.  
   #Make geometry of T1mask the same as input T1
   cd $t1dir
   [ $? -eq 1 ] && continue
   if [[ ! -e T1mask.nii.gz ]]; then
      $outdir/brains2Mask.sh $ursi $mrqid $t1dir
      #####$outdir/toRIP.sh -i $t1dir/T1mask.nii.gz
   fi
   ## Need a mask to continue
   [ ! -e T1mask.nii.gz ] && continue
   if [ ! -e $rhoDir/T1mask.nii.gz ] ; then
      fslcpgeom $t1dir/${mrqid}_T1.nii.gz $t1dir/T1mask.nii.gz
      cp T1mask.nii.gz $rhoDir/T1mask.nii.gz
   fi
   cd $rhoDir
   [ $? -eq 1 ] && continue
   [ ! -e $rhoDir/T1_brain.nii.gz ] && fslmaths T1.nii.gz -mas T1mask.nii.gz T1_brain.nii.gz
   [ ! -e $rhoDir/T2_brain.nii.gz ] && fslmaths T2.nii.gz -mas T1mask.nii.gz T2_brain.nii.gz
   
   #Convert spin-lock files to NIfTI
     #low spin-lock time
   cd $indir/$ursi/$mrqid/$lowspindir
   [ $? -eq 1 ] && continue
   echo "...Converting low-spin file"
   dcmPic=`ls -1tv *dcm | head -n+1`
   if [ ! -e $rhoDir/TSL${lowspintime}.nii.gz ] ; then
      if [[ $scannerType == "GE" ]]; then
         mri_convert --in_type dicom --out_type nii $dcmPic $rhoDir/TSL${lowspintime}.nii.gz
      else
         mri_convert --in_type siemens_dicom --out_type nii $dcmPic $rhoDir/TSL${lowspintime}.nii.gz
      fi
   fi
   
     #high spin-lock time
   cd $indir/$ursi/$mrqid/$highspindir
   [ $? -eq 1 ] && continue
   echo "...Converting high-spin file"
   dcmPic=`ls -1tv *dcm | head -n+1`
   if [ ! -e $rhoDir/TSL${highspintime}.nii.gz ] ; then
      if [[ $scannerType == "GE" ]]; then
         mri_convert --in_type dicom --out_type nii $dcmPic $rhoDir/TSL${highspintime}.nii.gz
      else
         mri_convert --in_type siemens_dicom --out_type nii $dcmPic $rhoDir/TSL${highspintime}.nii.gz
      fi
   fi
```


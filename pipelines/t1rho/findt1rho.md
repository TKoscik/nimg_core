# Find T1rho scans and Determine Scanner
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟t1rho_sublist.csv
```
## Code:
```indir=/nopoulos/structural/DM1_MR
outdir=/nopoulos/T1Rho/scripts_2019
echo "URSI,MRQID,scandir,scanner,scantype" > $outdir/DM1_NC_T1rho_subList.csv

cd $indir

#Look for 3-digit URSI
#for sub in `cat $outdir/DM1_NCStartList`; do
for sub in [0-9][0-9][0-9]/6* ; do
   ids=(${sub/\// })
   ursi=${ids[0]}
   mrqid=${ids[1]}
   echo "searching ${ursi}/${mrqid} for proper DICOM"
   pushd $indir/$ursi/$mrqid > /dev/null
   # Look for brains2 directory
   if [[ -d 10_AUTO.v020 || -d 10_AUTO.v020GE ]]; then
      if [[ -d 10_AUTO.v020 ]]; then
         b2dir=$indir/$ursi/$mrqid/10_AUTO.v020
         b2scanner=SIEMENS
      else
         b2dir=$indir/$ursi/$mrqid/10_AUTO.v020GE
         b2scanner=GE
      fi
   else
      b2dir=x
      b2scanner=x
   fi
   #Log T1 (use "x" if brains2 missing)
   if [[ $b2dir == "x" ]]; then
      echo "${ursi},${mrqid},x,x,T1" >> $outdir/tmp.csv
   else
      echo "${ursi},${mrqid},${b2dir},${b2scanner},T1" >> $outdir/tmp.csv
   fi
   #Find DICOM data, log
   for subdir in `ls -F1 | grep "/" | awk -F"/" '{print $1}'`; do
      pushd $subdir > /dev/null
      count=`ls -1 *.dcm 2>/dev/null | wc -l`
      if [[ $count != 0 ]]; then 
         dcmPic=`ls -1tv *dcm | head -n+1`
         dcmScanner=`dicom_hdr $dcmPic | grep "ID Manufacturer/" | awk -F "/" '{print $NF}' | awk '{$1=$1};1' | tr ' ' '_'`
         dcmSeries=`dicom_hdr $dcmPic | grep "0008 103e" | awk -F "/" '{print $5}' | awk '{$1=$1};1' | tr ' ' '_'`
         echo "${ursi},${mrqid},${subdir},${dcmScanner},${dcmSeries}" >> $outdir/tmp2.csv
      fi
      popd > /dev/null
   done
   #Search for T1rho string(s).  If found, look for Spin-lock ("SL"), then copy that and T1 data over.  Otherwise, delete it and move on.
   #if [[ `cat $outdir/tmp2.csv | grep -E "T1rho|t1rho" | grep -E "SL|sl"` != "" ]]; then
     #Grep with a case insensitive search, "RHO" vs. "rho", etc.; now ignoring "TSL/SL/ms" (for now)
   if [[ `cat $outdir/tmp2.csv | grep -i "rho"` != "" ]]; then
      cat $outdir/tmp.csv >> $outdir/DM1_NC_T1rho_subList.csv
      #cat $outdir/tmp2.csv | grep -E "T1rho|t1rho" | grep -E "SL|sl" >> $outdir/DM1_NC_T1rho_subList.csv
      #cat $outdir/tmp2.csv | grep -i "rho" >> $outdir/DM1_NC_T1rho_subList.csv
      #Now going to sort by spinlock time
      cat $outdir/tmp2.csv | grep -i "rho" | sort -t"," -k5 >> $outdir/DM1_NC_T1rho_subList.csv
      rm $outdir/tmp.csv $outdir/tmp2.csv
      echo "" >> $outdir/DM1_NC_T1rho_subList.csv
   else
      rm $outdir/tmp.csv $outdir/tmp2.csv
   fi
   popd > /dev/null
done
#   popd > /dev/null
#done

## Fast Method
time awk -F"," '(NR-2)%4==0{print $1"/"$2}' $outdir/DM1_NC_T1rho_subList.csv > $outdir/DM1_NC_haveT1rhoZ
## Slow method
#Truncate list to just IDs
pushd $outdir > /dev/null
sublength=`cat $outdir/DM1_NC_T1rho_subList.csv | wc -l`
i=2
echo -n "" > $outdir/DM1_NC_haveT1rho
time while [[ $i -le $sublength ]]; do
   ursi=`cat DM1_NC_T1rho_subList.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $1}'`
   mrqid=`cat DM1_NC_T1rho_subList.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $2}'`
   echo "${ursi}/${mrqid}" >> $outdir/DM1_NC_haveT1rho
   let i=i+4
done
popd > /dev/null
  #51 subs


#Figure out who is missing
  #Have to sort both lists first (Remove when done)
cat $outdir/DM1_NCStartList | sort -t',' -k1 > list1
cat $outdir/DM1_NC_haveT1rho | sort -t',' -k1 > list2
comm -23 list1 list2 > $outdir/DM1_NC_missingT1rho

rm list1 list2

  #Of 63 inputs, 51 have T1rho
    #10 GE, 41 Siemens

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

   # break  ## Uncomment to run once
done |& tee DM1proc.log


#Check directory for all data
i=2
while [[ $i -le $listcount ]]; do
   echo "${i},${j},${k}"
   tmpdata=`cat $outdir/DM1_NC_T1rho_subList.csv | head -n+${i} | tail -n-1`
   ursi=`echo $tmpdata | awk -F"," '{print $1}'`
   mrqid=`echo $tmpdata | awk -F"," '{print $2}'`
   rhoDir=$indir/$ursi/$mrqid/T1rho
   pushd $rhoDir > /dev/null
   echo "${ursi}/${mrqid}"
   ls -1
   echo ""
   popd $rhoDir > /dev/null
   let i=i+4
done
  #Looks OK now



###################################################
# Need to reorient all T1rho spin-lock data to "RIP"
export PATH=/Shared/pinc/sharedopt/apps/ants/Linux/x86_64/2.1.0:${PATH}
List=$outdir/spinLockTimes_DM1.csv
for Info in `cat $List` ; do
   info=(${Info//,/ })  ## ursi mrqid lowspin highspin
   echo ${info[0]} ${info[1]}
   rhoDir=$indir/${info[0]}/${info[1]}/T1rho
   $outdir/toRIP.sh -i $rhoDir/TSL${info[2]}.nii.gz
   $outdir/toRIP.sh -i $rhoDir/TSL${info[3]}.nii.gz
done | tee $outdir/DM1_RIP.log
#### Skip old \/ \/
listcount=`cat $outdir/spinLockTimes_DM1.csv | wc -l`

i=2
while [[ $i -le $listcount ]];
do
ursi=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $1}'`
mrqid=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $2}'`
spinlow=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $3}'`
spinhigh=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $4}'`
echo "${ursi}/${mrqid}"
rhoDir=$indir/$ursi/$mrqid/T1rho
$outdir/toRIP.sh -i $rhoDir/TSL${spinlow}.nii.gz
$outdir/toRIP.sh -i $rhoDir/TSL${spinhigh}.nii.gz
let i=i+1
done

#############################################
# Run on local hardware
sg Research-nopouloslab bash
export PATH=/Shared/pinc/sharedopt/apps/ants/Linux/x86_64/2.1.0:${PATH}
export ANTSPATH=/Shared/pinc/sharedopt/apps/ants/Linux/x86_64/2.1.0
export PATH=/Shared/pinc/sharedopt/apps/T1rho/Linux/x86_64/2017_09_05/bin:$PATH
export PATH=/Shared/pinc/sharedopt/apps/afni/Linux/x86_64/17.2.07:$PATH
export FSLDIR=/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.10
export FSL_DIR=/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.10
export PATH=${FSLDIR}/bin:${PATH}
export FSLDIR PATH
. ${FSLDIR}/etc/fslconf/fsl.sh
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${FSLDIR}/lib
indir=/nopoulos/structural/DM1_MR
outdir=/nopoulos/T1Rho/scripts_2019
List=$outdir/spinLockTimes_DM1.csv
for Info in `cat $List` ; do
   info=(${Info//,/ })  ## ursi mrqid lowspin highspin
   echo `date +%H:%M:%S` ${info[0]} ${info[1]}
   rhoDir=$indir/${info[0]}/${info[1]}/T1rho
   LogFile=$outdir/ProcLogs/${info[0]}_${info[1]}.log
   [ ! -e $rhoDir/T2_brain.nii.gz ]      && echo No T2_brain && continue
   [ ! -e $rhoDir/TSL${info[2]}.nii.gz ] && echo No TSL${info[2]} && continue
   [ ! -e $rhoDir/TSL${info[3]}.nii.gz ] && echo No TSL${info[3]} && continue
   [ -e $rhoDir/T1rhoMap.nii.gz ]        && echo Done already. && continue
   [ -e $LogFile ]                       && continue
   date +"start_time:+%Y-%m-%dT%H:%M:%S%z" > $LogFile
   sleep 5
   $outdir/T1rhoProcess.sh -a $rhoDir/T2_brain.nii.gz \
      -t $rhoDir/TSL${info[2]}.nii.gz -s ${info[2]} \
      -t $rhoDir/TSL${info[3]}.nii.gz -s ${info[3]} \
      -i -o $rhoDir |& tee -a $LogFile > /dev/null
   #break
done

#############################################
#set up batch sripts (51), feed to Argon
indir=/Shared/nopoulos/structural/DM1_MR
outdir=/Shared/nopoulos/T1rho/scripts_2017

listcount=`cat $outdir/spinLockTimes_DM1.csv | wc -l`

i=2
while [[ $i -le $listcount ]];
do
ursi=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $1}'`
mrqid=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $2}'`
spinlow=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $3}'`
spinhigh=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $4}'`
echo "${ursi}/${mrqid}"
rhoDir=$indir/$ursi/$mrqid/T1rho
echo '#!/bin/bash' >> $outdir/temp${i}.sh
echo "" >> $outdir/temp${i}.sh
echo 'PATH=/Shared/pinc/sharedopt/apps/ants/Linux/x86_64/2.1.0:${PATH}' >> $outdir/temp${i}.sh
echo 'export PATH' >> $outdir/temp${i}.sh
echo 'export ANTSPATH=/Shared/pinc/sharedopt/apps/ants/Linux/x86_64/2.1.0' >> $outdir/temp${i}.sh
echo 'export PATH=/Shared/pinc/sharedopt/apps/T1rho/Linux/x86_64/2017_09_05/bin:$PATH' >> $outdir/temp${i}.sh
echo 'export PATH=/Shared/pinc/sharedopt/apps/afni/Linux/x86_64/17.2.07:$PATH' >> $outdir/temp${i}.sh
echo 'export FSLDIR=/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.10' >> $outdir/temp${i}.sh
echo 'export FSL_DIR=/Shared/pinc/sharedopt/apps/fsl/Linux/x86_64/5.0.10' >> $outdir/temp${i}.sh
echo 'export PATH=${FSLDIR}/bin:${PATH}' >> $outdir/temp${i}.sh
echo 'export FSLDIR PATH' >> $outdir/temp${i}.sh
echo '. ${FSLDIR}/etc/fslconf/fsl.sh' >> $outdir/temp${i}.sh
echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${FSLDIR}/lib' >> $outdir/temp${i}.sh
echo "" >> $outdir/temp${i}.sh
echo "$outdir/T1rhoProcess.sh -a $rhoDir/T2_brain.nii.gz -t $rhoDir/TSL${spinlow}.nii.gz -s ${spinlow} -t $rhoDir/TSL${spinhigh}.nii.gz -s ${spinhigh} -i -o $rhoDir" >> $outdir/temp${i}.sh
chmod +x $outdir/temp${i}.sh
let i=i+1
done


#On Argon

ssh -x brussj@argon.hpc.uiowa.edu
cd /Shared/nopoulos/T1rho/scripts_2017

i=2
while [[ $i -le 52 ]];
do
qsub -q PINC -pe smp 8 temp${i}.sh
let i=i+1
done


################################################################################################

########START HERE###################


#Check the output


  #Mark GE subs with terrilbe ringing artifact (more than just front of brain) 
  # -- will need to ignore these
  #Create a template of just GE scans, warp binary T1rhoMap as a mask, 
  #then make a probability mask to show where there is actual coverage
indir=/nopoulos/structural/DM1_MR
outdir=/nopoulos/T1Rho/scripts_2019 ; cd $outdir
List=$outdir/spinLockTimes_DM1.csv
View=0
for Info in `cat $List` ; do
   info=(${Info//,/ })  ## ursi mrqid lowspin highspin
   [[ "65235517" == "${info[1]}" ]] && View=1
   [[ $View == 0 ]] && continue
   echo `date +%H:%M:%S` ${info[0]} ${info[1]}
   rhoDir=$indir/${info[0]}/${info[1]}/T1rho
   ( cd $rhoDir ; afni -no_detach T2.nii.gz T1.nii.gz T1rhoMap.nii.gz T1mask.nii.gz \
     tmpFiles/TSL[56]0_to_T2_brain_Warped.nii.gz tmpFiles/TSL*to_T2_brain_LWS.nii.gz ) >& /dev/null
   sleep 1
done
for rhoDir in /nopoulos/structural/DM1_MR/122/60366018 \
/nopoulos/structural/DM1_MR/188/63495017 \
/nopoulos/structural/DM1_MR/310/62050017 \
/nopoulos/structural/DM1_MR/319/60120018 ; do
   ( cd $rhoDir/T1rho ; afni -no_detach T2.nii.gz T1.nii.gz T1rhoMap.nii.gz T1mask.nii.gz \
     tmpFiles/TSL[56]0_to_T2_brain_Warped.nii.gz tmpFiles/TSL*to_T2_brain_LWS.nii.gz ) >& /dev/null
   sleep 1
done


                 # fsleyes?
   ( cd $rhoDir ; fslview_deprecated T1.nii.gz T1rhoMap.nii.gz -l \
   /nopoulos/T1Rho/scripts_2019/SmoothRichHues.lut -b 0,250 )
done
################################  Notes ###################
14:43:12 119 60153518 Fit ok
Done already.
14:43:29 122 60366018 Fit ok
14:43:37 137 61997416 Fit ok, heavy ringing in cerebellum
14:44:42 137 64426718 Fit ok.  Speckles only
14:45:44 137 65250814 Fit ok
Done already.
12:10:46 139 64573117 Fit ok, moderate ringing
12:15:46 139 64616118 Fit ok
12:20:56 152 60167218 Fit ok, ringing
12:26:44 164 61547518 Fit ok, ringing
12:32:22 166 61894618 Fit ok
12:37:09 172 61118116 Fit ok
12:40:27 172 63720917 Fit ok, light ringing
12:45:23 172 63879514 Fit ok
14:54:35 188 60638916 Fit ok
12:48:18 188 63495017 Fit ok, light ringing
12:53:17 188 64961114 Fit ok
12:53:17 199 63565914 Fit ok
12:53:17 199 63705915 Fit ok
12:55:36 202 60844717 Fit ok
12:55:36 202 64312818 Fit ok
13:00:48 206 60269018 Fit ok
13:05:41 214 60096015 Fit ok
Done already.
13:05:41 214 60309716 Poor TSL60&10->T2 fit, too narrow
13:08:33 215 60902117 Fit ok, light ringing
Done already.
13:08:33 215 61693018 Fit ok, heavy ringing in cerebellum
13:13:50 217 62050617 Fit ok, moderate ringing
13:19:24 217 62600118 Fit ok, heavy ringing in cerebellum
13:24:10 221 60885316 Fit ok
13:27:45 221 61145517 Fit ok, light ringing
13:32:38 221 63737414 Fit ok
Done already.
13:32:38 227 60985718 Fit ok
13:37:59 227 64473315 Fit ok
Done already.
13:37:59 251 61922116 Fit ok
13:40:49 251 63850614 Fit ok
Done already.
13:40:49 260 61086318 Fit ok, heavy ringing in cerebellum
13:46:06 260 61734815 Fit ok
Done already.
13:46:06 260 62025016 Poor TSL60->T2 fit
13:48:33 269 62022216 Fit ok
13:51:27 271 61085218 Fit ok, light ringing
13:56:38 271 61737315 Fit ok, light ringing
Done already.
13:56:38 278 61536018 Fit ok, light ringing
14:01:52 278 61579016 Fit ok
14:04:59 278 61781017 Fit ok, light ringing
14:10:16 283 62297416 Poor TSL60->T2 fit
14:13:32 283 63275217 Fit ok
14:18:47 299 60079918 Fit ok
14:24:04 302 63129415 Tilt, Tilt
14:26:17 302 65134617 Fit ok
14:32:02 305 62813718 Fit ok, heavy ringing in cerebellum
14:37:38 310 62050017 Fit ok, moderate ringing
14:42:26 310 62079916 Fit ok
14:45:41 310 62126115 Fit ok
14:48:58 311 60785916 Fit ok
14:51:40 311 61090017 Fit ok
14:57:21 311 61143717 No T2_brain, not fitted
14:57:21 311 65032614 Fit ok
Done already. 
14:57:21 319 60120018 Fit ok, heavy ringing
15:03:15 322 60772917 Fit ok
15:08:29 322 60782816 Fit ok
15:11:15 322 65234214 Fit ok
Done already.
15:11:15 323 64513315 Fit ok
15:14:06 323 64588717 Fit ok, moderate ringing
15:19:08 331 61563118 Fit ok
15:25:00 337 60439917 Fit ok, light ringing
15:30:36 337 64731314 Fit ok
Done already.
15:30:36 337 64919815 Fit ok
15:33:13 340 62626115 Fit ok
Done already.
15:33:13 340 63505917 Fit ok, moderate ringing in cerebellum
15:38:31 349 61549717 Fit ok, moderate ringing in cerebellum
15:43:29 349 61967018 Fit ok, moderate ringing in cerebellum
15:49:05 355 61447118 Fit ok, light ringing
15:54:48 373 60381518 Fit ok, moderate ringing
16:00:04 406 62485018 Fit ok
16:05:20 410 64934117 Fit ok
16:10:22 410 64990818 Fit ok
16:15:50 416 62366618 Fit ok, heavy ringing in cerebellum
16:21:04 419 61535018 Fit ok, heavy ringing in cerebellum
16:26:21 419 61576216 Fit ok
16:29:37 419 61781617 Fit ok, moderate ringing in cerebellum
16:35:13 425 62888318 Fit ok
16:40:11 425 62917717 Fit ok
16:45:52 433 63781517 Fit ok
16:50:47 433 64774818 Fit ok
16:55:38 448 60136115 Fit ok
Done already.
16:55:38 452 64891817 Fit ok
17:01:25 457 64027414 Fit ok
Done already.
17:01:25 457 65049715 Poor fit
17:04:11 458 61431916 TSL10->TSL50?
17:07:36 466 63565214 Fit ok
Done already.
17:07:36 466 63706615 Fit ok
17:10:59 475 60497316 Fit ok
17:13:48 475 61317017 Fit ok, moderate ringing in cerebellum
17:19:12 475 64890614 Fit ok
Done already.
17:19:12 478 62266818 Fit ok, heavy ringing below ACPC
17:24:16 482 62138316 Fit ok
Done already.
17:24:16 482 62755217 Fit ok
17:29:51 482 64515518 Fit ok, moderate ringing in cerebellum
17:35:25 484 62759515 Fit ok
Done already.
17:35:25 484 64875417 Fit ok, moderate ringing in cerebellum
17:40:37 485 60078515 Fit ok
Done already. 
17:40:37 485 60379316 Fit ok
17:43:31 487 62209316 Fit ok
Done already.
17:43:31 487 63189017 Fit ok, moderate ringing in cerebellum
17:48:58 487 64314718 Fit ok, moderate ringing
17:54:23 496 64487914 Fit ok
17:57:06 496 64560215 Fit ok
17:59:50 500 62614317 Fit ok
Done already.
17:59:50 500 63004618 Fit ok, moderate ringing in cerebellum
18:05:15 502 61880118 Fit ok, moderate ringing in cerebellum
18:10:52 505 60296917 Fit ok, light ringing
18:16:07 505 60325716 Fit ok
18:19:34 505 64658314 Fit ok
Done already.
18:19:34 509 61564418 Fit ok
18:25:17 514 64271815 Fit ok
Done already.
18:25:17 527 61808417 Fit ok, moderate ringing
Done already.
18:25:17 527 61834418 Fit ok, moderate ringing
18:30:39 533 64254118 Fit ok, moderate ringing in cerebellum
18:35:59 533 65218415 Fit ok
18:38:43 538 62598617 Fit ok, light ringing
Done already.
18:38:43 538 62989518 Fit ok
18:44:03 556 61793918 Fit ok, heavy ringing in cerebellum
18:50:44 565 61392018 Fit ok
18:56:06 568 62527916 Fit ok
18:59:56 568 63217817 Fit ok, speckling TSL10->TSL50?
19:05:12 568 64574114 Fit ok
Done already.
19:05:12 571 60067118 Fit ok, heavy ringing in cerebellum
19:10:37 577 62109417 Fit ok, light ringing
Done already.
19:10:37 577 63187718 Fit ok, heavy ringing in cerebellum
19:16:02 589 61996516 Fit ok
Done already.
19:16:02 589 64373617 Fit ok, light ringing
19:21:15 593 63896118 Fit ok
19:26:39 598 62384218 Fit ok, moderate ringing in cerebellum
19:31:43 598 62498916 Fit ok
Done already.
19:31:43 604 64512615 Fit ok
Done already.
19:31:43 604 64587417 Fit ok, light ringing
19:37:25 605 62183018 Fit ok, moderate ringing in cerebellum
19:42:13 611 62428415 Fit ok
Done already.
19:42:13 611 64804817 Fit ok
19:47:30 616 64502117 Fit ok, moderate ringing
19:52:56 616 64673718 Fit ok, light ringing in cerebellum
19:57:59 620 62585918 Fit ok, heavy ringing in cerebellum
20:03:13 622 61276918 Fit ok
20:09:33 622 64831914 Fit ok
Done already.
20:09:33 625 60541518 Fit ok, moderate ringing
20:15:31 635 61289716 Fit ok
Done already.
20:15:31 635 63722417 Fit ok, moderate ringing in cerebellum
20:20:31 638 60236818 Fit ok, light ringing
20:25:24 679 62254818 Fit ok
20:30:21 686 60152518 Fit ok, light ringing in cerebellum
20:35:25 688 62600317 Fit ok
Done already.
20:35:25 688 62990718 Fit ok
20:41:00 691 62470418 Fit ok, moderate ringing
20:46:39 692 64689517 Fit ok, moderate ringing in cerebellum
20:52:16 692 65062818 Fit ok, light ringing
20:57:48 697 62097016 Fit ok
21:01:26 697 65235517 Fit ok, TSL10->TSL50?
21:06:14 707 61388818 Fit ok, light ringing in cerebellum
21:11:34 733 61936218 Fit ok, light ringing in cerebellum
21:16:39 734 60355018 Fit ok, light ringing in cerebellum
21:21:37 736 62395516 Fit ok
21:24:59 736 63519315 Fit ok
Done already.
21:24:59 745 63968317 Fit ok
21:30:15 745 64011518 Fit ok, light ringing in cerebellum
21:35:55 751 62441718 Fit ok, moderate ringing in cerebellum
21:41:02 754 62541518 Fit ok, heavy ringing in cerebellum
21:45:34 767 63880518 Fit ok, moderate ringing in cerebellum
21:50:58 776 60926416 Fit ok
21:54:19 776 61575617 Fit ok, light ringing
21:59:24 776 64987114 Fit ok
Done already.
21:59:24 800 63523015 Fit ok
Done already.
21:59:24 802 62901217 Fit ok, moderate ringing
Done already.
21:59:24 802 62902318 Fit ok, heavy ringing in cerebellum
22:04:29 805 60382618 Fit ok, light ringing
22:10:04 824 61188818 Fit ok
22:15:30 827 60915816 Fit ok
22:18:56 827 64430114 Fit ok
22:22:21 830 62890217 Fit ok, light ringing
Done already.
22:22:21 830 64787218 Fit ok, light ringing
22:27:07 835 63404217 Fit ok
22:32:34 839 63133115 Poor TSL60->T2 fit
22:34:59 839 65135817 Fit ok
22:40:00 842 61492615 Fit ok
Done already.
22:40:00 842 62428716 Fit ok
22:43:17 842 62515317 Fit ok
22:47:59 850 64328414 Fit ok
Done already.
22:47:59 856 60483218 Fit ok, moderate ringing in cerebellum
22:53:15 857 62184118 Fit ok, moderate ringing in cerebellum
22:58:21 863 61200918 Poor TSL50->T2 fit
23:03:58 871 61549815 Fit ok
Done already.
23:03:59 871 64528317 Poor TSL50->T2 fit
23:09:27 877 62612817 Fit ok, light ringing
23:14:41 877 63003618 Fit ok, light ringing
23:19:28 886 64271015 Fit ok
Done already.
23:19:28 887 62399318 Fit ok, moderate ringing in cerebellum
23:24:48 887 65221215 Fit ok
23:27:27 890 64905617 Fit ok, moderate ringing in cerebellum
23:33:22 901 63002917 Fit ok, moderate ringing
23:39:12 901 63104618 Fit ok, light ringing
23:43:51 904 61463018 Fit ok
23:49:14 913 61204517 Fit ok, moderate ringing
23:54:29 913 62195218 Fit ok, heavy ringing in cerebellum
23:59:26 917 61304717 Fit ok, light ringing
00:05:06 917 63651318 Fit ok, light ringing
00:10:50 947 62529516 Fit ok
Done already.
00:10:50 947 63219117 Fit ok, speckled, heavy ringing in cerebellum
00:15:46 949 61489915 Fit ok
Done already.
00:15:46 949 62427316 Poor TSL60->T2 fit
00:18:22 949 62513617 Fit ok, heavy ringing in cerebellum
00:23:37 961 62946218 Fit ok, heavy ringing in cerebellum
00:27:09 961 62960317 Fit ok, moderate ringing
00:32:07 985 60397917 Fit ok, light ringing
00:37:24 985 62400218 Fit ok, moderate ringing in cerebellum
00:42:30 985 65222115 Fit ok
Done already.
00:42:30 986 61550317 Fit ok, light ringing
Done already.
00:42:30 986 61968018 Fit ok, heavy ringing in cerebellum


i=2
while [[ $i -le 52 ]];
do
ursi=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $1}'`
mrqid=`cat $outdir/spinLockTimes_DM1.csv | head -n+${i} | tail -n-1 | awk -F"," '{print $2}'`
echo "${i}/52,${ursi}/${mrqid}"
rhoDir=$indir/$ursi/$mrqid/T1rho
pushd $rhoDir > /dev/null
fslview T1.nii.gz T1rhoMap.nii.gz -l /nopoulos/T1rho/scripts_2017/SmoothRichHues.lut -b 0,250
popd > /dev/null
let i=i+1
done

  #0,250 range is good for viewing

  #For a few subjects, had to use T1 as the target, still with "-i" reverse sort order and  registration worked better.

#All scans look ast they should

###########################################################################################################################################

#For VBM-like analysis where subs are pushed to template space and multiplied by Jacobian, need covariates
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

  #As expected, max overlap: Siemens = 41, SiemensGE = 51

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




# Check outputs
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟quality.csv (?)
```
## Code:
```
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

```

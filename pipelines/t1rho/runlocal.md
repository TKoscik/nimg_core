# Run on local hardware
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟T1rhoMap.nii.gz
```
## Code:
```
#Run on local hardware
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
```

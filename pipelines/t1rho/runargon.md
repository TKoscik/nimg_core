# Run on argon
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟T1rhoMap.nii.gz
```
## Code:
```
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
```

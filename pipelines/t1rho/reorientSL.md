# Reorient all T1rho spin-lock data to "RIP"
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟TSL${lowspintime}.nii.gz
  ∟TSL${highspintime}.nii.gz
```
## Code:
```
###################################################
# 
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
```

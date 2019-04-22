# A script to take raw t1rho (short and long spin-lock) files, coregister them to a T1, then process the map
## Output:
```
${researcher}/${project}/derivatives/tlrho/
  ∟T1rhoMap.nii.gz \
  ∟T1rhoMap_ExpConstant.nii.gz \
  ∟T1rhoMap_Constant.nii.gz \
  ∟T1rhoMap_R2.nii.gz

```
## Code:
```
indir=/nopoulos/structural/Trio_MR
outdir=/nopoulos/T1rho/scripts_2017




#!/bin/bash

#A script to take raw t1rho (short and long spin-lock) files, coregister them to a T1, then process the map
  #Assumptions are made that the T1rho (TSL) and Anatomical (e.g. T1) files are in the same orientation (e.g. "RIP" orientation)

  #ANTs needs to be in the working PATH

  #T1rhoMap needs to be compiled and in the working PATH

#Built off of work done by Vince Magnotta (vincent-magnotta@uiowa.edu)
  #Update by Joel Bruss, 11/2017 (joel-bruss@uiowa.edu)
  #Update v2 12/2017 (allowed the use of any anatomical (e.g. T1, T2) for target).  Can specify low spin-lock to anatomical (default) or high spin-lock to anatomical.
    #In the latter case, the first "high" spin-lock will be used for registration, all other spin-lock files will be co-registered to that one.
  
  #Output will be in directory where T1rho data lives, if not specified

#Anatomical needs to be skull-stripped.  For TSL files, AFNI's 3dSkullStrip will create a mask
  #co-registration will use skull-stripped volumes in conjunction with masks
  #N4 bias field correction will be applied to the TSL files before brain masking and regostration

#TSL to TSL (e.g. 0 to 90, 10 to 60): Rigid alignment
#TSL to T1: Affine alignment


#scriptdir=`dirname $(perl -e 'use Cwd "abs_path";print abs_path(shift)' $0)`
scriptdir=`dirname $0`

tmpt1rho=""
tmplockTimes=""
procStream=0


while getopts "a:t:s:io:" opt;
do
  case $opt in
    a) anatomical=$OPTARG ;;
    t) tmpt1rho="$tmpt1rho $OPTARG" ;;
    s) tmplockTimes="$tmplockTimes $OPTARG" ;;
    i) procStream=1 ;;
    o) outdir=$OPTARG ;;
    *) echo "Usage: $0 -a AnatomicalImage -t T1rhoImage1 -s spinLockTime1  -t T1rhoImage2 -s spinLockTime2 ... -i -o outdir" ; exit 1 ;;
  esac
done


#Check for package dependencies
  #Check for T1rhoMap
  if [[ ! `command -v T1rhoMap` ]]; then
    echo "Error:  Unable to find the utility 'T1rhoMap.' Update your PATH and rerun the command."
    exit 1
  fi

  #Check for ANTs binaries
  if [[ ! `command -v antsApplyTransforms` ]]; then
    echo "Error:  Unable to find the ANTs utilities. Update your PATH and rerun the command."
    exit 1
  fi

  #Check that ANTs PATH is set (shell scripts in ANTs directories depend on this variable)
  if [[ -z $ANTSPATH ]]; then
    echo "Error: ANTSPATH variable is not set.  Update your globa variables and rerun the command."
    exit 1
  fi

#Check for input data
  #Anatomical data
  if [ ! -e $anatomical ]; then
    echo "Error: Invalid Anatomical image specified (${anatomical})."
    exit 1
  fi

  #T1rho data
  for t1rhofile in $tmpt1rho;
    do
    if [ ! -e $t1rhofile ]; then
      echo "Error: Invalid T1rho image specified (${t1rhofile})."
      exit 1
    fi
  done

  #Check to make sure the number of T1rho inputs equals the number of spin-lock times given
  t1rhoNum=`echo $tmpt1rho | awk '{print NF}'`
  slNum=`echo $tmplockTimes | awk '{print NF}'`

  if [[ $t1rhoNum -ne $slNum ]]; then
    echo "Error: The number of input T1rho files (${t1rhoNum}) does not match the number of input spin-lock times (${slNum})."
    exit 1
  fi 

#Check for output directory, create if needed or default to directory of first T1rho file
if [[ $outdir == "" ]]; then
  outdir=`dirname $(echo $t1rho | awk '{print $1}')`

  if [[ ! -d $outdir/tmpFiles ]]; then
    mkdir $outdir/tmpFiles
  fi
fi

  if [[ ! -d $outdir/tmpFiles ]]; then
    mkdir -p $outdir/tmpFiles
  fi

tmpdir=$outdir/tmpFiles

anatBase=`basename $anatomical | awk -F"." '{print $1}'`

#########################

#Reorder the input T1rho list, sort by spin-lock times, then by name (if there is more than one TSL90 file)
echo "...Sorting the input T1rho data and Spin-lock times"
i=1
while [[ $i -le $t1rhoNum ]];
  do
  t1rhoFile=`echo $tmpt1rho | awk -v var=${i} '{print $var}'`
  slFile=`echo $tmplockTimes | awk -v var=${i} '{print $var}'`
  echo "${t1rhoFile} ${slFile}" >> $outdir/tmpList
  let i=i+1
done

#Based on tmpList, sort by spin-lock times, then break into two lists: one for T1rho, one for spin-lock times
  #Invert the lists if the "-i" flag is used (will use the higher spin-lock times for registration)
if [[ $procStream -eq 0 ]]; then
  times=`cat $outdir/tmpList | sort -k2 -n | awk '{print $2}' | tr " " "\n" | tr "\n" " "`
  t1rho=`cat $outdir/tmpList | sort -k2 -n | awk '{print $1}' | tr " " "\n" | tr "\n" " "`
else
  times=`cat $outdir/tmpList | sort -k2 -n -r | awk '{print $2}' | tr " " "\n" | tr "\n" " "`
  t1rho=`cat $outdir/tmpList | sort -k2 -n -r | awk '{print $1}' | tr " " "\n" | tr "\n" " "`
fi

#Determine number of repeats (if any) and the associated spin-lock value, the field numbers for the repeat TSL
repNum=`echo $times | tr " " "\n" | sort  | uniq -c | sort -nr | head -n+1 | awk '{print $1}'`
repVal=`echo $times | tr " " "\n" | sort  | uniq -c | sort -nr | head -n+1 | awk '{print $2}'`
repFields=`echo $times | awk -F" " -v var=${repVal} '{for (f=1;f<=NF;++f){if ($f == var){print f}}}'`
nonrepFields=`echo $times | awk -F" " -v var=${repVal} '{for (f=1;f<=NF;++f){if ($f != var){print f}}}'`
nonrepNum=`echo $nonrepFields | awk '{print NF}'`

#Remove temporary file
rm $outdir/tmpList

#Log the list of files and spin-lock times
echo $times >> $tmpdir/_SLtimes
echo $t1rho >> $tmpdir/_SLfiles

############################################################################################
############################################################################################
## Interesting code begins

#First spin-lock (0, 10, 30, 60, etc.) to Anatomical (e.g. T1_brain) - Affine
  #This will be the TSL file that all others are registered to (on their way to Anatomical)
baseT1rho=`echo $t1rho | awk '{print $1}'`
basedir=`dirname ${baseT1rho}`
baseT1rhoName=`basename $baseT1rho | awk -F"." '{print $1}'`
baseTime=`echo $times | awk '{print $1}'`

pushd `dirname $baseT1rho` > /dev/null

#Bias-field correct the lower spin-lock time
  #Temporary to get a file that is easier to skull-strip.  Feed this into 3dSkullstrip, create the mask, then redo N4 with the mask
  [ ! -e ${baseT1rhoName}.nii.gz ] && echo "Missing file:" ${baseT1rhoName}.nii.gz
  [ ! -e $tmpdir/tmp1_BFC.nii.gz ] && \
   N4BiasFieldCorrection -i ${baseT1rhoName}.nii.gz -o $tmpdir/tmp1_BFC.nii.gz

#Create a binary mask of first TSL file
echo "...Creating a mask for ${baseT1rho}"

  #Skullstrip
  [ ! -e $tmpdir/tmp1_BFC.nii.gz ] && echo "Missing file:" $tmpdir/tmp1_BFC.nii.gz && exit
  if [ ! -e $tmpdir/${baseT1rhoName}_mask.nii.gz ] ; then
      3dSkullStrip -input $tmpdir/tmp1_BFC.nii.gz -prefix $tmpdir/${baseT1rhoName}_mask.nii.gz
      #Binarize, conversion to float
      3dcalc -a $tmpdir/${baseT1rhoName}_mask.nii.gz -expr 'step(a)' -prefix $tmpdir/${baseT1rhoName}_mask.nii.gz -overwrite -datum float
      #Slight smoothing to push mask past hard edges, then re-binarizing
      3dmerge -1blur_fwhm 0.5 -doall -prefix $tmpdir/${baseT1rhoName}_mask.nii.gz $tmpdir/${baseT1rhoName}_mask.nii.gz -overwrite
      3dcalc -a $tmpdir/${baseT1rhoName}_mask.nii.gz -expr 'step(a)' -prefix $tmpdir/${baseT1rhoName}_mask.nii.gz -overwrite -datum float
      #Some cases where the "origin" of the input and mask are off (e-06 values!) and N4 won't budge.  Force geometry on the mask
      fslcpgeom ${baseT1rhoName}.nii.gz $tmpdir/${baseT1rhoName}_mask.nii.gz
  fi
  #Use the mask with raw data to get a better bias-field corrected image
  [ ! -e $tmpdir/${baseT1rhoName}_mask.nii.gz ] && \
      echo "Missing file:" $tmpdir/${baseT1rhoName}_mask.nii.gz  && exit
  [ ! -e $tmpdir/${baseT1rhoName}_BFC.nii.gz ] && \
   N4BiasFieldCorrection -i ${baseT1rhoName}.nii.gz -o $tmpdir/${baseT1rhoName}_BFC.nii.gz \
      -x $tmpdir/${baseT1rhoName}_mask.nii.gz -r 1

  #Skull-strip the volume before co-registering
  [ ! -e $tmpdir/${baseT1rhoName}_BFC.nii.gz ] && \
      echo "Missing file:" $tmpdir/${baseT1rhoName}_BFC.nii.gz && exit
  [ ! -e $tmpdir/${baseT1rhoName}_brain.nii.gz ] && \
      3dcalc -a $tmpdir/${baseT1rhoName}_BFC.nii.gz -b $tmpdir/${baseT1rhoName}_mask.nii.gz \
      -expr 'a*step(b)' -prefix $tmpdir/${baseT1rhoName}_brain.nii.gz -datum short

  #Remove temp N4 file
  #rm $tmpdir/tmp1_BFC.nii.gz
popd > /dev/null

#Co-register base T1rho (lowest spin-lock, unless the "-i" flag was used (inverse)) to Anatomical (skull-stripped T1rho to skull-sripped Anatomical (e.g. T1_brain))
echo "...Co-registering ${baseT1rhoName} to ${anatBase}."

[ ! -e $tmpdir/${baseT1rhoName}_to_${anatBase}_0GenericAffine.mat ] && \
$ANTSPATH/antsRegistration --dimensionality 3 --float 0 --output \
   \[$tmpdir/${baseT1rhoName}_to_${anatBase}_,$tmpdir/${baseT1rhoName}_to_${anatBase}_Warped.nii.gz\] \
   --interpolation Linear --winsorize-image-intensities 0 --use-histogram-matching 0 \
   --initial-moving-transform \[$anatomical,${baseT1rho},1\] \
   --transform Rigid\[0.1\] \
   --metric Mattes\[$anatomical,$tmpdir/${baseT1rhoName}_brain.nii.gz,1,32,Regular,0.25\] \
   --convergence \[1000x500x250x100,1e-6,10\] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox \
   --transform Affine\[0.1\] --metric \
   Mattes\[$anatomical,${baseT1rho},1,32,Regular,0.25\] \
   --convergence \[1000x500x250x100,1e-6,10\] --shrink-factors 8x4x2x1 --smoothing-sigmas 3x2x1x0vox

#   $scriptdir/antsRegistrationSyN_T1rho.sh -d 3 -f $anatomical \
#   -m $tmpdir/${baseT1rhoName}_brain.nii.gz -t a -o $tmpdir/${baseT1rhoName}_to_${anatBase}_

#When done, reapply warp with LanczosWindowedSinc interpolation to original (non-masked) file
  #Using BFC data will create problems with creation of the T1rhoMap
[ ! -e $tmpdir/${baseT1rhoName}_to_${anatBase}_LWS.nii.gz ] && \
   antsApplyTransforms -d 3 \
   -i $baseT1rho \
   -r $anatomical \
   -o $tmpdir/${baseT1rhoName}_to_${anatBase}_LWS.nii.gz \
   -n LanczosWindowedSinc \
   -t $tmpdir/${baseT1rhoName}_to_${anatBase}_0GenericAffine.mat
[ ! -e $tmpdir/${baseT1rhoName}_to_${anatBase}_0GenericAffine.mat ] && \
   echo "Failed:" antsApplyTransforms -d 3 \
      -i $baseT1rho \
      -r $anatomical \
      -o $tmpdir/${baseT1rhoName}_to_${anatBase}_LWS.nii.gz \
      -n LanczosWindowedSinc \
      -t $tmpdir/${baseT1rhoName}_to_${anatBase}_0GenericAffine.mat && exit

#Make a list of the new T1rho files (will be added to after other TSL files are processed)
newList=$tmpdir/${baseT1rhoName}_to_${anatBase}_LWS.nii.gz
newTime=${baseTime}


#########################

#Co-register the remaining spin-lock T1rho files to the base T1rho file
j=2
while [[ $j -le $t1rhoNum ]]
  do

  tmp=`echo $t1rho | awk -v var=${j} '{print $var}'`
  tmp2=`echo $times | awk -v var=${j} '{print $var}'`

  tmpT1rhoName=`basename $tmp | awk -F"." '{print $1}'`
  tmpT1rhodir=`dirname $tmp`

  echo "...Creating a mask for ${tmpT1rhoName}"
  
  pushd $tmpT1rhodir > /dev/null


  #Bias-field correct the longer spin-lock times
    #Temporary to get a file that is easier to skull-strip.  Feed this into 3dSkullstrip, create the mask, then redo N4 with the mask
  [ ! -e ${tmpT1rhoName}.nii.gz ] && echo Missing file: ${tmpT1rhoName}.nii.gz && exit
  [ ! -e $tmpdir/tmp_BFC.nii.gz ] && \
      N4BiasFieldCorrection -i ${tmpT1rhoName}.nii.gz -o $tmpdir/tmp_BFC.nii.gz

    #Skullstrip
  [ ! -e $tmpdir/tmp_BFC.nii.gz ] && echo "Missing file:" $tmpdir/tmp_BFC.nii.gz && exit
  if [ ! -e $tmpdir/${tmpT1rhoName}_mask.nii.gz ] ; then
     3dSkullStrip -input $tmpdir/tmp_BFC.nii.gz -prefix $tmpdir/${tmpT1rhoName}_mask.nii.gz

     #Binarize, conversion to float
     3dcalc -a $tmpdir/${tmpT1rhoName}_mask.nii.gz -expr 'step(a)' -prefix $tmpdir/${tmpT1rhoName}_mask.nii.gz -overwrite -datum float

     #Slight smoothing to push mask past hard edges, then re-binarizing
     3dmerge -1blur_fwhm 0.5 -doall -prefix $tmpdir/${tmpT1rhoName}_mask.nii.gz $tmpdir/${tmpT1rhoName}_mask.nii.gz -overwrite
     3dcalc -a $tmpdir/${tmpT1rhoName}_mask.nii.gz -expr 'step(a)' -prefix $tmpdir/${tmpT1rhoName}_mask.nii.gz -overwrite -datum float

     #Some cases where the "origin" of the input and mask are off (e-06 values!) and N4 won't budge.  Force geometry on the mask
     fslcpgeom ${tmpT1rhoName}.nii.gz $tmpdir/${tmpT1rhoName}_mask.nii.gz
  fi

  #Use the mask with raw data to get a better bias-field corrected image
  [ ! -e ${tmpT1rhoName}.nii.gz ] && echo "Missing file:" ${tmpT1rhoName}.nii.gz && exit
  [ ! -e $tmpdir/${tmpT1rhoName}_BFC.nii.gz ] && \
  N4BiasFieldCorrection -i ${tmpT1rhoName}.nii.gz -o $tmpdir/${tmpT1rhoName}_BFC.nii.gz -x $tmpdir/${tmpT1rhoName}_mask.nii.gz -r 1

  #Skull-strip the volume before co-registering but STILL use the mask
  [ ! -e $tmpdir/${tmpT1rhoName}_BFC.nii.gz ] && echo "Missing file:" $tmpdir/${tmpT1rhoName}_BFC.nii.gz && exit
  [ ! -e $tmpdir/${tmpT1rhoName}_brain.nii.gz ] && \
  3dcalc -a $tmpdir/${tmpT1rhoName}_BFC.nii.gz -b $tmpdir/${tmpT1rhoName}_mask.nii.gz \
    -expr 'a*step(b)' -prefix $tmpdir/${tmpT1rhoName}_brain.nii.gz -datum short

  popd > /dev/null
  
  echo "...Co-registering ${tmpT1rhoName} to ${baseT1rhoName}"
  Rho1Stub=$tmpdir/${tmpT1rhoName}
   ORIGINALNUMBEROFTHREADS=${ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS}
   ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=4
   export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS
  [ ! -e  ] && echo "Missing file:"  && exit
  [ ! -e $tmpdir/${tmpT1rhoName}_to_${baseT1rhoName}_Warped.nii.gz ] && \
     $ANTSPATH/antsRegistration --dimensionality 3 --float 0 --output \
       \[${Rho1Stub}_to_${baseT1rhoName}_,${Rho1Stub}_to_${baseT1rhoName}_Warped.nii.gz\] \
       --interpolation Linear --winsorize-image-intensities 0 --use-histogram-matching 0 \
       --initial-moving-transform \[$tmpdir/${baseT1rhoName}_brain.nii.gz,${Rho1Stub}_brain.nii.gz,1\] \
       --transform Rigid\[0.1\] --metric \
       Mattes\[${tmpdir}/${baseT1rhoName}_brain.nii.gz,${Rho1Stub}_brain.nii.gz,1,32,Regular,0.25\] \
       --convergence \[1000x500x250x100,1e-6,10\] \
       --shrink-factors 8x4x2x1 \
       --smoothing-sigmas 3x2x1x0vox
   ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=$ORIGINALNUMBEROFTHREADS
   export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS
   [ ! -e ${Rho1Stub}_to_${baseT1rhoName}_Warped.nii.gz ] && \
      echo Fitting failed ${Rho1Stub}_to_${baseT1rhoName}_Warped.nii.gz && exit

#  $scriptdir/antsRegistrationSyN_T1rho.sh -n 4 -d 3 -f $tmpdir/${baseT1rhoName}_brain.nii.gz \
#  -m $tmpdir/${tmpT1rhoName}_brain.nii.gz -t r -o $tmpdir/${tmpT1rhoName}_to_${baseT1rhoName}_

  echo "...Combining warps to get ${tmpT1rhoName} in ${anatBase} space."

  #Apply transforms combining lowest spin-lock to T1, T1rho-to-T1rho, on raw data
  T1rho2anat=$tmpdir/${baseT1rhoName}_to_${anatBase}_0GenericAffine.mat
  [ ! -e $T1rho2anat ] && echo Failed to create $T1rho2anat && exit
  Rho2Rho=$tmpdir/${tmpT1rhoName}_to_${baseT1rhoName}_0GenericAffine.mat
  [ ! -e $Rho2Rho ] && echo Failed to create $Rho2Rho && exit
  [ ! -e $tmpdir/${tmpT1rhoName}_to_${anatBase}_LWS.nii.gz ] && \
  antsApplyTransforms -d 3 \
  -i $tmp \
  -r ${anatomical} \
  -o $tmpdir/${tmpT1rhoName}_to_${anatBase}_LWS.nii.gz \
  -n LanczosWindowedSinc \
  -t $tmpdir/${baseT1rhoName}_to_${anatBase}_0GenericAffine.mat \
  -t $tmpdir/${tmpT1rhoName}_to_${baseT1rhoName}_0GenericAffine.mat

  #Add to the new list of the new T1rho files
  newList="${newList} ${tmpdir}/${tmpT1rhoName}_to_${anatBase}_LWS.nii.gz"
  newTime="${newTime} ${tmp2}"
  
  let j=j+1
done

#If output (non-base T1rho) files are the same spin-lock times, average together volumes
  #Otherwise create the comma-separated lists of files and spin-lock times
if [[ $repNum -gt 1 ]]; then
  echo "Averaging similar spin-lock files together"
  #Average TSL time, files (for creating an average)
  avgTime=${repNum}
  avgList=$(for infile in `echo $repFields`; do echo $newList | awk -v var=${infile} '{print $var}' | tr " " "\n" | tr "\n" " "; done)
  #Average the long spin-lock T1rho files together
  AverageImages 3 ${tmpdir}/Avg_TSL${repNum}_to_T1_LWS.nii.gz 0 $avgList
  #Determine the non-repeating files, TSL times
  nonrepList=$(for infile in `echo $nonrepFields`; do echo $newList | awk -v var=${infile} '{print $var}' | tr " " "\n" | tr "\n" ","; done)
  nonrepTime=$(for infile in `echo $nonrepFields`; do echo $newTime | awk -v var=${infile} '{print $var}' | tr " " "\n" | tr "\n" ","; done)
  #Create a list of final TSL files, times to feed into T1rhoMap
  t1rhoList="${nonrepList}${tmpdir}/Avg_TSL${repNum}_to_T1_LWS.nii.gz"
  t1rhoTimes="${baseTime},${avgTime}"
else
  t1rhoList=`echo $newList |sed 's/^ *//g' | sed -e 's/\ /,/g'`
  t1rhoTimes=`echo $newTime |sed 's/^ *//g' | sed -e 's/\ /,/g'`
fi

#########################

#Create the T1rhoMap

echo "...Creating the T1rhoMap"
[ ! -e $outdir/T1rhoMap.nii.gz ] && \
   T1rhoMap \
   --inputVolumes ${t1rhoList} \
   --t1rhoTimes ${t1rhoTimes} \
   --mappingAlgorithm Linear \
   --maxTime 400.0 \
   --threshold 50 \
   --outputFilename $outdir/T1rhoMap.nii.gz \
   --outputExpConstFilename $outdir/T1rhoMap_ExpConstant.nii.gz \
   --outputConstFilename $outdir/T1rhoMap_Constant.nii.gz \
   --outputRSquaredFilename $outdir/T1rhoMap_R2.nii.gz

#########################

#Skull-strip the output T1rhoMap files
pushd $outdir > /dev/null
for infile in 'T1rhoMap' 'T1rhoMap_ExpConstant' 'T1rhoMap_Constant' 'T1rhoMap_R2';
   do
   if [[ ! -e T1mask.nii.gz ]]; then
      fslmaths ${anatomical} -bin T1mask.nii.gz -odt char
   fi
   [ -e ${infile}.nii.gz ] && \
      fslmaths ${infile}.nii.gz -mas T1mask.nii.gz ${infile}.nii.gz
done
popd > /dev/null

date +"end_time:+%Y-%m-%dT%H:%M:%S%z"

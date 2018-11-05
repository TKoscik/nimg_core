#!/bin/bash



function printCommandLine {
    echo ""
    echo "Usage: $0 -n Negative-DICOM -p Positive-DICOM -o outputDir -b outputBaseName"
    echo ""
    echo "   where:"
    echo "   -n Negative phase encoding DICOM directory (GE Alternate phase encoding)"
    echo "   -p Positive phase encoding DICOM directory (Default GE phase encode)"
    echo "   -o Output directory"
    echo "   -b Output basename"
    echo ""
    exit 1
}

# Parse Command line arguments
while getopts ân:p:b:o:hâ OPTION
do
  case $OPTION in
    h)
      printCommandLine
      ;;
    n)
      negDir=$OPTARG
      ;;
    p)
      posDir=$OPTARG
      ;;
    b)
      outBase=$OPTARG
      ;;
    o)
      outDir=$OPTARG
      ;;
    ?)
      printCommandLine
      ;;
  esac
done


#####################################################################
# Check the required programs exist on the user PATH
#####################################################################

checkProg=`which dicom_hdr`
if [[ $checkProg == "" ]]; then
  echo "Error:  Unable to find the AFNI DICOM utility (dicom_hdr). Update your path and rerun the command."
  exit 1
fi

checkProg=`which DWIConvert`
if [[ $checkProg == "" ]]; then
  echo "Error:  Unable to find the DWIConvert program. Update your path and rerun the command."
  exit 1
fi

checkProg=`which fslroi`
if [[ $checkProg == "" ]]; then
  echo "Error:  Unable to find the FSL programs. Update your path and rerun the command."
  exit 1
fi

#####################################################################
# Check the input parameters
#####################################################################

if [ ! -e $negDir ]; then
  echo "Error: Specified Negative DICOM directory does not exist."
  exit 1
fi

if [ ! -e $posDir ]; then
  echo "Error: Specified Positive DICOM directory does not exist."
  exit 1
fi

if [ ! -e $outDir ]; then
  echo "Error: Specified Output directory does not exist."
  exit 1
fi


if [[ "$outBase" == "" ]]; then
  echo "Error: Outputfile base filename was not specified"
  exit 1
fi

echo "Parameters:"
echo "   Positive Dir: $posDir"
echo "   Negative Dir: $negDir"
echo "   Output Dir: $outDir"
echo "   Base Name: $outBase"
exit



#####################################################################
# Convert Images from DICOM into NIFTI and extract other scan Info
#####################################################################
DWIConvert --inputDicomDirectory ${posDir} \
           --conversionMode DicomToFSL \
           --outputDirectory ${outDir} \
           --outputVolume ${outBase}_DTI_Pos.nii.gz \
           --outputBVectors ${outDir}/${outBase}_DTI_Pos.bvec \
           --outputBValues ${outDir}/${outBase}_DTI_Pos.bval
           
DWIConvert --inputDicomDirectory ${negDir} \
           --conversionMode DicomToFSL \
           --outputDirectory ${outDir} \
           --outputVolume ${outBase}_DTI_Neg.nii.gz \
           --outputBVectors ${outDir}/${outBase}_DTI_Neg.bvec \
           --outputBValues ${outDir}/${outBase}_DTI_Neg.bval
           



# Pull Scan information from the DICOM Header
exampleImage=`ls ${posDir} | grep \.dcm | head -n+1`
echoSpace=`dicom_hdr ${posDir}/$exampleImage | grep "0043 102c" | awk -F"//" '{print $3}' | tr -d '[[:space:]]'`
etl=`dicom_hdr ${posDir}/$exampleImage | grep "0019 10b1" | awk -F"//" '{print $3}' | tr -d '[[:space:]]'`
dwellTime=`echo "$echoSpace $etl" | awk '{print $1 * $2 / 100000}'`
echo "0 1 0 $dwellTime" > ${outDir}/${outBase}_acq_params.txt

# Define scan parameters for Top/Up
exampleImage=`ls ${negDir} | grep \.dcm | head -n+1`
echoSpace=`dicom_hdr ${negDir}/$exampleImage | grep "0043 102c" | awk -F"//" '{print $3}' | tr -d '[[:space:]]'`
etl=`dicom_hdr ${negDir}/$exampleImage | grep "0019 10b1" | awk -F"//" '{print $3}' | tr -d '[[:space:]]'`
dwellTime=`echo "$echoSpace $etl" | awk '{print $1 * $2 / 100000}'`
echo "0 -1 0 $dwellTime" >> ${outDir}/${outBase}_acq_params.txt

nDirs=`fslinfo ${outDir}/${outBase}_DTI_Pos.nii.gz | grep ^dim4 | awk '{print $2}'`

i=0
indx=""
while [ $i -lt $nDirs ]
do
  indx="$indx 1"
  let i+=1
done
echo $indx > ${outDir}/index.txt



#####################################################################
# Extract the b0 images and run topup
#####################################################################

fslroi ${outDir}/${outBase}_DTI_PA.nii.gz ${outDir}/${outBase}_DTI_Pos_b0.nii.gz 0 1
fslroi ${outDir}/${outBase}_DTI_AP.nii.gz ${outDir}/${outBase}_DTI_Neg_b0.nii.gz 0 1
fslmerge -t ${outDir}/${outBase}_DTI_b0.nii.gz ${outDir}/${outBase}_DTI_Pos_b0.nii.gz ${outDir}/${outBase}_DTI_Neg_b0.nii.gz

topup --imain=${outDir}/${outBase}_DTI_b0.nii.gz \
      --datain=${outDir}/${outBase}_acq_params.txt \
      --config=b02b0.cnf \
      --out=${outDir}/${outBase}_TopUp_results \
      --iout=${outDir}/${outBase}_DTI_b0_hifi.nii.gz




#####################################################################
# Now run eddy current correction with replacement
#####################################################################

fslmaths ${outDir}/${outBase}_DTI_b0_hifi.nii.gz -Tmean ${outDir}/${outBase}_DTI_b0_mean.nii.gz
bet ${outDir}/${outBase}_DTI_b0_mean.nii.gz ${outDir}/${outBase}_DTI_b0_brain.nii.gz -m

eddy --imain=${outDir}/${outBase}_DTI_Pos.nii.gz \
     --mask=${outDir}/${outBase}_DTI_b0_brain_mask.nii.gz \
     --acqp=${outDir}/${outBase}_acq_params.txt \
     --index=${outDir}/index.txt \
     --bvecs=${outDir}/${outBase}_DTI_Pos.bvec \
     --bvals=${outDir}/${outBase}_DTI_Pos.bval \
     --topup=${outDir}/${outBase}_TopUp_results \
     --repol \
     --out=${outDir}/${outBase}_DTI_Hifi_Eddy


dtifit -k ${outDir}/${outBase}_DTI_Hifi_Eddy.nii.gz \
       -o ${outDir}/${outBase}_DTI_Scalar \
       -m ${outDir}/${outBase}_DTI_b0_brain_mask.nii.gz \
       -r ${outDir}/${outBase}_DTI_Pos.bvec \
       -b ${outDir}/${outBase}_DTI_Pos.bval

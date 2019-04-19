## Code:
```


#!/bin/bash


#A simple script to take input NIfTI data, reorient to "RIP" via ANTs' "PermuteFlipImageOrientationAxes"
  #12/2017 by Joel Bruss (joel-bruss@uiowa.edu)

outdir=""
outbase=""


function printCommandLine {
  echo "Usage: toRIP.sh -i infile -b outbase -o outdir"
  echo ""
  echo "   where:"
  echo "   -i infile: Input file to reorient"
  echo "   -b outbase: Basename to output file as"
  echo "     *If no argument is given, file will be over-written"
  echo "   -o outdir: Output directory to write to"
  echo "     * If no argument is given, data will be written to input data directory"
  exit 1
}



# Parse Command line arguments
while getopts “hi:b:o:” OPTION
do
  case $OPTION in
    h)
      printCommandLine
      ;;
    i)
      infile=$OPTARG
      ;;
    b)
      tmpoutbase=$OPTARG
      ;;
    o)
      tmpoutdir=$OPTARG
      ;;
    ?)
      echo "ERROR: Invalid option"
      printCommandLine
      ;;
     esac
done

#Determine path to input file
inbase=`dirname $infile`

#Check for output name, directory
  if [[ $outbase == "" ]]; then
    outbase=`basename $infile | awk -F"." '{print $1}'`
  else
    outbase=${tmpoutbase}
  fi

  if [[ $outdir == "" ]]; then
    outdir=${inbase}
  else
    outdir=${tmpoutdir}
  fi

#Check for existence of input file
  if [[ ! -e $infile ]]; then
    echo "No specified input file found. Please check and re-run with the '-i' option."
    exit 1
  fi





#Determine qform-orientation to properly reorient file to RIP (brains) orientation
xorient=`fslhd ${infile} | grep "^qform_xorient" | awk '{print $2}' | cut -c1`
yorient=`fslhd ${infile} | grep "^qform_yorient" | awk '{print $2}' | cut -c1`
zorient=`fslhd ${infile} | grep "^qform_zorient" | awk '{print $2}' | cut -c1`

#Create the three letter orientation code
native_orient=${xorient}${yorient}${zorient}

echo "native orientation = ${native_orient}"

if [ "${native_orient}" != "RIP" ]; then	
  case ${native_orient} in

    #L PA IS
    LPI)
      permflag="0 2 1"
      flipflag="1 0 0"
      ;;
    LPS) 
      permflag="0 2 1"
      flipflag="1 1 0"
      ;;
    LAI) 
      permflag="0 2 1"
      flipflag="1 0 1"
      ;;
    LAS) 
      permflag="0 2 1"
      flipflag="1 1 1"
      ;;

    #R PA IS
    RPI) 
      permflag="0 2 1"
      flipflag="0 0 0"
      ;;
    RPS) 
      permflag="0 2 1"
      flipflag="0 1 0"
      ;;
    RAI) 
      permflag="0 2 1"
      flipflag="0 0 1"
      ;;
    RAS) 
      permflag="0 2 1"
      flipflag="0 1 1"
      ;;

    #L IS PA
    LIP) 
      permflag="0 1 2"
      flipflag="1 0 0"
      ;;
    LIA) 
      permflag="0 1 2"
      flipflag="1 0 1"
      ;;
    LSP) 
      permflag="0 1 2"
      flipflag="1 1 0"
      ;;
    LSA) 
      permflag="0 1 2"
      flipflag="1 1 1"
      ;;

    #R IS PA
    RIA) 
      permflag="0 1 2"
      flipflag="0 0 1"
      ;;
    RSP) 
      permflag="0 1 2"
      flipflag="0 1 0"
      ;;
    RSA) 
      permflag="0 1 2"
      flipflag="0 1 1"
      ;;

    #P IS LR
    PIL) 
      permflag="2 1 0"
      flipflag="1 0 0"
      ;;
    PIR) 
      permflag="2 1 0"
      flipflag="0 0 0"
      ;;
    PSL) 
      permflag="2 1 0"
      flipflag="1 1 0"
      ;;
    PSR) 
      permflag="2 1 0"
      flipflag="0 1 0"
      ;;

    #A IS LR
    AIL) 
      permflag="2 1 0"
      flipflag="1 0 1"
      ;;
    AIR) 
      permflag="2 1 0"
      flipflag="0 0 1"
      ;;
    ASL) 
      permflag="2 1 0"
      flipflag="1 1 1"
      ;;
    ASR) 
      permflag="2 1 0"
      flipflag="0 1 1"
      ;;

    #P LR IS
    PLI) 
      permflag="1 2 0"
      flipflag="1 0 0"
      ;;
    PLS) 
      permflag="1 2 0"
      flipflag="1 1 0"
      ;;
    PRI) 
      permflag="1 2 0"
      flipflag="0 0 0"
      ;;
    PRS) 
      permflag="1 2 0"
      flipflag="0 1 0"
      ;;

    #A LR IS
    ALI) 
      permflag="1 2 0"
      flipflag="1 0 1"
      ;;
    ALS) 
      permflag="1 2 0"
      flipflag="1 1 1"
      ;;
    ARI) 
      permflag="1 2 0"
      flipflag="0 0 1"
      ;;
    ARS) 
      permflag="1 2 0"
      flipflag="0 1 1"
      ;;

    #I LR PA
    ILP) 
      permflag="1 0 2"
      flipflag="1 0 0"
      ;;
    ILA) 
      permflag="1 0 2"
      flipflag="1 0 1"
      ;;
    IRP) 
      permflag="1 0 2"
      flipflag="0 0 0"
      ;;
    IRA) 
      permflag="1 0 2"
      flipflag="0 0 1"
      ;;

    #S LR PA
    SLP) 
      permflag="1 0 2"
      flipflag="1 1 0"
      ;;
    SLA) 
      permflag="1 0 2"
      flipflag="1 1 1"
      ;;
    SRP) 
      permflag="1 0 2"
      flipflag="0 1 0"
      ;;
    SRA) 
      permflag="1 0 2"
      flipflag="0 1 1"
      ;;

    #I PA LR
    IPL) 
      permflag="2 0 1"
      flipflag="1 0 0"
      ;;
    IPR) 
      permflag="2 0 1"
      flipflag="0 0 0"
      ;;
    IAL) 
      permflag="2 0 1"
      flipflag="1 0 1"
      ;;
    IAR) 
      permflag="2 0 1"
      flipflag="0 0 1"
      ;;

    #S PA LR
    SPL) 
      permflag="2 0 1"
      flipflag="1 1 0"
      ;;
    SPR) 
      permflag="2 0 1"
      flipflag="0 1 0"
      ;;
    SAL) 
      permflag="2 0 1"
      flipflag="1 1 1"
      ;;
    SAR) 
      permflag="2 0 1"
      flipflag="0 1 1"
      ;;
  esac

  echo "...Flipping $infile from ${native_orient} by perm=${permflag}, flip=${flipflag} to RIP"

  PermuteFlipImageOrientationAxes 3 ${infile} ${outdir}/${outbase}.nii.gz ${permflag} ${flipflag}

else
  echo "...No need to reorient.  Dataset already in RIP orientation."
fi
```

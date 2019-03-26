#!/bin/bash


############################################
#  Global variables ;-)
source ~/.bashrc >& /dev/null
export tmp=`mktemp /tmp/widgie.XXXXX`
export Mmp=`mktemp /tmp/Widgim.XXXXX`
export Tmp=`mktemp /tmp/Widgie.XXXXX`

dcmdump="/Shared/pinc/sharedopt/apps/dcmtk/Linux/x86_64/3.6.0/bin/dcmdump"
export DCMDICTPATH="/Shared/pinc/sharedopt/apps/dcmtk/Linux/x86_64/3.6.0/share/dcmtk/dicom.dic"


Usage () {
   printf 'Usage: %s -[adplzf] InputDir OutputDir\n' $0
   printf '     a:  Auto run, do not ask user anything.\n'
   printf '     d:  Dry run.  Checks series descriptions vs. internal conversion table.\n'
   printf '     p:  Use Protocol Name instead of Series Description.\n'
   printf '     l:  Enable logging of image/series information.\n'
   printf '     z:  Zip the InputDir into OutputDir/../dicom/sub-${subject}_ses-${session}_site-${site}.zip\n'
   printf '     f:  Force overwriting of preexisting files.\n'
   exit 1
}

#############################################
#  Parse arguments.
parse_args () {
   
   [ $# -lt 2 ] && Usage $0
   AutoRun=0;  DryRun=0;  UseProtocol=0;  Logging=0;  Zipping=0;  FuBar=0;
   while getopts adplzf Opt ; do
      case "$Opt" in
         a)   AutoRun=1         ;;
         d)   DryRun=1          ;;  ## This should disable Logging and Zipping
         p)   UseProtocol=1     ;;
         l)   Logging=1         ;;
         z)   Zipping=1         ;;
         f)   FuBar=1           ;;
         ?)   Usage $0          ;;
      esac
   done
   [ "$Opt" != "0" ] && shift $((OPTIND - 1))
   if [ -d $1 ] ; then InputDir=$1 ; else printf 'Not a directory: %s\n' $1 ; exit; fi
   if [ -d $2 ] ; then destinationDir=$2; else printf 'Not a directory: %s\n' $2 ; exit; fi
   if [ "`basename $destinationDir`" != "nifti" ] ; then 
      printf 'Invalid BIDS destination:  %s\n' $destinationDir
      printf '  Path should end in "/nifti"\n'
      exit 1
   fi
}

parse_cd () {
   
   ## Example filename:
   # 8573-1_8573-1.MR.RESEARCH_Jorge.10.111.20110314.122347.062000.0903505502.dcm
   
   #   find $InputDir -name \*.dcm |\
   #      awk -v FS="/" '{split($NF,a,"."); \
   #                      if(a[5]==1){print a[1],a[3],a[6],a[7],$0,"##"}}'
   ### Some are missing a field in the image name.  
   ### Uncomment this (comment out above)  
   ### Fix a[4]/a[5] -> a[3]/a[4] below where series & image #'s are needed.
   #    find $InputDir -name \*.dcm |\
   #      awk -v FS="/" '{split($NF,a,"."); \
   #                      if(a[4]==1){print a[1],"Denberg",a[3],a[4],$0,"##"}}'

   ##############################################################
   ##############################################################
   ## 7/12/2017 data has new DICOM naming convention
   #  1.2.840.113619.6.410.134398263246678136300912105441504645844-700-412-1a8d85z.dcm
   #  No ID, Researcher, only series & image number.
   #  (0008,1030) LO [DENBURG_MIST]                           #  12, 1 StudyDescription
   #  Alternate naming:  141/63795018/Pilot_2600/63795018_2600_0001.dcm
   
   DCMname=`find $InputDir -name \*.dcm -print -quit`
   StudyName=`$dcmdump -q +P 0008,1030 $DCMname |\
      awk '{gsub("[][]",""); print $3}'`
   
   ## Quick method, if true DICOM naming is used.  Otherwise, troll thru headers :/
   DCFname=`basename $DCMname`
   if [[ $DCFname =~ ([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\-[0-9]*\-[0-9]*\-.*dcm) ]] ; then
      find $InputDir -name \*-1-*.dcm |\
      awk -v FS="/" '{split($NF,a,"-"); \
          if(a[3]==1){print "Name '$StudyName'",a[2],a[3],$0,"##"}}' |\
      sort -n --key=3
   ## Quick method, if IPL naming is used.
   elif [[ $DCFname =~ ([0-9]{5,8}_[0-9]{3,5}_[0-9]{3,6}.dcm) ]] ; then
      find $InputDir \( -name '*_001.dcm' -o -name '*_0001.dcm' -o -name '*_00001.dcm' -o -name '*_000001.dcm' \) |\
      awk -v FS="/" '{gsub(".dcm",""); split($NF,a,"_"); \
          if(a[3]==1){print "Name '$StudyName'",a[2],a[3],$0,"##"}}' |\
      sort -n --key=3
   elif [[ $DCFname =~ (IM-[0-9]{3,5}-[0-9]{3,6}.dcm) ]] ; then
      find $InputDir \( -name '*-001.dcm' -o -name '*-0001.dcm' -o -name '*-00001.dcm' -o -name '*-000001.dcm' \) |\
      awk -v FS="/" '{gsub(".dcm",""); split($NF,a,"-"); \
          if(a[3]==1){print "Name '$StudyName'",a[2],a[3],$0,"##"}}' |\
      sort -n --key=3
   elif [[ $DCFname =~ (MR_[0-9]{3,5}_[0-9]{3,6}.dcm) ]] ; then
      find $InputDir \( -name '*_001.dcm' -o -name '*_0001.dcm' -o -name '*_00001.dcm' -o -name '*_000001.dcm' \) |\
      awk -v FS="/" '{gsub(".dcm",""); split($NF,a,"_"); \
          if(a[3]==1){print "Name '$StudyName'",a[2],a[3],$0,"##"}}' |\
      sort -n --key=3
  
   else
      ## Otherwise, troll thru headers :/  Very slow...
      printf "This is horribly slow, 5-20 minutes. Please be patient\n" > /dev/tty
      printf "Or, create a rule for these filenames and edit this script.\n" > /dev/tty
      find $InputDir -name \*.dcm -exec $dcmdump -q -M +P 0020,0013 +P 0020,0011 +F '{}' \; |\
         awk '{Fname=$NF; getline; gsub("[^[:alnum:]||[:blank:]]","");\
               Inumb=$3;  getline; gsub("[^[:alnum:]||[:blank:]]","");\
               Snumb=$3;\
               if ( Inumb==1 ){print "Name '$StudyName'",Snumb,Inumb,Fname,"##"}}' |\
         sort -n --key=3
   fi
   return 0
}

#### Generate list of scans to choose from, wait for choice
ask_user () {
   # $ScanList is Name, Researcher, Date, Time, Filename, ##
   echo ${ScanList[@]} | sed 's/##/\n/g' |\
      awk 'BEGIN{N=0; print N". Exit"}\
           (P!=$1""$4)&&(NF>0){N++; print N". "$2, $1, $3, $4; P=$1""$4; S=0}\
           {S++}\
           END{print S" series"}'
   
   read -p "Choose a scan to read: " Response
   return $Response
}

getSubID () {
   Scanner=`awk '$1=="(0008,1010)"{print toupper($NF)}' $tmp`
   ### subID ###  May contain Alpha chars
   #(0x0010,0x0010) LO Patient's ID
   ### Iowa3T scans have the ID in the PatientName field ###
   if [[ "$Scanner" == "IOWA3T" || "$Scanner" == "GEHCGEHC" ]] ; then
      SubID=(`awk '$1=="(0010,0010)"{$1=""; $2=""; \
         gsub("[^[:alnum:]]",""); gsub("[[:blank:]]",""); print "sub-"$1}' $tmp`)
   else
      SubID=(`awk '$1=="(0010,0020)"{$1=""; $2=""; \
         gsub("[^[:alnum:]]",""); gsub("[[:blank:]]",""); print "sub-"$1}' $tmp`)
   fi

}

GetSesID () {
   ## MRQID aka "session" ##
   # Needs date and time #
   ## date ##
   #(0008,0020) DA Study Date  YY MM DD
   d=(`awk '$1=="(0008,0020)"{print substr($NF,3,2),substr($NF,5,2),substr($NF,7,2)}' $tmp`)
   date=`printf "%s/%s/%s" ${d[@]}`
   
   ## time ##
   #(0008,0032) TM Acquisition Time  
   #(0008,0030) TM Study Time
   t=(`awk '$1=="(0008,0030)"{print substr($NF,1,2),substr($NF,3,2)}' $tmp`)
   time=`printf "%s:%s" ${t[@]}`
   
   ## Session ID##
   SesID=`printf "ses-%s%s%s%s%s" ${d[@]} ${t[@]}`
   return 0
   
   ## Old style:
   ## MRQID ##
   # Sans scanner # prefix.     input: 2013 11 19 11 03  output: 4657813
   # Minutes into the year, divided by 10.
   mrid=`echo ${d[@]} ${t[@]} | \
      awk '{dt=mktime(D$0" 00"); DoY=strftime("%j",dt);\
            yr=$1-int(int($1/100)*100);\
            print int(((DoY*24+$4)*60+$5)/10)""yr}'`
   SesID=${scanIdPrefix}${mrid}
}

getDesc () {
   ## Cleansing disallowed characters
   if [ $UseProtocol -eq 1 ] ; then
      Desc=`awk '$1=="(0018,1030)"{$1=""; $2="";\
         gsub("[^[:alnum:]]",""); gsub("[[:blank:]]",""); print}' $tmp`
   else # use SeriesDescription
      Desc=`awk '$1=="(0008,103e)"{$1=""; $2="";\
         gsub("[^[:alnum:]]",""); gsub("[[:blank:]]",""); print}' $tmp`
   fi
}

junk () {
   ## Extract site relevant data from multiple dicoms to build
   ## a "site" code lookup table
   
   for FFFF in /bcho/structural/BNC_MR/RBJ188/63364415/PD_001/63364415_001_001.dcm \
      /bcho/structural/BCHO_MR/005/33129605/T1_001/33129605_001_0001.dcm \
      /nca/structural/MR5_GE_AVANTO/3375517/2005.08.20_09.30/0001/MR_0001_0001.dcm \
      /nopoulos/structural/SCA_MR/201809177T/63753918/UNKNOWN_001/63753918_001_0001.dcm \
      /nopoulos/structural/SCA_MR/336/63752718/Pilot_001/63752718_001_0001.dcm \
   ; do
      dcmdump +P 0008,0080 +P 0008,0070 +P 0008,1090 +P 0008,1010 $FFFF |\
      sed 's,].*$,,g;s,\[,,g' |\
      awk '{$1=""; $2=""; gsub("[_/=-]",""); gsub("  ",""); gsub(" ","_"); line=line$0"\t"}END{print line}'
   done
}
getSiteID () {
   StationName=`awk '$1=="(0008,1010)"{$1=""; $2="";\
      gsub("[^[:alnum:]]",""); gsub("[[:blank:]]",""); print}' $tmp`
   case $StationName in
      MRC35267) SiteID="site-00100"   ;;
      MRCVOW0)  SiteID="site-00202"   ;;
      MRC25029) SiteID="site-00101"   ;;
      12341234) SiteID="site-00200"   ;;
      Iowa3T)   SiteID="site-00201"   ;;
      MR10MR10) SiteID="site-01100"   ;;  ## Columbia 0008,0070=GE MEDICAL SYSTEMS 0008,0080=CHONY NYP 3T
      TRIORM5)  SiteID="site-00103"   ;;  ## UIHC SIEMENS TRIO-RM5 syngo MR 2004A 4VA25A
      *)        printf 'Unknown site/scanner: %s  Help!\n' $StationName ; exit ;;
   esac
}

dwi_name () {
   ## Naming spec:  b${Bvalue}v${Directions}-dir${fwd/rev}  ex: acq-b2000v36_dir-rev_dwi
      ## GE Discovery tags:
      ## 0018,9087  DiffusionBValue
      ## 0019,10e0  UserData  #ofDirections?
      ## 0018,5100  PatientPosition
      ## 0018,1312 InPlanePhaseEncodingDirection ? https://www.na-mic.org/wiki/NAMIC_Wiki:DTI:DICOM_for_DWI_and_DTI
      ## 0019,10bb 0019,10bc 0019,10bd (GE) contain...  Start location/direction/vector?
      #####################
      ## Siemens TrioTim tags:
      ## 0019,100c  B_value (may differ across slices)
      ## (0019,100e) FD -0.73263436999999998\-0.17595954000000001\-0.65748404999999996  Gradient Direction
      ##                -0.73263436999999998\-0.17595954000000001\-0.65748404999999996
   ## PhaseEncodingDirection varies by scanner manufacturer & software version 
   Manu=`awk '$1=="(0008,0070)"{print $3}' $tmp`
   Bval=`awk '$1=="(0008,1010)"{print $3}' $tmp`
   case $Manu in 
      GE)  if [[ $StationName == Iowa3T ]] ; then
              echo Whaaaaaaaaat?
           fi
      
      ;;
      *)   ;;
   esac
   
}

getType () {
   
   ## Using dcm2niix, this is all in the file:  
   ## anat || dwi || func || fmap?
   #####  BIDS version 1.1.1    http://bids.neuroimaging.io/bids_spec.pdf
   ## Anatomical types:  T1w T2w T1rho T1map T2map T2star FLAIR FLASH \
   ##   PD PDmap PDT2 inplaneT1 inplaneT2 angio
   ## Diffusion types?  dwi .nii .bval .bvec
   ## Functional types?  bold sbref
   ## fmap:  phase[123..] magnitude[123..]
   ## grep Desc= /tmp/Widgi* | awk '{if($9~/Desc=*/){print $9}else{print $10}}' |\
   ## awk '{gsub("Desc=",""); gsub("[ _/=-]",""); print}' | sort -u |\
   ## awk '{print "      "$0")  WriteDir=$DirStub/unkn;  WriteFile=${FRoot}${ACQ}unk  ;;"}'
   
   DirStub=$destinationDir/$SubID/$SesID
   FRoot=${SubID}_${SesID}_${SiteID}_
   ACQ="acq-${Desc}_"
   TASK="task-${Desc}_"
   ## Deal with possible _run-#  Twisted logic to get a count based on D$Desc
   eval let D$Desc=\$\{D$Desc\}+1
   let RunNum=$(eval echo \$D$Desc)
   Run="run-"${RunNum}"_"
   [ $RunNum -gt 1 ] && ACQ=${ACQ}${Run}
   
   case "$Desc" in
      3DASL)            WriteDir=$DirStub/asl;   WriteFile=${FRoot}${ACQ}asl  ;;
      3DASLNOMUSIC)     WriteDir=$DirStub/asl;   WriteFile=${FRoot}${ACQ}asl   ;;
      3PlaneLocSSFSE)   WriteDir=$DirStub/cal;   WriteFile=${FRoot}${ACQ}loc   ;;
      3PlaneLocFGRE)    WriteDir=$DirStub/cal;   WriteFile=${FRoot}${ACQ}loc   ;;
      3DSAGCUBET2)      WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-sagCUBE_T2w  ;;
      ASSETcalibration) WriteDir=$DirStub/cal;   WriteFile=${FRoot}${ACQ}loc   ;;
      AxSWAN)           WriteDir=$DirStub/orig;  WriteFile=${FRoot}${ACQ}angio  ;;
      AxialT1SPGR)      WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-axiSPGR_T1w   ;;
## usage: /Shared/pinc/sharedopt/apps/freesurfer/Linux/x86_64/6.0.0/bin/
## mri_deface <in volume> <brain template> <face template> <defaced output volume>
      CBF*C[SD]T)          WriteDir=$DirStub/asl;   WriteFile=${FRoot}${ACQ}asl   ;;
      CerebralBloodFlow)  WriteDir=$DirStub/asl;  WriteFile=${FRoot}${ACQ}asl  ;;
      CPJgret1rhoextv3Bn)       WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-Bn_T1rho  ;;
      CPJgret2extv3TE90)        WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-TE90_T1rho  ;;
      CPJgret1rhoextv3TSL0)     WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-TSL0_T1rho  ;;
      CPJgret1rhoextv3TSL90)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-TSL90_T1rho  ;;
      CorCUBET2)        WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corCUBE_T2w  ;;
      CORCUBET2)        WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corCUBE_T2w  ;;
      CORCUBET2PROMO)   WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corCUBEPROMO_T2w  ;;
      CORCubeT2PROMO)   WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-corCUBEPROMO_T2w  ;;
      CORFSPGRBRAVO)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corSPGR_T1w  ;;
      CORFSPGRBRAVOUNTILPROMO) WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corSPGR_T1w  ;;
      CORT2CubePROMO)   WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}acq-corCUBEPROMO_T2w  ;;
      CUBET2CORONAL)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corCUBE_T2w  ;;
      CUBET2SagittalTE65)  WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagCUBE_T2w  ;;
      CUBET2Sagittal)   WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagCUBE_T2w  ;;
      Cal32ChHead)      WriteDir=$DirStub/cal;   WriteFile=${FRoot}${ACQ}cal  ;;
      CalHNSHead)       WriteDir=$DirStub/cal;   WriteFile=${FRoot}${ACQ}cal  ;;
      CorFSPGRBRAVO)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corSPGR_T1w  ;;
      DDT)              WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}${Run}bold ;;
      Diffusion6Direction) WriteDir=$DirStub/dwi;  WriteFile=${FRoot}acq-b1000v6_${Run}dir-fwd_dwi  ;;
      Diffusion12Direction) WriteDir=$DirStub/dwi; WriteFile=${FRoot}acq-b1000v12_${Run}dir-fwd_dwi  ;;
      DKI30Dirb1000)    WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v30_${Run}dir-fwd_dwi  ;;
      DKI30Dirb2000)    WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b2000v30_${Run}dir-fwd_dwi  ;;
      DTI)              WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-bUnkvUnk_${Run}dir-fwd_dwi  ;;
      DTI30Dirb1000)    WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v30_${Run}dir-fwd_dwi  ;;
      DTI30Directions)  WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v30_${Run}dir-fwd_dwi  ;;
      DTI30DIRECTIONSB15) WriteDir=$DirStub/dwi; WriteFile=${FRoot}acq-b1000v30_${Run}dir-fwd_dwi  ;;
      DTI64DIRECTIONS)  WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v64_${Run}dir-fwd_dwi  ;;
      DTIb100045Dir)    WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v45_${Run}dir-fwd_dwi  ;;
      DTIb100045DirNew) WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v45_${Run}dir-fwd_dwi  ;;
      DTIb100050Dir)    WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v50_${Run}dir-fwd_dwi  ;;
      DTIb100060DirMB)  WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v60_${Run}dir-fwd_dwi  ;;
      DTIb180045Dir)    WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1800v45_${Run}dir-fwd_dwi  ;;
      DTIb180045DirNew) WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1800v45_${Run}dir-fwd_dwi  ;;
      DTIb180050Dir)    WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1800v50_${Run}dir-fwd_dwi  ;;
      DTIFLIPPHASE)     WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v6_${Run}dir-fwd_dwi  ;;
      DTIFlipPhase)     WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b1000v6_${Run}dir-fwd_dwi   ;;
      DTIFlipPhaseNew)  WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-b500v6_${Run}dir-fwd_dwi    ;;
      fMRIAxRestingState) WriteDir=$DirStub/func; WriteFile=${FRoot}task-RestAx_${Run}bold  ;;
      FieldMap)         WriteDir=$DirStub/fmap;  WriteFile=${FRoot}fieldmap  ;;
      FieldMapBOLD)     WriteDir=$DirStub/fmap;  WriteFile=${FRoot}fieldmap  ;;
      FILTPHAAxSWAN)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}angio  ;;
      localizer)        WriteDir=$DirStub/cal;   WriteFile=${FRoot}${ACQ}loc  ;;
      LOCALIZER)        WriteDir=$DirStub/cal;   WriteFile=${FRoot}${ACQ}loc  ;;
      LOCFORSPECT)      WriteDir=$DirStub/cal;   WriteFile=${FRoot}${ACQ}loc  ;;
      MBCRYINGBABY1)    WriteDir=$DirStub/func;  WriteFile=${FRoot}_task-CryingBaby_run-1_bold  ;;
      MBCRYINGBABY2)    WriteDir=$DirStub/func;  WriteFile=${FRoot}_task-CryingBaby_run-2_bold  ;;
      MBCRYINGBABY3)    WriteDir=$DirStub/func;  WriteFile=${FRoot}_task-CryingBaby_run-3_bold  ;;
      MBCRYINGBABY4)    WriteDir=$DirStub/func;  WriteFile=${FRoot}_task-CryingBaby_run-4_bold  ;;
      MBDif*B200035DIR)         WriteDir=$DirStub/dwi;  WriteFile=${FRoot}acq-b2000v35_${Run}dir-fwd_dwi  ;;
      MBDif*B200035DIRREVPE)    WriteDir=$DirStub/dwi;  WriteFile=${FRoot}acq-b2000v35_${Run}dir-rev_dwi  ;;
      MBDif*B200036DIR)         WriteDir=$DirStub/dwi;  WriteFile=${FRoot}acq-b2000v36_${Run}dir-fwd_dwi  ;;
      MBDif*B200036DIRREVPE)    WriteDir=$DirStub/dwi;  WriteFile=${FRoot}acq-b2000v36_${Run}dir-rev_dwi  ;;
      MBDif*B200036DIR17)       WriteDir=$DirStub/dwi;  WriteFile=${FRoot}acq-b2000v36_${Run}dir-fwd_dwi  ;;
      MBDif*B200036DIR17REVPE)  WriteDir=$DirStub/dwi;  WriteFile=${FRoot}acq-b2000v36_${Run}dir-rev_dwi  ;;
      MBDiffusionRun198DIR)     WriteDir=$DirStub/dwi;  WriteFile=${FRoot}acq-b3000v98_${Run}dir-fwd_dwi  ;;
      MBTEST)           WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      MBrsfMRI)         WriteDir=$DirStub/func;  WriteFile=${FRoot}task-Rest_dir-fwd_${Run}bold  ;;
      MBrsfMRIREVPE)    WriteDir=$DirStub/func;  WriteFile=${FRoot}task-Rest_dir-rev_${Run}bold  ;;
      MPRAGET1COR)      WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-sagMPRAGE_T1w  ;;
      MPRAGET1Coronal)  WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corMPRAGE_T1w  ;;
      MPRAGET1CoronalTI900)  WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corMPRAGE_T1w  ;;
      MPRAGEPROMO)      WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-corMPRAGEPROMO_T1w  ;;
      MPRObAxISMinIPsp100th100)  WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}angio  ;;
      MSDTISCAPCN)      WriteDir=$DirStub/dwi;   WriteFile=${FRoot}acq-bunkvunk_${Run}dir-unk_dwi  ;;
      MeanEpi135)       WriteDir=$DirStub/other;  WriteFile=${FRoot}acq-MeanEPI_${Run}unk  ;;
      MeanEpi150)       WriteDir=$DirStub/other;  WriteFile=${FRoot}acq-MeanEPI_${Run}unk  ;;
      MeanEpi180)       WriteDir=$DirStub/other;  WriteFile=${FRoot}acq-MeanEPI_${Run}unk  ;;
      MeanEpi246)       WriteDir=$DirStub/other;  WriteFile=${FRoot}acq-MeanEPI_${Run}unk  ;;
      MeanEpi300)       WriteDir=$DirStub/other;  WriteFile=${FRoot}acq-MeanEPI_${Run}unk  ;;
      ## Multiple runs
      NBACKAX)          WriteDir=$DirStub/other;  WriteFile=${FRoot}acq-NBackAX_${Run}unk  ;;  
      NOTDIAG*TGchange*Calibphantom)      WriteDir=$DirStub/mrs;  WriteFile=${FRoot}acq-NDPhantom_mrs  ;;
      NOTDIAG*TGchange*sLASERCalTGPons)   WriteDir=$DirStub/mrs;  WriteFile=${FRoot}acq-NDsLaserCal_roi-pons_mrs  ;;
      NOTDIAG*TGchange*sLASERCalTGCRBLWM) WriteDir=$DirStub/mrs;  WriteFile=${FRoot}acq-NDsLaserCal_roi-crblwm_mrs  ;;
      NOTDIAG*sLASERCRBLWM)        WriteDir=$DirStub/mrs;  WriteFile=${FRoot}acq-NDsLaser_roi-crblwm_mrs  ;;
      NOTDIAG*sLASERPons)          WriteDir=$DirStub/mrs;  WriteFile=${FRoot}acq-NDsLaser_roi-pons_mrs  ;;
      NOTDIAG*waterstability8ml)   WriteDir=$DirStub/orig;  WriteFile=${FRoot}${ACQ}ss  ;;
      ORIG3DSAGCUBET2)    WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagCUBE_T2w  ;;
      ORIGCorCUBET2)      WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-corCUBE_T2w  ;;
      ORIGCORCUBET2)      WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-corCUBE_T2w    ;;
      ORIGCORFSPGRBRAVO)  WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-corSPGR_T1w    ;;
      ORIGCORFSPGRBRAVOUNTILPROMO)  WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-corSPGR_T1w  ;;
      ORIGCORT2CubePROMO)  WriteDir=$DirStub/orig; WriteFile=${FRoot}acq-corCUBEPROMO_T2w  ;;
      ORIGCUBET2CORONAL)  WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-corCUBE_T2w    ;;
      ORIGCUBET2Sagittal) WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagCUBE_T2w    ;;
      ORIGCorFSPGRBRAVO)  WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-corSPGR_T1w    ;;
      ORIGSAGFSPGRBRAVO)  WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagSPGR_T1w    ;;
      ORIGSAGMPRAGEPROMO) WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagMPRAGEPROMO_T1w    ;;
      ORIGSagCUBEFLAIR)   WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagCUBE_FLAIR  ;;
      ORIGSagCUBET2PROMO) WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagCUBEPROMO_T2w    ;;
      PUCORCUBET2)        WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corCUBEpu_T2w  ;;
      PUCORCubeT2PROMO)   WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corCUBEPROMOpu_T2w  ;;
      PUCorFSPGRBRAVO)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corSPGRpu_T1w  ;;
      PUCORFSPGRBRAVO)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corSPGRpu_T1w  ;;
      PUCUBET2CORONAL)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corCUBEpu_T2w  ;;
      PUCUBET2Sagittal)   WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-sagCUBEpu_T2w  ;;
      PUCUBET2SagittalTE65)  WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-sagCUBEpu_T2w  ;;
      PUMPRAGEPROMO)      WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corMPRAGEPROMOpu_T1w ;;
      PUfMRIRestingState)  WriteDir=$DirStub/func;  WriteFile=${FRoot}task-Rest_${Run}bold  ;;
      PUREST)             WriteDir=$DirStub/func;  WriteFile=${FRoot}task-Rest_${Run}bold   ;;
      PUSagCUBEFLAIR)     WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-sagCUBEpu_FLAIR  ;;
      PUSAGFSPGRBRAVO)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-sagSPGRpu_T1w  ;;
      REST)               WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}${Run}bold  ;;
      RLWM)               WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}${Run}bold  ;;
      RestingStatAX)      WriteDir=$DirStub/func;  WriteFile=${FRoot}task-RestAX_${Run}bold  ;;
      SagCUBEFLAIR)       WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagCUBE_FLAIR       ;;
      SagCUBET2PROMO)     WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-sagCUBEPROMO_T2w    ;;
      SAGMPRAGEPROMO)     WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-sagMPRAGEPROMO_T1w  ;;
      SAGFSPGRBRAVO)      WriteDir=$DirStub/orig;  WriteFile=${FRoot}acq-sagSPGR_T1w    ;;
      SCCORCUBET2)        WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corCUBEsc_T2w  ;;
      SCCorFSPGRBRAVO)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-corSPGRsc_T1w  ;;
      SCSAGFSPGRBRAVO)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-sagSPGRsc_T1w  ;;
      SEEPI)              WriteDir=$DirStub/fmap;  WriteFile=${FRoot}acq-SEEPI_dir-AP_spinecho  ;;
      SEEPIALT)           WriteDir=$DirStub/fmap;  WriteFile=${FRoot}acq-SEEPI_dir-PA_spinecho  ;;
      SEEPIREVPE)         WriteDir=$DirStub/fmap;  WriteFile=${FRoot}acq-SEEPI_dir-PA_spinecho  ;;
      SINGLEVOXEL40TEWSRTPutamen)  WriteDir=$DirStub/unkn;  WriteFile=${FRoot}${ACQ}unk  ;;
      SINGLEVOXEL40TEWSLEFT)  WriteDir=$DirStub/unkn;  WriteFile=${FRoot}${ACQ}unk  ;;
      SNR3DTFL)           WriteDir=$DirStub/cal;   WriteFile=${FRoot}${ACQ}TFL    ;;
      ScreenSave)         WriteDir=$DirStub/orig;  WriteFile=${FRoot}${ACQ}ss     ;;
      T1rhoSL10)          WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-SL10_T1rho  ;;
      T1RHOMAP10ms)       WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-SL10_T1rho  ;;
      T1rhoSL10*SCAN)     WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-SL10_T1rho  ;;
      T1rhoSL50)          WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-SL50_T1rho  ;;
      T1RHOMAP60ms)       WriteDir=$DirStub/anat;  WriteFile=${FRoot}acq-SL60_T1rho  ;;
      T2axial)            WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T2w  ;;
      T2MAPGRE)           WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T2map  ;;
      T2PREP3DT2)         WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T2w  ;;
      T2STARMAP)          WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T2star  ;;
      T2TSECOR)           WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T2w  ;;
      T2TSECORFC)         WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T2w  ;;
      T2VAR155B15VERSION) WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T2w  ;;
      TIMINGTASKRun1)     WriteDir=$DirStub/func;  WriteFile=${FRoot}task-Timing_run-1_bold  ;;
      TIMINGTASKRun2)     WriteDir=$DirStub/func;  WriteFile=${FRoot}task-Timing_run-2_bold  ;;
      TIMINGTASKRun3)     WriteDir=$DirStub/func;  WriteFile=${FRoot}task-Timing_run-3_bold  ;;
      TIMINGTASKRun4)     WriteDir=$DirStub/func;  WriteFile=${FRoot}task-Timing_run-4_bold  ;;
      fMRIRestingState)   WriteDir=$DirStub/func;  WriteFile=${FRoot}task-Rest_${Run}bold  ;;
      passiveAX)          WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}${Run}bold  ;;
      sLASERCRBLWM)       WriteDir=$DirStub/mrs;   WriteFile=${FRoot}acq-sLaser_roi-crblwm_mrs  ;;
      sLASERPons)         WriteDir=$DirStub/mrs;   WriteFile=${FRoot}acq-sLaser_roi-pons_mrs  ;;
      waterstability8ml)  WriteDir=$DirStub/orig;  WriteFile=${FRoot}${ACQ}ss  ;;
      *)        WriteDir=$DirStub/unkn;         WriteFile=${FRoot}${ACQ}unk 
         printf '  Unknown scan description %s: %s\n  Help!\n  Edit %s\n' $Desc $ReadFile $0
         printf '      %s)  WriteDir=$DirStub/unkn;  WriteFile=${FRoot}${ACQ}unk  ;;\n' $Desc
         printf '   %s\n' $ReadDir
         #exit
      ;;
   esac
   
}

## BIDS-compliant
## Generates ${WriteDir} and ${WriteFile} variables for use by readCD()
## Need sub-%ID%_ses-%mID%_%Description%.nii.gz
genFileName () {
   ReadFile=(`ls -1 $1 | awk '$1~/\.dcm$/{print; exit}'`)
   if [ ${#ReadFile[@]} -lt 1 ] ; then
      WriteFile="NULL"
      return 1
   fi
   $dcmdump -M $1/$ReadFile | sed 's,].*$,,g;s,\[,,g' > $tmp
   [ "$SubID"  = "" ] && getSubID  $tmp
   [ "$SesID"  = "" ] && getSesID  $tmp
   [ "$SiteID" = "" ] && getSiteID $tmp
   getDesc $tmp
   getType $tmp   ## Creates $WriteDir and $WriteFile strings from $DirStub & 0018,103e SeriesDescription
                ## unless -p is invoked to use 0018,1030 ProtocolName
   Series=`awk '$1=="(0020,0011)"{$1=""; $2=""; \
         gsub("[^[:alnum:]]",""); gsub("[[:blank:]]",""); print}' $tmp`
}

logger () {     ## All info is available in $tmp, just 'awk' it out
   LogDir=`dirname $destinationDir`/log
   LogFile=$LogDir/MRtape.log
   SubLog=$LogDir/${FRoot%_}.log
   [ ! -d $LogDir ] && printf 'Creating log folder %s\n' $LogDir && mkdir -p $LogDir
   if [ ! -e $LogFile ] ; then
      printf 'Creating log file %s\n' $LogFile
      echo -n "" > $LogFile
   fi
   
   if [ "$1" = "END" ] ; then
      echo '#--------------------------------------------------------------------------------' >> ${SubLog}
      echo 'task:dicom_conversion' >> ${SubLog}
      echo 'software: dcm2niix' >> ${SubLog}
      echo 'version: v1.0.20181009' >> ${SubLog}
      echo $StartTime >> ${SubLog}
      date +"end_time:%Y-%m-%dT%H:%M:%S%z" >> ${SubLog}
      echo '' >> ${SubLog}
   fi
   
   [ ! -e $LogFile ] && printf 'Log file %s creation failed.\n' $LogFile && return 1
   ## In theory, "slice order" is coded in the header:
   JSON=$WriteFile".json"
   Modality=${WriteFile##*_}
   awk -v JSON=$JSON \
       '$1=="(0028,0010)"{Ma=$3}\
        $1=="(0028,0011)"{Mb=$3}\
        $1=="(0020,0037)"{n=split($3,T,"\\");           \
            Plane="Unknown";                            \
            if(n==6){                                   \
            for(i=1;i<=n;i++){T[i]=int(T[i]*T[i]+0.5)}  \
            if((T[1]==1)&&(T[6]==1)){Plane="Coronal"}   \
            if((T[1]==1)&&(T[5]==1)){Plane="Axial"}     \
            if((T[2]==1)&&(T[6]==1)){Plane="Sagittal"}  \
            }}\
        $1=="(0008,0032)"{AcqTime=$3}\
        $1=="(0008,0070)"{$1=""; $2=""; gsub(" [ ]+",""); Manuf=$0}\
        $1=="(0008,1090)"{$1=""; $2=""; gsub(" [ ]+",""); Model=$0}\
        ($1=="(0008,103e)")&&(UseProtocol==0){$1=""; $2=""; gsub(" [ ]+",""); SerDesc=$0}\
        ($1=="(0018,1030)")&&(UseProtocol==1){$1=""; $2=""; gsub(" [ ]+",""); SerDesc=$0}\
        $1=="(0018,0020)"{Seq=$3; sub("RM","recovery magnitude",Seq); sub("EP","echo planar",Seq);\
                          sub("GR","gradient echo",Seq); sub("SE","spiin echo",Seq); sub("IR","inversion recovery",Seq)}\
        $1=="(0018,0023)"{Acq=$3}\
        $1=="(0018,0050)"{Thk=$3}\
        $1=="(0018,0080)"{TR=$3; Dstr=Dstr"TR="TR" "}\
        $1=="(0018,0081)"{TE=$3; Dstr=Dstr"TE="TE" "}\
        $1=="(0018,0082)"{TI=$3; if(TI!=0){Dstr=Dstr"TI="TI" "}}\
        $1=="(0018,0083)"{NEX=$3; if(NEX!=1){Dstr=Dstr"with "NEX" excitations "}}\
        $1=="(0018,0088)"{SliceSpacing=$3}\
        $1=="(0018,0087)"{Field=$3"T"}\
        $1=="(0018,0091)"{Eco=$3; if(Eco!=1){Dstr=Dstr"and "Eco" echoes "}}\
        $1=="(0018,1310)"{Matrix=$3; sub("","",Matrix)}\
        $1=="(0018,1314)"{Flip=$3"°"; Dstr=Dstr"flip angle was "Flip}\
        $1=="(0019,105a)"{AcqDuration=int(($3/1e+06)/60)":"($3/1e+06)%60}\
        $1=="(0028,0010)"{Rows=$3}\
        $1=="(0028,0011)"{Cols=$3}\
        $1=="(0028,0030)"{split($3,PixSz,"\\"); Xmm=PixSz[1]; Ymm=PixSz[2]}\
        $1=="(0028,0030)"{FOVx=Rows*Xmm; FOVy=Cols*Ymm; while(FOVx>500){FOVx=FOVx/10.0;FOVy=FOVy/10.0}}\
        END{printf("The '"$Desc"' acquisition parameters were:  ");\
            printf("%s plane %dx%d matrix, %s %dmm thick, ",Plane,Ma,Mb,FOV,Thk);\
            printf("%s %s %s\n",Dstr,"'$SubID'","'$SesID'")}' $tmp |\
            tee -a $Mmp >> $LogFile

#        END{printf("\"TextDescriptionForPubs\": \"%s images were collected on a ",'$Modality') >> JSON; \
#            printf("%s %s scanner %s using a %s %s", Field, Manuf, Model, SerDesc, Acq) >> JSON;\
#            if(Acq="2D"){printf("in the %s plane, ", Plane) >> JSON;}\
#            printf("with the following parameters: acquisition time = %s, ", AcqTTime) >> JSON;\
#            printf("pulse sequence = %s, matrix = %s, FOV = %g x %g, ", Seq, Matrix, FOVx, FOVy ) >> JSON;\
#            printf("voxel size = %g x %g x %g, slice spacing = %g, ", Xmm, Ymm, Thk, SliceSpacing ) >> JSON;\
#            printf("slice order = %s , TR = %d ms, TE = %d ms, ","??",TR,TE,) >> JSON;\
#            printf("TI = %d ms, flip angle = %d degrees, ",TI,Flip) >> JSON;\
#            printf("bandwidth = %s Hz, phase encoding direction = \"\n",,,) >> JSON;\
#            }        
#    Slice order?
#    https://www.nitrc.org/forum/forum.php?thread_id=8599&forum_id=4703
#    https://en.wikibooks.org/wiki/SPM/Slice_Timing
############################# February 2019 Modification ##############################
## "TextDescriptionForPubs": "{image modality} images were collected on a {field strength}T
##  {Manufacturer} scanner ({ManufacturersModelName}) using a {sequence description}
## [<2D only> in the {acquisition plane} plane] 
##    with the following parameters: acquisition time = {###} s, 
##    pulse sequence = {text, e.g., gradient/spin echo, EPI/spiral}, matrix = {###} x {###} 
## [<3D> x {###}], FOV = {###} x {###} 
## [<3D> x {###}], voxel size = {###} x {###} 
## [<3D> x {###}] mm, slice thickness = {###} mm 
## [<2D only>], slice spacing = {###} mm, slice order = {text, e.g., interleaved}, 
## TR = {###} ms, TE = {###} ms, TI = {###} ms, flip angle = {###} degrees, 
## bandwidth = {###} Hz, phase encoding direction = {text, e.g., Anterior-Posterior}"
#(0018,1310) US 96\0\0\96                                #   8, 4 AcquisitionMatrix
#(0018,1310) US 96\0\0\96                                #   8, 4 AcquisitionMatrix
#(0018,1310) US 0\256\256\0                              #   8, 4 AcquisitionMatrix
#(0018,1310) US 64\0\0\64                                #   8, 4 AcquisitionMatrix
#(0018,1310) US 0\288\192\0                              #   8, 4 AcquisitionMatrix
#(0018,1310) US 32\0\0\32                                #   8, 4 AcquisitionMatrix
#(0018,1310) US 0\64\64\0                                #   8, 4 AcquisitionMatrix
#(0018,1310) US 0\256\256\0                              #   8, 4 AcquisitionMatrix
#(0018,1310) US 0\256\256\0                              #   8, 4 AcquisitionMatrix
############################# Before February 2019 ##############################
## The " TIMINGTASKRun4" acquisition parameters were: 
## Axial plane 64x64 matrix, 3.4x3.4mm voxels 4mm thick, 
## TR=2000 TE=30 flip angle was 80°.

###########  Creating/updating a participants.tsv file  ###################
## cd to bids/nifti folder, then:
# printf '%s\t%s\t%s\n' Subject Session Site > participants.tsv
# for sub in sub-* ; do find $sub -name \*nii.gz -exec basename '{}' \; -quit \
#  | awk -v FS="_" '{OFS="\t"; print $1,$2,$3}' >> participants.tsv
# done
}

zipper () {
   ZipDir=`dirname $destinationDir`/dicom
   ZipFile=$ZipDir/${SubID}_${SesID}_${SiteID}.zip
   [ ! -d $ZipDir ]  && printf 'Creating dicom folder %s\n' $ZipDir && mkdir -p $ZipDir
   if [ ! -e $ZipFile ] ; then 
      zip -qr $ZipFile $ReadDir 
   else 
      printf 'Zip file %s exists.\n' $ZipFile
   fi
   [ ! -e $ZipFile ] && printf 'Zip file %s creation failed.\n' $ZipFile && return 1
}

FuBar () {
   if [ -d $1 ] ; then
      [ $FuBar -eq 1 ] && return 0  ## Not wiping the folder
      printf 'Folder %s exists.\n' $1
      printf 'To overwrite data, add the -f option.\n'
      Usage
   fi
   if [[ -f $1  &&  $FuBar -eq 1 ]] ; then
      local D=`dirname $1`
      local F=`basename $1`
      find $D -name $F\* -exec rm -f '{}' \;
   fi
   
}

readCD () {
   ##  logger() loads up $Mmp with scan information
   printf '%s\n' $destinationDir > $Mmp
   # $ScanList is Name, Researcher, Date, Time, Filename, ##
   DirNames=(`echo ${ScanList[@]} | sed 's/##/\n/g' |\
      awk 'BEGIN{N=0}\
           (P!=$1""$4)&&(NF>0){N++; P=$1""$4}\
            N=='$1'{print gensub("/[^/]*$","",1,$NF)}'`)
   
   if [ ${#DirNames[@]} -eq 0 ] ; then
      printf 'No viable DICOM images found in %s\n' $ReadDir
      return 0
   fi
   ## Create BIDS-compliant folder & file names
   ## Dargs="-gert_create_dataset -gert_write_as_nifti -dicom_org -gert_to3d_prefix"
   Dargs="-b y -z i "
   dcm2niix="$HOME/src/dcm2niix/dcm2niix-master/console/dcm2niix"
   mrs2p="/Shared/pinc/sharedopt/apps/nimg_core/ExtractDicomMRS2/ExtractDicomPfile"
   let NNN=1
   for ReadDir in ${DirNames[@]} ; do
      genFileName $ReadDir
      # echo $ReadDir $WriteDir/$WriteFile
      ## First pass, if sub-$(SubID}/ses-${SesID} folder exists notify user.
      [ $NNN -eq 1 ] && [ -d `dirname $WriteDir` ] && FuBar `dirname $WriteDir`
      
      ## Dimon $Dargs $WriteFile -infile_pattern $ReadDir/\*.dcm
      # echo $dcm2niix $Dargs -o $WriteDir -f $WriteFile $ReadDir
      if [ $DryRun -eq 0 ] ; then
         mkdir -p $WriteDir
         if [[ $WriteFile =~ _mrs$ ]] ; then
            FuBar $WriteDir"/"$WriteFile
            $mrs2p -i $ReadDir"/"$ReadFile -o $WriteDir"/"$WriteFile".p"
            ## Make the .json file
            $dcm2niix -b o -o $WriteDir -f $WriteFile $ReadDir |& \
               grep -Ev 'pigz|dcm2niiX|Conversion|Found'
         elif [[ $WriteDir =~ /junk$ ]] ; then
            echo Skipping $Desc
         else
            FuBar $WriteDir"/"$WriteFile
            $dcm2niix $Dargs -o $WriteDir -f $WriteFile $ReadDir |& \
               grep -Ev 'pigz|dcm2niiX|Conversion|Found'
         fi
         [ $Logging == 1 ] && logger
      else
         echo $Series $Desc $WriteFile
      fi
      let NNN++
   done
   ## Dump scan summary to screen
   cat $Mmp
   [ $Logging == 1 ] && logger END
   return 0
}


###################################################################
##                               Main
###################################################################
parse_args $*
StartTime=`date +"start_time:+%Y-%m-%dT%H:%M:%S%z"`

############################################
# Get a list of scans on the CD
ScanList=(`parse_cd`)
#echo ${ScanList[@]} | sed 's/##/\n/g'
if [ $AutoRun -eq 1 ] ; then
   readCD 1
   [ $Zipping == 1 ] && zipper
else
   Response=A
   while [ "$Response" != "0" ] ; do

      ############################################
      # Ask operator to choose which to read.
      ask_user
      [ "$Response" == "0" ] && break
      
      ############################################
      # Process the specified scan onto disk.
      readCD ${Response}
      [ $Zipping == 1 ] && zipper
   done
fi

exit

getSiteID () {
   StationName=`awk '$1=="(0008,1010)"{$1=""; $2="";\
      gsub("[^[:alnum:]]",""); gsub("[[:blank:]]",""); print}' $tmp`
   case $Desc in
      MRC35267) SiteID="site-00100"   ;;
      MRCVOW0)  SiteID="site-00202"   ;;
      MRC25029) SiteID="site-00101"   ;;
      12341234) SiteID="site-00200"   ;;
      Iowa3T)   SiteID="site-00201"   ;;
      *)        printf 'Unknown site/scanner.  Help!\n'; exit ;;
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
   ## awk '{print "      "$0")  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;"}'
   
   DirStub=$destinationDir/$SubID/$SesID
   FRoot=${SubID}_${SesID}_${SiteID}_
   ACQ="acq-${Desc}_"
   TASK="task-${Desc}_"
   case $Desc in
      3DASLNOMUSIC)     WriteDir=$DirStub/asl;   WriteFile=${FRoot}${ACQ}asl   ;;
      3PlaneLocSSFSE)   WriteDir=$DirStub/anat;  WriteFile=${FRoot}loc         ;;
      AxialT1SPGR)      WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T1w   ;;
      CBF*CDT)          WriteDir=$DirStub/asl;   WriteFile=${FRoot}${ACQ}asl   ;;
      CORCUBET2)        WriteDir=$DirStub/anat;  WriteFile=${FRoot}T2w         ;;
      CORCUBET2PROMO)   WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T2w   ;;
      CORFSPGRBRAVO)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}T1w         ;;
      CUBET2CORONAL)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}T2w         ;;
      CUBET2Sagittal)   WriteDir=$DirStub/anat;  WriteFile=${FRoot}${ACQ}T2w   ;;
      Cal32ChHead)      WriteDir=$DirStub/cal;  WriteFile=${FRoot}${ACQ}cal  ;;
      CalHNSHead)       WriteDir=$DirStub/cal;  WriteFile=${FRoot}${ACQ}cal  ;;
      CorFSPGRBRAVO)    WriteDir=$DirStub/anat;  WriteFile=${FRoot}T1w         ;;
      DDT)              WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold ;;
      DKI30Dirb1000)    WriteDir=$DirStub/dwi;  WriteFile=${FRoot}${ACQ}dwi  ;;
      DKI30Dirb2000)    WriteDir=$DirStub/dwi;  WriteFile=${FRoot}${ACQ}dwi  ;;
      DTIFlipPhase)     WriteDir=$DirStub/dwi;  WriteFile=${FRoot}${ACQ}dwi  ;;
      DTIb100045Dir)    WriteDir=$DirStub/dwi;  WriteFile=${FRoot}${ACQ}dwi  ;;
      DTIb180045Dir)    WriteDir=$DirStub/dwi;  WriteFile=${FRoot}${ACQ}dwi  ;;
      FieldMap)         WriteDir=$DirStub/fmap;  WriteFile=${FRoot}  ;;
      LOCFORSPECT)      WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MBCRYINGBABY1)    WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      MBCRYINGBABY2)    WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      MBCRYINGBABY3)    WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      MBCRYINGBABY4)    WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      MBDiffB200035DIR) WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MBDiffB200035DIRREVPE)    WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MBDiffB200036DIR)         WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MBDiffB200036DIRREVPE)    WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MBDiffusion)              WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MBDiffusionRun198DIR)     WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MBTEST)           WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MBrsfMRI)         WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      MBrsfMRIREVPE)    WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      MPRAGEPROMO)      WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MSDTISCAPCN)      WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MeanEpi135)       WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MeanEpi180)       WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MeanEpi246)       WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      MeanEpi300)       WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NBACKAX)          WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      NOTDIAGNOSTICTGchange10.320.1390Calibphantom)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICTGchange10.790.0590Calibphantom)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICTGchange11.220.0890Calibphantom)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICTGchange11.590.0690Calibphantom)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICTGchange14.470.21sLASERCalTGPons) WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICTGchange8.720.86sLASERCalTGPons)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICTGchange8.930.50sLASERCalTGPons)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICTGchange9.120.17sLASERCalTGCRBLWM)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICTGchange9.640.25sLASERCalTGCRBLWM)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICTGchange9.801.09sLASERCalTGCRBLWM)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICsLASERCRBLWM)        WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICsLASERPons)          WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      NOTDIAGNOSTICwaterstability8ml)   WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      ORIGCORCUBET2)      WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      ORIGCORFSPGRBRAVO)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      ORIGCUBET2CORONAL)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      ORIGCUBET2Sagittal) WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      ORIGCorFSPGRBRAVO)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      ORIGSAGMPRAGEPROMO) WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      ORIGSagCUBEFLAIR)   WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      ORIGSagCUBET2PROMO) WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      REST)               WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      RLWM)               WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      RestingStatAX)      WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      SAGMPRAGEPROMO)     WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      SEEPI)              WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      SEEPIALT)           WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      SEEPIREVPE)         WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      SNR3DTFL)           WriteDir=$DirStub/fmap;  WriteFile=${FRoot}  ;;
      SagCUBEFLAIR)       WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      SagCUBET2PROMO)     WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      ScreenSave)         WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      T1rhoSL10)          WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      T1rhoSL10*SCAN)     WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      T1rhoSL50)          WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      TIMINGTASKRun1)     WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      TIMINGTASKRun2)     WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      TIMINGTASKRun3)     WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      TIMINGTASKRun4)     WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      fMRIRestingState)   WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      passiveAX)          WriteDir=$DirStub/func;  WriteFile=${FRoot}${TASK}bold  ;;
      sLASERCRBLWM)       WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      sLASERPons)         WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      waterstability8ml)  WriteDir=$DirStub/;  WriteFile=${FRoot}  ;;
      )
      ;;
   esac
   
}

## BIDS-compliant
## Generates ${WriteDir} and ${WriteFile} variables for use by readCD()
## Need sub-%ID%_ses-%mID%_%Description%.nii.gz
genFileName () {
   ReadFile=(`ls -1 $1 | awk '$1~/\.dcm$/{print; exit}'`)
   if ${#ReadFile[@]} -lt 1 ; then
      WriteFile="NULL"
      return 1
   fi
   $dcmdump -M $1/$ReadFile | sed 's,].*$,,g;s,\[,,g' > $tmp
   getSubID $1
   getSesID $1
   getSiteID $1
   getDesc $1
   getType $1   ## Creates $WriteDir and $WriteFile strings from $DirStub
}

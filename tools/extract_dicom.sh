#! /bin/bash

# =============================================================================
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <http://unlicense.org>
# =============================================================================

# Help ------------------------------------------------------------------------
function Usage {
    cat <<USAGE

`basename $0` initializes a data structure for a neuroimaging project.

Usage:
`basename $0`  -r researcher_directory
                        -p project_name
                        -g group_permission
                        -h <help>

Example:
  bash $0 -r /Shared/koscikt_scratch -p example_data

Arguments:
  -r researcher_directory  The full directory listing in which to create the
                           project data structure.
  -p project_name          A unique name for the imaging project, must not
                           exist.
  -g group_permission      A string indicating the group to assign directory
                           ownership and access
  -s subject_id            A unique subject identifier to be used consistently
                           within a study (and across studies if possible)
                           e.g., ursi
  -n session_id            A unique session identifier, if numeric should
			   preferrably automatically sort by date.
                           e.g, mrqid, or date string (YYYYMMDD) 20180906
Optional:
  -t tsv_file_idx          Full path to the tab-separated file that contains the
                           index to interpret the DICOM structure and enable
                           extraction of files.  If not specified, the master
                           index file will be used and copied for each
                           subject/session.
     -directory        ${researcherDir}/${project}/scripts/dicom_idx/
     -master           master_dicom-idx.tsv
     -subject/session  sub-{id}_ses-${session}_dicom-idx.tsv
       -column 1: scan directory inside zip file, e.g. /SCAN/1/DICOM,
       -column 2: destination folder: anat, dwi, fmap, func, mrs, other, rho
       -column 3: field name, e.g., mod, acq, task, roi, rec, run, echo
       -column 4: field value, e.g., [${mod}] T1w, [${task}] rest, etc.
  -x scratch_directory     Full directory path to scratch folder to temporarily
                           extract DICOM *.zip folders
                           
  -h help

USAGE
    exit 1
}


# Parse inputs ----------------------------------------------------------------
while getopts "r:p:g:s:n:t:h" option
do
case "${option}"
in
  r) # researcher_directory
    researcherRoot=${OPTARG}
    ;;
  p) # project_name
    projectName=${OPTARG}
    ;;
  g) # group_permissions
    groupOwn=${OPTARG}
    ;;
  s) # subject_id
    subject=${OPTARG}
    ;;
  n) # session_id
    session=${OPTARG}
    ;;
  t) # tsv-file
    idxFile=${OPTARG}
    ;;
  x) # scratch_directory
    scratch=${OPTARG}
    ;;
  h) # help
    Usage >&2
    exit 0
    ;;
  *) # unknown options
    echo "ERROR: Unrecognized option -$OPT $OPTARG"
    exit 1
    ;;
esac
done

# =============================================================================
# convert DICOM to NIFTI and format to standard
# =============================================================================

nimg_core=/Shared/nopoulos/nimg_core

## Extract *.zip file to scratch directory ------------------------------------
defScratch=${researcherRoot}/${projectName}/scratch
if [[ -v scratch ]]; then
  echo "Using specified scratch directory: ${scratch}"
else
  scratch=${defScratch}
  echo "Setting scratch directory to default: ${scratch}"
fi
mkdir -p ${scratch}

unzip ${researcherRoot}/${projectName}/dicom/sub-${subject}_ses-${session}.zip -d ${scratch}

## locate tsv index file --------------------------------------------------------
idxMaster=${researcherRoot}/${projectName}/scripts/dicom_idx/master_dicom_idx.tsv
if [[ -v idxFile ]]; then
  echo "Using specified index file: ${idxFile}"
else
  idxFile=${researcherRoot}/${projectName}/scripts/dicom_idx/sub-${subject}_ses-${session}.tsv
  cp ${idxMaster} ${idxFile}
  echo "Using master index file and copying to: ${scratch}"
fi

## Convert DICOM to NIFTI -----------------------------------------------------
while IFS=$'\t' read -r -a idx; do
  datadir=${idx[0]}
  savedir=${idx[1]}

  if [ ${savedir} != NA ]; then
    savedir=${researcherRoot}/${projectName}/nifti/${subject}/${session}/${idx[1]}
    mkdir -p ${savedir}

    mod=${idx[2]}
## Convert Anatomical ---------------------------------------------------------
    ### T1 
    if [[ "${mod}" =~ ^(T1w|t1w|T1|t1|T1map|t1map|T2w|t2w|T2|t2|T2map|t2map|T1rho|T1Rho|t1rho|T2star|t2star|SWE|swe|SWAN|swan|FLAIR|Flair|flair|FLASH|Flash|flash|PD|pd|PDmap|PDMap|pdmap|PDT2|PDt2|pdt2|inplaneT1|inplanet1|inplaneT2|inplaneT2|angio|ANGIO|Angio)$ ]]; then
      if [[ "${mod}" =~ ^(T1w|t1w|T1|t1)$ ]]; then
        mod=T1w
      elif [[ "${mod}" =~ ^(T2w|t2w|T2|t2)$ ]]; then
        mod=T2w
      elif [[ "${mod}" =~ ^(T1rho|T1Rho|t1rho)$ ]]; then
        mod=T1rho
      elif [[ "${mod}" =~ ^(T1map|t1map)$ ]]; then
        mod=T1map
      elif [[ "${mod}" =~ ^(T2map|t2map)$ ]]; then
        mod=T2map
      elif [[ "${mod}" =~ ^(T2star|t2star|SWE|swe|SWAN|swan)$ ]]; then
        mod=T2star
      elif [[ "${mod}" =~ ^(FLAIR|Flair|flair)$ ]]; then
        mod=FLAIR
      elif [[ "${mod}" =~ ^(FLASH|Flash|flash)$ ]]; then
        mod=FLASH
      elif [[ "${mod}" =~ ^(PD|pd)$ ]]; then
        mod=PD
      elif [[ "${mod}" =~ ^(PDmap|PDMap|pdmap)$ ]]; then
        mod=PDmap
      elif [[ "${mod}" =~ ^(PDT2|PDt2|pdt2)$ ]]; then
        mod=PDT2
      elif [[ "${mod}" =~ ^(inplaneT1|inplanet1)$ ]]; then
        mod=inplaneT1
      elif [[ "${mod}" =~ ^(inplaneT2|inplaneT2)$ ]]; then
        mod=inplaneT2
      elif [[ "${mod}" =~ ^(angio|ANGIO|Angio)$ ]]; then
        mod=angio
      else
        echo "Unknown anatomical type: ${mod}"
        exit 1
      fi
      fname=sub-${subject}_ses-${session}
      for i in $(seq 3 ${#idx[@]}); do
          if [ $((i%2)) -eq 1 ]; then
            fname="${fname}_${idx[${i}]}"
          else
            fname="${fname}-${idx[${i}]}"
          fi
      done
      fname="${fname}${mod}"
      if [ -d ${scratch}/${datadir} ]; then
        dcm2niix -b Y -f ${fname} -o ${savedir} ${scratch}/${datadir}
      fi
    fi

## Convert Diffusion ----------------------------------------------------------
    if [[ "${mod}" =~ ^(dwi)$ ]]; then
      fname=sub-${subject}_ses-${session}
      for i in $(seq 3 ${#idx[@]}); do
          if [ $((i%2)) -eq 1 ]; then
            fname="${fname}_${idx[${i}]}"
          else
            fname="${fname}-${idx[${i}]}"
          fi
      done
      fname="${fname}${mod}"
      if [ -d ${scratch}/${datadir} ]; then
        dcm2niix -b Y -f ${fname} -o ${savedir} ${scratch}/${datadir}
      fi
    fi

## Convert Spin Echo Field Maps ------------------------------------------------
    if [[ "${mod}" =~ ^(SE|spinecho)$ ]]; then
      fname=sub-${subject}_ses-${session}_spinecho
      for i in $(seq 3 ${#idx[@]}); do
          if [ $((i%2)) -eq 1 ]; then
            fname="${fname}_${idx[${i}]}"
          else
            fname="${fname}-${idx[${i}]}"
          fi
      done
      fname=${fname::-1}
      if [ -d ${scratch}/${datadir} ]; then
        dcm2niix -b Y -f ${fname} -o ${savedir} ${scratch}/${datadir}
      fi
    fi

## Convert Functional ---------------------------------------------------------
    if [[ "${mod}" =~ ^(func|bold)$ ]]; then
      fname=sub-${subject}_ses-${session}
      for i in $(seq 3 ${#idx[@]}); do
          if [ $((i%2)) -eq 1 ]; then
            fname="${fname}_${idx[${i}]}"
          else
            fname="${fname}-${idx[${i}]}"
          fi
      done
      fname="${fname}bold"

      if [ -d ${scratch}/${datadir} ]; then
        source ~/sourcefiles/afni_source.sh
        source ~/sourcefiles/fsl_source.sh
        source ~/sourcefiles/gdcm_source.sh
        export FREESURFER_HOME=/Shared/pinc/sharedopt/apps/freesurfer/Linux/x86_64/6.0.0
        source ${FREESURFER_HOME}/FreeSurferEnv.sh
        ${nimg_core}/GE_dcm_to_nii.sh -i ${scratch}/${datadir} -o ${savedir} -b ${fname} -B
        #rm ${savedir}/*.txt
        rm ${savedir}/*tmp.nii.gz
        rm ${savedir}/*disDacq.nii.gz
      fi
    fi

## Convert Spectroscopy -------------------------------------------------------
    if [[ "${mod}" =~ ^(mrs|MRS)$ ]]; then
      fname=sub-${subject}_ses-${session}_MRS
      for i in $(seq 3 ${#idx[@]}); do
          if [ $((i%2)) -eq 1 ]; then
            fname="${fname}_${idx[${i}]}"
          else
            fname="${fname}-${idx[${i}]}"
          fi
      done
      fname=${fname::-1}

      if [ -d ${scratch}/${datadir} ]; then
#        source ~/sourcefiles/itk_source.sh
#        source ~/sourcefiles/ExtractDicomMRS_source.sh
#        ExtractDicomPfile ****
        dcm2niix -b Y -f ${fname} -o ${savedir} ${scratch}/${datadir}
      fi
    fi

  fi
done < "${idxFile}"

rm -r ${scratch}/*




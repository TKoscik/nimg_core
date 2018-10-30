# Code Specifications

For BASH scripts/functions

To enhance useability and enforce some consistency across scripts and functions
please follow these guidelines when writing shell scripts.

## Licence
All scripts should be written using "The Unlicense" https://choosealicense.com/licenses/unlicense/  
By uploading to the nimg_core, you are automatically under this licence unless otherwise noted in the preamble to your script/function and the proper licensing criteria are followed for those specific files.

## Script/Function Operators
All scripts and function should be designed to follow and benefit from the data specifications as laid out here: https://github.com/TKoscik/nimg_core/blob/master/data_structure_specifications.md  
Everything should be designed from the ground up to be user friendly and transparent in what the functions/scripts do.  
Documentation included as callable output is mandatory, and inline documentaion is strongly encouraged.

### Operators [as required / reserved]
```
-r ${researcherRoot}
-p ${projectName}
-s ${subjectID}
-n ${sessionID}
-h ${help}
```

### Example Usage 
```
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
```

### Example Input Parser
```
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
```

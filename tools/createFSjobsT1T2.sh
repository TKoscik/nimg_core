
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

`basename $0` creates freesurfer shell scripts to submit to cluster with appropriate template TMPL file in pwd 

Usage:
`basename $0`  -r researcher_directory
                        -p project_name
                        -h <help>

Example:
  bash $0 -r /Shared/nopoulos -p sca_pilot

Arguments:
  -r researcher_directory  The full root directory the imaging project resides
  -p project_name          A unique name of the imaging project where the BFC T1s and T2s reside
  -h help

USAGE
    exit 1
}

# Parse input operators -------------------------------------------------------
while getopts "r:p:o:h" option
do
case "${option}"
in
  r) # researcher_directory
    researcherRoot=${OPTARG}
    ;;
  p) # project_name
    projectName=${OPTARG}
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

for i in ${researcherRoot}/${projectName}/derivatives/anat/[a-zA-Z0-9]*/[a-zA-Z0-9]* ; do 
 T1bc=`find $i -name \*T1w_acq-MPRAGE_prep-bc.nii.gz`
 T2bc=`find $i -name \*T2w_acq-CUBE_prep-bc.nii.gz`
 SUBJECTID=$(echo $i |awk -F/ '{print $5}')
 MRQID=$(echo $i |awk -F/ '{print $6}')
 if [ "$T2bc" == "" ] ; then
   echo "Error:  No T2 exists for ${SUBJECTID}/${MRQID} use T1 only scripts"
 else 
 mkdir ${researcherRoot}/${projectName}/derivatives/anat/fsurf
 SUBJECTID=$(echo $i |awk -F/ '{print $5}')
 MRQID=$(echo $i |awk -F/ '{print $6}')
 SHSCRIPTtmp=$(pwd)/${projectName}_FSwbcv6T1T2_${SUBJECTID}_${MRQID}_tmp.sh
 SHSCRIPT=$(pwd)/${projectName}_FSwbcv6T1T2_${SUBJECTID}_${MRQID}.sh
 PBSSCRIPT=$(pwd)/${projectName}_FSwbcv6T1T2_${SUBJECTID}_${MRQID}.pbs.sh
 cp TMPLT1T2FSv60.sh.in ${SHSCRIPTtmp}
 cat ${SHSCRIPTtmp} | sed "s#BASEPATH#${BASEPATH}#g" | sed "s#SUBJECTID#${SUBJECTID}#g" | sed "s#MRQID#${MRQID}#g" | sed "s#T1bc#${T1bc}#g" | sed "s#T2bc#${T2bc}#g" >> ${SHSCRIPT}
 rm ${SHSCRIPTtmp}
 echo "#!/bin/bash
 ${SHSCRIPT}" >> ${PBSSCRIPT}
 fi
done

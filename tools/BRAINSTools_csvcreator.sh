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
`basename $0` creates a csv file to feed into BRAINSTools.
Usage:
`basename $0`  -r researcher_directory
                        -p project_name
			-o full path output csv name of file desired	
                        -h <help>
Example:
  bash $0 -r /Shared/nopoulos -p sca_pilot -o /Shared/axelsone_scratch/sca.csv
Arguments:
  -r researcher_directory  The full root directory the imaging project resides
  -p project_name          A unique name of the imaging project where the nifti directory
  			   reside
  -o outputFile 	   The full path to the desired output csv file with name desired
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
  o) # project_name
    outputFile=${OPTARG}
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

for i in ${researcherRoot}/${projectName}/nifti/[a-zA-Z0-9]*/[a-zA-Z0-9]*/anat ; do 
T1=`find $i -name \*T1w_acq-MPRAGE.nii.gz`
T2=`find $i -name \*T2w_acq-CUBE.nii.gz`
info=(`echo $i | awk '{gsub("/"," "); print $0}'`)
if [ "$T2" == "" ] ; then
printf \"${projectName}\",\"${info[4]}\",\"${info[5]}\",\"\{\'T1-30\'\:\[\'$T1\'\]\}\"'\n'
else
   printf \"${projectName}\",\"${info[4]}\",\"${info[5]}\",\"\{\'T1-30\'\:\[\'$T1\'\]\,\'T2-30\'\:\[\'$T2\'\]\}\"'\n'
fi
done > ${outputFile}

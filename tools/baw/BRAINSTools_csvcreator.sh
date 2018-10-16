#! /bin/bash
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

for i in ${researcherRoot}/${projectName}/nifti/[a-zA-Z0-9]*/[a-zA-Z0-9]*/orig ; do 
T1=`find $i -name \*T1w_acq-MPRAGE.nii.gz`
T2=`find $i -name \*T2w_acq-CUBE.nii.gz`
info=(`echo $i | awk '{gsub("/"," "); print $0}'`)
if [ "$T2" == "" ] ; then
printf \"${projectName}\",\"${info[4]}\",\"${info[5]}\",\"\{\'T1-30\'\:\[\'$T1\'\]\}\"'\n'
else
   printf \"${projectName}\",\"${info[4]}\",\"${info[5]}\",\"\{\'T1-30\'\:\[\'$T1\'\]\,\'T2-30\'\:\[\'$T2\'\]\}\"'\n'
fi
done > ${outputFile}

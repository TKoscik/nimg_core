#! /bin/bash

# Help ------------------------------------------------------------------------
function Usage {
    cat <<USAGE

`basename $0` initializes a data structure for a neuroimaging project.

Usage:
`basename $0`
    -a t1img
    -b t2img
    -m brain_mask
    -o output_directory
    -h <help>

Example:
  bash $0 \
    -a /researcher/project/nifti/anat/sub-subject_ses-session_T1w.nii.gz \
    -b /researcher/project/nifti/anat/sub-subject_ses-session_T2w.nii.gz \
    -m /researcher/project/derivatives/anat/prep/sub-subject_ses-session_T1w_prep-bex0.nii.gz \
    -o /researcher/project/derivatives/anat/prep

Arguments:
  -a t1img               Full directory listing to T1 image, nii.gz
  -b t2img               Full directory listing to T2 image, nii.gz
  -m brain_mask		 Full directory listing to brain mask
  -o output_directory    location to save result
  -h help

USAGE
    exit 1
}

# Parse inputs ----------------------------------------------------------------
while getopts "a:b:m:o:h" option
do
case "${option}"
in
  a) # T1w Image
    t1img=${OPTARG}
    ;;
  b) # T2w Image
    t2img=${OPTARG}
    ;;
  m) # brain mask
    brainmask=${OPTARG}
    ;;
  o) #savedir
    savedir=${OPTARG}
    ;;
  k) #smoothing kernel size
    smoothKernel=${OPTARG}
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
# Debias T1 [T2]
# =============================================================================

# set up output names
mkdir -p ${savedir}

t1out=$(echo "${t1img}" | grep -oP 'sub-\S+_')
t2out=$(echo "${t2img}" | grep -oP 'sub-\S+_')

if [[ ! -v smoothKernel ]]; then
  smoothKernel=5
fi 

# Form sqrt(T1w*T2w), mask this and normalise by the mean ---------------------
fslmaths ${t1img} -mul ${t2img} -abs -sqrt ${savedir}/temp_t1mult2.nii.gz -odt float

fslmaths ${savedir}/temp_t1mult2.nii.gz -mas ${scandir}/${brainmask} ${savedir}/temp_t1mult2_brain.nii.gz

meanbrainval=`fslstats ${savedir}/temp_t1mult2_brain.nii.gz -M`

fslmaths ${savedir}/temp_t1mult2_brain.nii.gz -div ${meanbrainval} ${savedir}/temp_t1mult2_brain_norm.nii.gz

# Smooth the normalised sqrt image, using within-mask smoothing : s(Mask*X)/s(Mask) -------------------
fslmaths ${savedir}/temp_t1mult2_brain_norm.nii.gz -bin -s ${smoothKernel} ${savedir}/temp_smooth_norm.nii.gz
fslmaths ${savedir}/temp_t1mult2_brain_norm.nii.gz -s ${smoothKernel} -div ${savedir}/temp_smooth_norm.nii.gz ${savedir}/temp_t1mult2_brain_norm_s${smoothKernel}.nii.gz

# Divide normalised sqrt image by smoothed version (to do simple bias correction) ---------------
fslmaths ${savedir}/temp_t1mult2_brain_norm.nii.gz -div ${savedir}/temp_t1mult2_brain_norm_s${smoothKernel}.nii.gz ${savedir}/temp_t1mult2_brain_norm_mod.nii.gz

# Create a mask using a threshold at Mean - 0.5*Stddev, with filling of holes to remove any non-grey/white tissue.
STD=`fslstats ${savedir}/temp_t1mult2_brain_norm_mod.nii.gz -S`
MEAN=`fslstats ${savedir}/temp_t1mult2_brain_norm_mod.nii.gz -M`
Lower=`echo "$MEAN - ($STD * 0.5)" | bc -l`

fslmaths ${savedir}/temp_t1mult2_brain_norm_mod.nii.gz -thr ${Lower} -bin -ero -mul 255 ${savedir}/temp_t1mult2_brain_norm_mod_mask.nii.gz

${FSLDIR}/bin/cluster -i ${savedir}/temp_t1mult2_brain_norm_mod_mask.nii.gz -t 0.5 -o ${savedir}/temp_cl_idx
MINMAX=`fslstats ${savedir}/temp_cl_idx.nii.gz -R`
MAX=`echo "${MINMAX}" | cut -d ' ' -f 2`
fslmaths -dt int ${savedir}/temp_cl_idx -thr ${MAX} -bin -mul 255 ${savedir}/temp_t1mult2_brain_norm_mod_mask.nii.gz

# Extrapolate normalised sqrt image from mask region out to whole FOV
fslmaths ${savedir}/temp_t1mult2_brain_norm.nii.gz -mas ${savedir}/temp_t1mult2_brain_norm_mod_mask.nii.gz -dilall ${savedir}/temp_bias_raw.nii.gz -odt float
fslmaths ${savedir}/temp_bias_raw.nii.gz -s ${smoothKernel} ${savedir}/biasT1T2_Field.nii.gz

# Use bias field output to create corrected images
fslmaths ${t1img} -div ${savedir}/biasT1T2_Field.nii.gz ${savedir}/biasT1T2_T1w.nii.gz
fslmaths ${t2img} -div ${savedir}/biasT1T2_Field.nii.gz ${savedir}/biasT1T2_T2w.nii.gz

rm ${savedir}/temp*


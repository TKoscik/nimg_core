#! /bin/bash

# Resample Free surfer variables

# Initialize Freesurfer and Set Subject Dircetory
subjectdir=/Shared/nopoulos/freesurfer/KIDSHD_v6_N4_2018/FreeSurfer_Subjects

export FREESURFER_HOME=/Shared/pinc/sharedopt/apps/freesurfer/Linux/x86_64/6.0.0
source ${FREESURFER_HOME}/FreeSurferEnv.sh
export SUBJECTS_DIR=${subjectdir}

# Input variables to adjust
sjxls=/Shared/nopoulos/freesurfer/scripts/KIDSHD_v6_2017/N4/surf_surf/kidshd.txt
target=fsaverage
fwhm=5
val[0]=thickness
val[1]=area
hemi[0]=lh
hemi[1]=rh

# Set Save Directory
#savedir=/Shared/nopoulos/freesurfer/denburgt1only_fsurf/subject_resample_s5
savedir=/Shared/nopoulos/freesurfer/kidshd_fsurf/subject_resample_s5

for subject in $(cat ${sjxls}); do
for i in {0..1}; do
for j in {0..1}; do
echo ${subject}
echo ${hemi[${i}]}
echo ${val[${j}]}
mri_surf2surf \
--srcsubject ${subject} \
--hemi ${hemi[${i}]} \
--srcsurfval ${val[${j}]} \
--src_type curv \
--fwhm-trg ${fwhm} \
--trgsubject ${target} \
--tval ${savedir}/${subject}.${val[${j}]} \
--tfmt curv
done
done
done

# Within-modality average
## Output:
```
${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-avg.nii.gz
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-resample.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
input_dir=derivatives/anat/prep/${subject}/${session}/     # location relative to researcher/project/
which_imgs[0]=sub-${subject}_ses-${session}_run-1_T1w_prep-acpc.nii.gz
which_imgs[1]=sub-${subject}_ses-${session}_run-2_T1w_prep-acpc.nii.gz
output_name=sub-${subject}_ses-${session}_T1w_prep-avg.nii.gz

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_within_modality_average' >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/sub-${subject}_ses-${session}_run-1_T1w_prep-acpc.nii.gz >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/sub-${subject}_ses-${session}_run-2_T1w_prep-acpc.nii.gz >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

# Find smallest pixel dimensions in each direction
pixdim[0]=1000 # arbitrarily large value (must be bigger than actual input)
pixdim[1]=1000
pixdim[2]=1000
for i in ${which_imgs[@]}; do
  IFS='x' read -r -a pixdimTemp <<< $(PrintHeader ${researcher}/${project}/${input_dir}/${i} 1)
  for j in {0..2}; do
    if (( $(echo "${pixdimTemp[${j}]} < ${pixdim[${j}]}" | bc -l) )); then
      pixdim[${j}]=${pixdimTemp[${j}]} 
    fi
  done
done

# Resample images to highest resolution
rs_imgs=()
for i in ${which_imgs[@]}; do
  new_prefix=$(basename -- "$i")
  new_prefix="${oname%_*}"
  rs_imgs+=${new_prefix}_prep-resample.nii.gz # append to new array for next step
  ResampleImage 3 ${researcher}/${project}/${input_dir}/${i} ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${new_prefix}_prep-resample.nii.gz 0 0
done

# create unbiased average of images
buildtemplateparallel.sh \
  -d 3 /
  -o {researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${output_name}_prep-avg.nii.gz \
  ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${rs_imgs}

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
## Citations:
### ANTs buildtemplateparallel.sh
>Avants BB, Yushkevich P, Pluta J, Minkoff D, Korczykowski M, Detre J, & Gee JC. (2010). The optimal template effect in hippocampus studies of diseased populations. Neuroimage, 49(3), 2957-2466. DOI:10.1016/j.neuroimage.2009.09.062 PMCID:PMC2818274

>Avants BB, Tustison NJ, Song G, Cook PA, Klein A, & Gee JC. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. Neuroimage, 54(3), 2033-2044. DOI:10.1016/j.neuroimage.2010.09.025 PMCID:PMC3065962

### ANTs Registration
>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

>Avants BB, Tustison NJ, Song G, Cook PA, Klein A, & Gee JC. (2011). A reproducible evaluation of ANTs similarity metric performance in brain image registration. Neuroimage, 54(3), 2033-2044. DOI:10.1016/j.neuroimage.2010.09.025 PMCID:PMC3065962

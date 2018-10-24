# Denoising  
Denoise an image using a spatially adaptive filter.  
## Output:
```
 ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-denoise.nii.gz
```
## Code:
```bash
# User-defined (as necessary)
input_dir=/nifti/${subject}/${session}/anat
which_img=sub-${subject}_ses-${session}_T1w

echo '#--------------------------------------------------------------------------------' >> ${subject_log}
echo 'task:structural_image_denoising' >> ${subject_log}
echo 'input:'${researcher}/${project}/${input_dir}/${which_img}.nii.gz >> ${subject_log}
echo 'software:ANTs' >> ${subject_log}
echo 'version:2.3.1' >> ${subject_log}
echo 'start_time:'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}

DenoiseImage \
  -d 3 \
  -i ${researcher}/${project}/${input_dir}/${which_img}.nii.gz \
  -n Rician \
  -o ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/${which_img}_prep-denoise.nii.gz

echo 'end_time: 'date +"%Y-%m-%d_%H-%M-%S" >> ${subject_log}
echo '' >> ${subject_log}
```
| *arguments* | *description* | *values* | *default* |
|---|---|---|---|
| -d | dimensionality | 2/3/4 | - |  
| -i | input image | - | - |
| -n | noise model | Rician/Guassian | Gaussian |
| -o | output | [correctedImage,*noiseImage*] | - |
| -x | mask image | - | - |
| -s | shrink factor | 1/2/3/... | 1 |  
| -p | patch radius | 1 {1x1x1} | 1 |
| -r | search radius | 2 {2x2x2} | 2 |
| -v | verbose | 0/1 | 0 |  
## Citations
> Manjon JV, Coupe P, Marti-Bonmati L, Collins DL, & Robles M. (2010). Adaptive non-local means denoising of MR images with spatially varying noise levels. Journal of Magnetic Resonance Imaging, 31, 192-203.  

>Avants BB, Tustison NJ, Song G, & Gee JC. (2009). Ants: Open-source tools for normalization and neuroanatomy. Transac Med Imagins Penn Image Comput Sci Lab.

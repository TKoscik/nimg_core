# Readout distortion correction 
## [NOT IMPLEMENTED 2018-10-24]
Since this is intended to correct structural images for readout distortion that differs between T1w and T2w images due to readout bandwidth and if we create an unbiased average of these images in our pipeline and this distortion is relatively small <= 1mm, is this step necessary? Also requires a fieldmap collected separately.   
"Additionally, B0 fieldmaps, B1−, and B1+ maps are acquired for the purpose of correcting readout distortion in the T1w and T2w images and to enable future correction of intensity inhomogeneity by explicitly modeling the B1− receive and B1+ transmit fields."
>Glasser MF, Sotiropoulos SN, Willson JA, Coalson TS, Fischl B, Andersson JL, Xu J, Jbabdi S, Webster M, Polimeni JR, Van Essen DC, Jenkinson M, & WU-Minn HCP Consortium. (2013). The minimal processing pipelines for the Human Connectome Project. Neuroimage, 80, 105-124. DOI:10.1016/j.neuroimage.2013.04.127 PMCID:PMC3720813
## Output:
```
 ${researcher}/${project}/derivatives/anat/prep/${subject}/${session}/
  ∟sub-${subject}_ses-${session}_*_${mod}_prep-readout.nii.gz
```

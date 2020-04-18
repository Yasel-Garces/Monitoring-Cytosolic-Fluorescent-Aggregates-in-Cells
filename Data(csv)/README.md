# Results of the Segmentation Algorithm
This directory contains the results obtained by the segmentation algorithm. It's composed by 3 sub-directories:      
1. **GR_no_quenching**: Results of the procesing of 4 videos.
2. **GR quenching**: Results of the procesing of 3 videos.
3. **R_no_quenching**: Results of the procesing of 9 videos.

# File Structure
Each sub-directory contains the result of the analysis in an independent CSV file for each image. This files are composed by the followinf variables:

| Variable | Description |
|:----------------:|:-----------------------------------------------------|
| Time Img | Unique id for each image |
| No. Cell | Each image contains k number of cells, this is an id for each cell |
| Threshold Cell | Threshold value used for the segmentaion (see publication) |
| No. Lys. | Each cell contains n number of lysosomes, this is an id for each lysosome |
| Area Lys. | Lysosome Area |
| Perimeter Lys. | Lysosome Perimeter |
| Centroid Lys. X | x-coordinate of the lysosome's centroid |
| Centroid Lys. Y | y-coordinate of the lysosome's centroid |
| mCherry_Mean. | Mean fluorescence intensity in the mCherry channel |
| Venus_Mean | Mean fluorescence intensity in the Venus channel |
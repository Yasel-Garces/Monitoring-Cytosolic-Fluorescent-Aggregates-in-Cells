# Directory "Matlab_Codes"
This directory contains the matlab functions for the segmentation and quantification of the lysosomes.

## Functions
1. "_Demo_": This script is an easy way to run all the analysis. Only it's necessary to specify the path for the masks. Note that in the directory of the mask, it's necessary that exist two other directories (Venus and mCherry) with the images.
2. "_process_video_": It process the video of the lysosomes in both channels (Venus and mCherry).
3. "_lysosomes_": This function do the segmentation of each image in a video.
4. "_venus_process_": This function compute the mean intensity and the integral intensity of each lysosome in the Venus channel.
5. "_find_lysosomes_": For a specific cell, this function extracts the information about the lysosomes that are in this cell.

## Further Information
Details about the algorithm can be founded [here](https://www.biorxiv.org/content/10.1101/177139v1.article-metrics).
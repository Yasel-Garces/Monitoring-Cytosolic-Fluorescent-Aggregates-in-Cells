# Segmentation Algorithm Validation
The algorithm validation was performed using synthetic "ground truth" images, generated taking into account diffraction, white noise, dark-current noise and signal amplification [[Sinko et al., 2014](https://www.osapublishing.org/oe/abstract.cfm?uri=oe-22-16-18940), [Garcés et al., 2016](https://www.nature.com/articles/srep36505)]. 

##  Matlab_Codes_Validation
This directory contains all the codes for the generation, segmentation and results comparison using the gound truth images.
### Files
1. **run_simulation**: Run the simulation to validated the segmentation algorithm. You can control:
	1. The number of experiments N (images generated).
 	2. The number of ellipses (lysosomes) to include in each syntetic image.
	3. The differents levels of noise to include.     

	The output is a set of 6 csv files (Jaccard, Jaccard, Recall, Precision, Precision, Displacement, Area and SNR.  The columns represents increase in the signal noise ratio and the rows the experiments.     
	
2. **draw_ellipse**: This function generate ellipses using the parametric form and polar angle. See [here](https://es.wikipedia.org/wiki/Elipse#En_coordenadas_polares for more) for details.
	* INPUT:
		* parameter: vector [a b cx cy angle] where a is major axis, b is a minor axis, cx is the displacement respect to X, cy is the displacement respect to Y and angle is a rotation of the elllipse
		* eliminate: This parameter is a vector of two components that represents the sweeping angle to eliminate points in a ellipse.
	* OUTPUT:
		* Points: vector [X Y] whit the points of the ellipse.
3. **find_lysosomes**: This function extracts the information about the lysosomes that are in a cell.
4. **computeStatistics**: Function to compute the area, perimeter and Centroid of all regions in an image.

##  Validation Results
Contains the results of the previous simulation. This directory is composed by 6 csv files (Jaccard, Jaccard, Recall, Precision, Precision, Displacement, Area, SNR.  The columns represents increase in the signal noise ratio and the rows the experiments.

## Statistical Analysis
Some statistical analysis and visualization are generated using the script "Data Analysis and Visualization.R". See documentation in this script or the document "Supplementary Information.pdf" for details.
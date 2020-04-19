# Generation and processing of the syntetic images
The algorithm validation was performed using synthetic "ground truth" images, generated taking into account diffraction, white noise, dark-current noise and signal amplification (see the Supplementary Information for details).

## Files     
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
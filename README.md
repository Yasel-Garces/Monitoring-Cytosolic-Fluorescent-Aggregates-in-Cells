<img src="Elephants-In-Sunset.jpeg">

# Monitoring Cytosolic Fluorescent Aggregates in Cells

## Motivation
Autophagy is an evolutionary conserved pathway, by which eukaryotic cells degrade long-living cellular proteins and intracellular organelles, to maintain a pool of available nutrients. Impaired autophagy has been associated to important pathophysiological conditions, and this is the reason why several techniques have been developed for its correct assessment and monitoring. Fluorescence microscopy is one of these tools, which relies on the detection of specific fluorescence changes of targeted GFP-based reporters in dot-like organelles in which autophagy is executed. Currently, several procedures exist to count and segment this punctate structures in the resulting fluorescence images, however, they are either based on subjective criteria, or no information is available related to them. 

## Project Scope
In this project we present the concept of an algorithm for a semi-automatic detection and segmentation in 2D fluorescence images of spot-like structures similar to those observed under induction of autophagy. By evaluating the algorithm on more than 20000 simulated images of cells containing a variable number of punctate structures of different sizes and different levels of applied noise, we demonstrate its high robustness of puncta detection, even on a high noise background. We further demonstrate this feature of our algorithm by testing it in experimental conditions of a high non-specific background signal. We conclude that our algorithm is a suitable tool to be tested in biologically-relevant contexts.

The codes available in this repository are part of the publication named "_Concept and in-silico assessment of an algorithm for monitoring cytosolic fluorescent aggregates in cells_" that can be found it [here](https://www.biorxiv.org/content/10.1101/177139v1.full). 

## Files in the Repository
This repository contains the following source codes and data:
1. **Segmentation Algorithm**: The matlab codes are available in the directory "_Matlab_Codes_". Please, see the README in this directory for details.
2. **Results of the image analysis**: It's a set of csv files with the results after the images processing phase. These files are available in the directory "_Data(csv)_". Note that I don't include the microscopy images in the directory (see Authors for details). Please, see the README in this directory for more information.
3. **Codes for the Statistical Analysis**: The R codes of the statistical analysis are available in the directory "_R_Codes_". Also, was included a README into the directory for more information.
4. **Algorithm Validation**: The algorithm validation was performed using synthetic "ground truth" images, generated taking into account diffraction, white noise, dark-current noise and signal amplification. The synthetic images were generated using the approach proposed by Sinko and collaborators in [Sinko et al., 2014](https://www.osapublishing.org/oe/abstract.cfm?uri=oe-22-16-18940). All the codes and the statistical analysis are available in the directory "_Validation Synthetic Images_". You can find more information in the README inside this directory. 

## Author
All these codes were developed by Yasel Garces (email: 88yasel@gmail.com,
[LinkedIn] (https://www.linkedin.com/in/yasel-garces-suarez/)). Nevertheless, the microscopy images (not available in this repository), as well as the materials and methods used to generate these images, are property of the other authors of this research (Vadim Pérez Koldenkova, Tomoki Matsuda, Adán Guerrero, Takeharu Nagai). Please see the [publication](https://www.biorxiv.org/content/10.1101/177139v1.full) for details.

## License
These codes are open access and are distributed under the licence:

[![License: CC0-1.0](https://licensebuttons.net/l/zero/1.0/80x15.png)](http://creativecommons.org/publicdomain/zero/1.0/)

The person who associated a work with this deed has dedicated the work to the public domain by waiving all of his or her rights to the work worldwide under copyright law, including all related and neighboring rights, to the extent allowed by law.

You can copy, modify, distribute and perform the work, even for commercial purposes, all without asking permission.

















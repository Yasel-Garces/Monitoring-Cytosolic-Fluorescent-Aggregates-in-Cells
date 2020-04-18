% For a specific cell, this function computes some information about the
% lysosomes that are in this cell.
% INPUT:
%     cell: image that contain a single cell to be analysed.
% OUTPUT:
%     Number_l: Identification for each lysosome.
%     threshold: Threshold of the image.
%     Area_l,Perimeter_l,Centroid_l,Mcherry_Mean,Mcherry_Intg,Arcs:
%               Some quantifications about each lysosomes (see below for more information).
% Author: Yasel Garces Suarez (25 julio 2016)

function [Number_l,final_threshold,Area_l,Perimeter_l,Centroid_l]=find_lisosomas(cell)

% In the image, the pixels differents to zero are store in a vector
cell_vect=cell(cell~=0);

% We consider that the important information is only the 5% of the total
% information of the image (considering a normal distribution alpha=0.05, then alpha/2=0.025),
% we keep with this information computing the quantile of .975 of the data.
% threshold=quantile(cell_vect,1-(entropy(cell_vect)/8));
% Compute the threshold
prob=1-((entropy(cell_vect)/8))/255;
threshold=quantile(cell_vect,prob);

% Thresholding of the image
In=cell>threshold;
% La imagen se convierte a unit16
if ~strcmp(class(cell),'uint16')
    BW=cell.*uint8(In);
else
    BW=cell.*uint16(In);
end

% Compute the statistics
[Number_l,Area_l,Perimeter_l,Centroid_l]=computeStatistics(BW,cell);

% Represent the threshold as a vector. This is for save the information in
% a dataset with others variables.
final_threshold=repmat(threshold,1,length(Number_l));
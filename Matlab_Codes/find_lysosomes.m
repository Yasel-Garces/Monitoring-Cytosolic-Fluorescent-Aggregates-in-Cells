% For a specific cell, this function extracts the information about the
% lysosomes that are in this cell.
% INPUT:
%     cell: image that contain a single cell to be analysed.
% OUTPUT:
%     Number_l: Identification for each lysosome.
%     threshold: Threshold of the image.
%     Area_l,Perimeter_l,Centroid_l,Mean,Mcherry_Intg,Arcs:
%               Result variables that describe each lysosomes 
%               (see below for more information).
% Author: Yasel Garces (88yasel@gmail.com)

function [Number_l,final_threshold,Area_l,Perimeter_l,Centroid_l,Mcherry_Mean,...
    BW_lis]=find_lysosomes(cell)

% In the image, the pixels differents to zero are store in a vector
cell_vect=cell(cell~=0);

% Normalized image entropy in gray scale
prob=1-(entropy(cell)/16);
% Compute the quantile using the 
threshold=quantile(cell_vect,prob);
% Considerar ==> 1-(entropy(image_cells)/16)
% Thresholding of the image
In=cell>=threshold;
% Transform the image to unit16
if ~strcmp(class(cell),'uint16')
    BW=cell.*uint8(In);
else
    BW=cell.*uint16(In);
end

% 8-connected components to obtain independent lysosomes
[~,BW_lis]= bwboundaries(BW,8,'noholes');

% For each lysosome compute the Area, perimeter, ... (see below)
for i=1:max(BW_lis(:))
    % Number of the lysosome
    Number_l(i)=i;
    % Compute the area, perimeter, Centroid, Mean Intensity and the integral
    % intensity.
    data=regionprops(BW_lis==i,cell,'Area','Perimeter','Centroid','MeanIntensity','PixelValues');
    Area_l(i)=data.Area;
    Perimeter_l(i)=data.Perimeter;
    Centroid_l(i,:)=data.Centroid;
    Mcherry_Mean(i)=data.MeanIntensity-mean(cell_vect);
end
% Represent the threshold as a vector. This is for save the information in
% a dataset with others variables.
final_threshold=repmat(threshold,1,max(BW_lis(:)));
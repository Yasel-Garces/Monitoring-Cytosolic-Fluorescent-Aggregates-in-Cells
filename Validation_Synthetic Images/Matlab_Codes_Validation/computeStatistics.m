% Function to compute the area, perimeter and Centroid of all regions in a
% image.
% INPUT: 
%    BW: Binary Image
% OUTPUT:
% Number_l: Id of the lysosome
% Area_l: Area of the lysosome
% Perimeter_l: Perimeter of the lysosome
% Centroid_l: Centroid of the lysosome
% Author: Yasel Garces.
function [Number_l,Area_l,Perimeter_l,Centroid_l]=computeStatistics(BW,cell)

% Separate each lysosomes for the independent study
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
end
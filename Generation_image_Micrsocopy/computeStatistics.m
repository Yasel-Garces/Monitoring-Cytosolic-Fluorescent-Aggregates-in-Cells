% Function to compute thye area, perimeter and Centroid of all regions in a
% image.
% INPUT: 
%    BW: Binary Image

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
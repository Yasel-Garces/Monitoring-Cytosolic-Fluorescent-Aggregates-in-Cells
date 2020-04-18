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

function [Number_l,final_threshold,Area_l,Perimeter_l,Centroid_l,Mcherry_Mean,...
    BW_lis]=find_lisosomas(cell)

% In the image, the pixels differents to zero are store in a vector
cell_vect=cell(cell~=0);

% We consider that the important information is only the 5% of the total
% information of the image (considering a normal distribution alpha=0.05, then alpha/2=0.025),
% we keep with this information computing the quantile of .975 of the data.
prob=1-(entropy(cell)/16);
threshold=quantile(cell_vect,prob);
% Considerar ==> 1-(entropy(image_cells)/8)
% Thresholding of the image
In=cell>=threshold;
% La imagen se convierte a unit16
if ~strcmp(class(cell),'uint16')
    BW=cell.*uint8(In);
else
    BW=cell.*uint16(In);
end

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
    Mcherry_Mean(i)=data.MeanIntensity-mean(cell_vect);
    %Mcherry_Intg(i)=sum(data.PixelValues)-mean(cell_vect);
end
% Represent the threshold as a vector. This is for save the information in
% a dataset with others variables.
final_threshold=repmat(threshold,1,max(BW_lis(:)));

% To plot
% [cell255,~] = ScaleTo255(cell);
% imshow(cell255)
% hold on
% plot(Centroid_l(:,1),Centroid_l(:,2),'.')
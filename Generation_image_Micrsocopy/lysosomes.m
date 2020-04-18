% For a image sequences, this function do the segmentation for each images
% of the sequence (each image represent a time)
% INPUT:
%      path: The directory of the images of the mCherry channel.
%      files: List with the names of the images in this path.
%      mask: mask image
% OUTPUT:
%     result: Matrix with the information about the lysosomes
%            Time_Img: Time that the image was taken.
%            Number_cell_I: Number of the cell in the image (each cell contains many lysosomes).
%            Threshold_cell_I: Threshold for the cell.
%            Number_I: Number of the lysosomes in the cell, each lysosomes
%            was identified by a number.
%            Area_I: Area of the lysosome.
%            Perimeter_I: Perimeter of the lysosome.
%            Centroid_I_X: X coordinate of the centroid of the lysosome.
%            Centroid_I_Y: Y coordinate of the centroid of the lysosome.
%            Mcherry_Mean: Mean of the intensity of the lysosome.
%      Arcs: Position of each lysosome in the image per cell. Each row
%      represent one image and each column one cell in the image.
% AUTHOR: Yasel Garcés (88yasel@gmail.com) (29/07/2016)

function [result,Arcs]=lysosomes(path,files,mask)

% Maximun number of cells in the image
max_cells=max(mask(:));
% Time (number of the image in the sequence) variable is created empty
Time_Img=[];

% Analysis of each images of the sequence
for i=1:length(files)
    % Read a specif image
    image=imread(char(strcat(path,files(i))));
    % Analysis of each cell in an image
    for j=1:max_cells
        % Apply the mask to the image.
        image_cells = bsxfun(@times, image, cast(mask==j,class(image)));
        % Compute the analysis of a cell, save the results a object of
        % class cell array.
        [Number_l{j},threshold{j}, Area_l{j},Perimeter_l{j},Centroid_l{j},Mcherry_Mean{j},...
            Arcs{i,j}]=find_lisosomas(image_cells);
        % Save the number of the cell
        Number_cell{j}=repmat(j,1,length(Number_l{j}));
    end
    % It merges the information of all cells in objects of type cell array. The
    % elements of the cell array represent the information of one specific
    % time of the study.
    Number_cell_I{i}=cell2mat(Number_cell);
    Threshold_cell_I{i}=cell2mat(threshold);
    Time_Img=[Time_Img; repmat(i,length(Number_cell_I{i}),1)];
    Number_I{i}=cell2mat(Number_l);
    Area_I{i}=cell2mat(Area_l);
    Perimeter_I{i}=cell2mat(Perimeter_l);
    Centroid_I{i}=cell2mat(Centroid_l(:));
    Mcherry_Mean_I{i}=cell2mat(Mcherry_Mean);
end
% It saves the information of the image sequences in a matrix.
Number_cell_I=cell2mat(Number_cell_I)';
Threshold_cell_I=cell2mat(Threshold_cell_I)';
Number_I=cell2mat(Number_I)';
Area_I=cell2mat(Area_I)';
Perimeter_I=cell2mat(Perimeter_I)';
Centroid_I=cell2mat(Centroid_I(:));
Mcherry_Mean_I=cell2mat(Mcherry_Mean_I)';
% It creates the matrix qith all information (output)
result=[Time_Img, Number_cell_I,Threshold_cell_I, Number_I,...
    Area_I, Perimeter_I, Centroid_I(:,1),Centroid_I(:,2), Mcherry_Mean_I];
end
% This function compute the mean intensity and the integral intensity for
% each lysosome in the Venus channel.
% Input:
%      path_Venus: The directory of the images of the Venus channel.
%      files_Venus: List with the names of the images in this path.
%      Arcs: Location of each lysosomes foe each cell (column) and each
%      image (row).
% Output:
%      Venus_Mean: Mean intensity of each image in the Venus channel.
% Author: Yasel Garcés (88yasel@gmail.com, 27/08/2016)

function Venus_Mean=venus_process(path_Venus,files_Venus,Arcs,mask)

% Maximun number of cells in the image
max_cells=max(mask(:));

% Analysis of all images in the path
for i=1:length(files_Venus)
    % Read a specif image
    image=imread(char(strcat(path_Venus,files_Venus(i))));
    
    for j=1:max_cells
        % Apply the mask in the image.
        image_cells = bsxfun(@times, image, cast(mask==j,class(image)));   
        % In the image, the pixels different to zero are store in a vector
        cell_vect=image_cells(image_cells~=0);
        % It compute the mean fluorescence value.
        data=regionprops(Arcs{i,j},image_cells,'MeanIntensity');
        % It normalize and save the information in a cell array
        Venus_Mean{j}=reshape([data.MeanIntensity],1,length(data))-mean(cell_vect);
    end
    % It save the information of each cell in a cell array
    Venus_Mean_I{i}=cell2mat(Venus_Mean);
end
% It merge all the information
Venus_Mean=cell2mat(Venus_Mean_I);
end
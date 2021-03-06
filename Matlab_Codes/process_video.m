% Process the video of the lysosomes in both channels (Venus and mCherry).
% INPUT:
%      path_mask: Directory of the mask (is used to isolate each cell).
%      name_fileCSV: Name of the file to save the processing data
% OUTPUT:
% In the directory "path_mask" it's created a file called "name_fileCSV" 
% with the information about the segmentation 
% (see the function "lysosomes" for details)
% Author:
%       Yasel Garces (88yasel@gmail.com)
%-----------------------------------------------------------
function []=process_video(path_mask,name_fileCSV)
% List of files with extension .tif in path_mask
list_dir=dir(fullfile(path_mask,'*.tif'));
mask={list_dir.name};

% Load the mask
mask=1-im2single(imread(char(strcat(path_mask,mask))));
% Compute the 8 connected components
[~, mask]=bwboundaries(mask,8,'noholes');

% Images sequence for mCherry
path_mCherry=strcat(path_mask,'mCherry/');
list_dir=dir(fullfile(path_mCherry,'*.tif'));
% Load the files for mCherry channel
files_mCherry={list_dir.name};

% Images sequence for Venus
path_Venus=strcat(path_mask,'Venus/');
list_dir=dir(fullfile(path_Venus,'*.tif'));
% Load the files for Venus channel
files_Venus={list_dir.name};
%-----------------------------------------------------------
% Detection and quantification of the lysosomes in "mCherry" channel.
[result_mCherry,Arcs]=lysosomes(path_mCherry,files_mCherry,mask);
% Detection and quantification of the lysosomes in Venus channel
Venus_Mean=venus_process(path_Venus,files_Venus,Arcs,mask);
% Merge information
Global=horzcat(result_mCherry,Venus_Mean');
%-----------------------------------------------------------
% Create a cell array to store the results of the segmentation
result={'Time Img' 'No. Cell' 'Threshold Cell' 'No. Lys.' 'Area Lys.' 'Perimeter Lys.' 'Centroid Lys. X',...
    'Centroid Lys. Y','mCherry_Mean.' 'Venus_Mean';...
    Global(:,1), Global(:,2), Global(:,3),Global(:,4), Global(:,5), Global(:,6), Global(:,7),...
    Global(:,8), Global(:,9), Global(:,10)};
% Write the results in a .csv file
fid = fopen(strcat(path_mask,name_fileCSV), 'w');
fprintf(fid, '%s,', result{1,1:end-1});
fprintf(fid, '%s\n', result{1,end});
fclose(fid);
dlmwrite(strcat(path_mask,name_fileCSV), result(2:end,:),'-append')

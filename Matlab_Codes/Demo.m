%clear all
% FILES NAMES
% GR no quenchin
name_fileCSV{1}='GR_no_quenching_396.csv';

% PATH FOR THE MASK
% GR no quenching
path_mask{1} = '/home/yasel/TRABAJO/IBt/Vadim_Adan_LNMA/Images/GR no quenching/396/';

% Execute "Run" for each directory
for i=1:length(name_fileCSV)
    process_video(path_mask{i},name_fileCSV{i});
end

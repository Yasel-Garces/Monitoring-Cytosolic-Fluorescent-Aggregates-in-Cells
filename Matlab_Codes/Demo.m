%clear all
% FILES NAMES
% GR no quenchin
name_fileCSV{1}='GR_no_quenching_396.csv';
% name_fileCSV{2}='GR_no_quenching_398.csv';
% name_fileCSV{3}='GR_no_quenching_399.csv';
% name_fileCSV{4}='GR_no_quenching_404.csv';

% % GR quenching
% name_fileCSV{5}='GR_quenching_222.csv';
% name_fileCSV{6}='GR_quenching_225.csv';
% name_fileCSV{7}='GR_quenching_261.csv';
% 
% % R no quenching
% name_fileCSV{8}= 'R_no_quenching_15.csv';
% name_fileCSV{9}= 'R_no_quenching_258.csv';
% name_fileCSV{10}= 'R_no_quenching_259.csv';
% name_fileCSV{11}= 'R_no_quenching_260.csv';
% name_fileCSV{12}= 'R_no_quenching_262.csv';
% name_fileCSV{13}= 'R_no_quenching_395.csv';
% name_fileCSV{14}='R_no_quenching_400.csv';
% name_fileCSV{15}='R_no_quenching_401.csv';
% name_fileCSV{16}='R_no_quenching_402.csv';
% name_fileCSV{17}='R_no_quenching_406.csv';

% PATH FOR THE MASK
% GR no quenching
path_mask{1} = '/home/yasel/TRABAJO/Vadim_Adan_LNMA/Images/GR no quenching/396/';
% path_mask{2} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/GR no quenching/398/';
% path_mask{3} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/GR no quenching/399/';
% path_mask{4} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/GR no quenching/404/';
% 
% % GR quenching
% path_mask{5} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/GR quenching/222/';
% path_mask{6} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/GR quenching/225/';
% path_mask{7} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/GR quenching/261/';
% 
% % R no quenching
% path_mask{8} =  '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/15/';
% path_mask{9} =  '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/258/';
% path_mask{10} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/259/';
% path_mask{11} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/260/';
% path_mask{12} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/262/';
% path_mask{13} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/395/';
% path_mask{14} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/400/';
% path_mask{15} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/401/';
% path_mask{16} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/402/';
% path_mask{17} = '/home/yasel/TRABAJO/Adan_Lisosomas/Images/R no quenching/406/';

% Execute "Run" for each directory
for i=1:length(name_fileCSV)
    Run(path_mask{i},name_fileCSV{i});
end

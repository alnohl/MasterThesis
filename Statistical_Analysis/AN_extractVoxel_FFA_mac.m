% This script extracts con values for the VWFA
% Adapted by Alexandra Nohl, August 2023 (code by Amelie Haugg, 2021)


clear all

%% Paths and Participants
dataPath = '/path/to/your/first/level/folder/glm/';


batchPath = '/path/to/your/voxel/extraction/scripts';
maskPath = '/path/to/your/mask/';


mask = 'mask_name.nii'; % enter your mask name here

filePath = '/path/to/your/folder/to/save/output';


% Participants
Participants = dir([dataPath,'sub-*']); % list of your participants (sub-...). Same name as their folders! 
Participants = {Participants.name}


% Threshold for t-values
threshold = 2.5; % t-value


% create txt file
fid = fopen([filePath,'/' 'name_of_output_file.txt'],'a'); %creates txt file, if it doesn't exist yet
fprintf(fid, 'Subjects \t FacesVsBaseline \t FacesVsWords \n');



%% Voxel Extraction

% save number of beta values above threshold
num_above_thresh_Baseline = zeros(length(Participants), 1);
num_above_thresh_Words = zeros(length(Participants), 1);

for n = 1:length(Participants)
    
    % display current participant
    p = cell2mat(Participants(n));
    
    % find path to beta image
    subjDir = [dataPath p];
    
    % get contrast image WordsVsBaseline
    contrast = spm_select('FPList', subjDir, 'spmT_0005.nii'); %con_0002 for WordsVsBaseline
    cd(batchPath);
    
    % extract beta values within mask for contrast WordsVsBaseline
    beta_vals_Baseline = AN_extractTimeCourse(maskPath, mask, contrast);
    %fprintf('Length of beta_vals for participant %s: %d\n', p, length(beta_vals));

    % count number of beta values above threshold
    num_above_thresh_Baseline(n) = sum(beta_vals_Baseline > threshold);
    

    % get contrast image WordsVsFaces
    contrast = spm_select('FPList', subjDir, 'spmT_0003.nii'); %con_0002 for WordsVsFaces
    cd(batchPath);

    % extract beta values within mask for contrast WordsVsFaces
    beta_vals_Words = AN_extractTimeCourse(maskPath, mask, contrast);

    % count number of beta values above threshold
    num_above_thresh_Words(n) = sum(beta_vals_Words > threshold);

end



%% Save Voxels in txt file

for n = 1:length(Participants)

    % save number of beta values above threshold for current participant
    fprintf(fid, '%s\t', Participants{n}); %prints subject name
    fprintf(fid, '%d\t', num_above_thresh_Baseline(n)); %prints max beta values WordsVsBaseline
    fprintf(fid, '%d\t', num_above_thresh_Words(n)); %prints max beta values WordsVsFaces

    fprintf(fid,'\n'); %next line (enter)

end


fclose(fid); %close txt file


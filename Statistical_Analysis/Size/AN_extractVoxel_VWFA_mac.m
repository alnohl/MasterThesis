% This script extracts con values for the VWFA
% Adapted by Alexandra Nohl, August 2023 (code by Amelie Haugg, 2021)


clear all

%% Paths and Participants
dataPath = '/Volumes/BrainMap$/studies/localizer/AllRead_data/Analysis_children/1st_level_analysis/glm_both/';


batchPath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Scripts';
%maskPath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Masks/ROI_Masks_WFU_Pickatlas_left';
%maskPath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Masks/ROI_Masks_WFU_Pickatlas_right';
%maskPath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Masks/ROI_Masks_visfAtlas';
maskPath = '/Users/alexandranohl/Desktop';


mask = 'mask_OTC_left.nii'; % Mask huge OTC left hemisphere
%mask = 'mask_OTC_right.nii'; % Mask huge OTC right hemisphere

%mask = '8_lh_pOTS_characters.nii'; % Mask small pVWFA left hemisphere
%mask = '8_mirrored_rh_pOTS_characters.nii'; % Mask small pVWFA right hemisphere


%filePath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction visfAtlas';
filePath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_children/Statistical_analysis/Size/Voxel Extraction WFU Pickatlas';


% Participants Both
Participants = dir([dataPath,'AR*']); % list of your participants. Same name as their folders! 
Participants = [Participants; dir([dataPath,'CBC*'])]; % to add both AR and CBC subject folders
Participants = {Participants.name}
%Participants = {'AR1004'}


% Threshold for beta values
threshold = 2.5; % T-value



% create txt file
fid = fopen([filePath,'/' 'VoxelExtraction_VWFA_mask_OTC_left.txt'],'a'); %creates txt file, if it doesn't exist yet
%fid = fopen([filePath,'/' 'VoxelExtraction_VWFA_mask_OTC_right.txt'],'a'); %creates txt file, if it doesn't exist yet
fprintf(fid, 'Subjects \t WordsVsBaseline \t WordsVsFaces \n');



%% Voxel Extraction Both

% save number of beta values above threshold
num_above_thresh_Baseline = zeros(length(Participants), 1);
num_above_thresh_Faces = zeros(length(Participants), 1);

for n = 1:length(Participants)
    
    % display current participant
    p = cell2mat(Participants(n));
    
    % find path to beta image
    subjDir = [dataPath p];
    
    % get contrast image WordsVsBaseline
    contrast = spm_select('FPList', subjDir, 'spmT_0004.nii'); %con_0004 for WordsVsBaseline
    cd(batchPath);
    
    % extract beta values within mask for contrast WordsVsBaseline
    beta_vals_Baseline = AN_extractTimeCourse(maskPath, mask, contrast);
    %fprintf('Length of beta_vals for participant %s: %d\n', p, length(beta_vals));

    % count number of beta values above threshold
    num_above_thresh_Baseline(n) = sum(beta_vals_Baseline > threshold);
    

    % get contrast image WordsVsFaces
    contrast = spm_select('FPList', subjDir, 'spmT_0002.nii'); %con_0002 for WordsVsFaces
    cd(batchPath);

    % extract beta values within mask for contrast WordsVsFaces
    beta_vals_Faces = AN_extractTimeCourse(maskPath, mask, contrast);

    % count number of beta values above threshold
    num_above_thresh_Faces(n) = sum(beta_vals_Faces > threshold);

end




for n = 1:length(Participants)

    % save number of beta values above threshold for current participant
    fprintf(fid, '%s\t', Participants{n}); %prints subject name
    fprintf(fid, '%d\t', num_above_thresh_Baseline(n)); %prints max beta values WordsVsBaseline
    fprintf(fid, '%d\t', num_above_thresh_Faces(n)); %prints max beta values WordsVsFaces

    fprintf(fid,'\n'); %next line (enter)

end


fclose(fid); %close txt file


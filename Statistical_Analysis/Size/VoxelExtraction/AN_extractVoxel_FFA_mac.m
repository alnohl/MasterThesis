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


%mask = 'mask_OTC_left.nii'; % Mask huge OTC left hemisphere
mask = 'mask_OTC_right.nii'; % Mask huge OTC right hemisphere

%mask = '19_rh_pFus_faces.nii'; % Mask small FFA-1 right hemisphere
%mask = '19_mirrored_lh_pFus_faces.nii'; % Mask small FFA-1 left hemisphere


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
%fid = fopen([filePath,'/' 'VoxelExtraction_FFA_mask_OTC_left.txt'],'a'); %creates txt file, if it doesn't exist yet
fid = fopen([filePath,'/' 'VoxelExtraction_FFA_mask_OTC_right.txt'],'a'); %creates txt file, if it doesn't exist yet
fprintf(fid, 'Subjects \t FacesVsBaseline \t FacesVsWords \n');



%% Voxel Extraction Both


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


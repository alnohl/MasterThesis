% A wrapper script for MR PREPROCESSING using  MATLAB parallel toolbox.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Admits input of several subjects 
% REQUIRES:
%       - folders b0,epis and t1w. Each with a subfolder per subject
%       - folder names as input of 'tasklist' variables
%       - T1 image (1 file) stored in separate folder named "T1w".
%       - Subjects at the last level of the directory
% OUTPUT:
%       - multiple preprocessed files (SPM style)
%       - operation log file in txt.
%
% Latest version: Alexandra Nohl (July 2023) adapted from original by David Willinger 
%--------------------------------------------------------------------------
% Clear up  workspace, load spm config file and add  path to our scripts
clear all; close all; 
spm_jobman('initcfg');
addpath ('/path/to/your/preprocessing/scripts') 

% Inputs setup
%-----------------------------------------------------------------
preprocessingDir = '/path/to/your/fMRI/data/for/preprocessing/epis/' % the epis folder contains the functional data
subjects = dir([preprocessingDir,'sub-*']); % list of your participants (sub-...). Same name as their folders! 
subjects = {subjects.name}

% If working in paralel, only process as many subjects as cores specified in parpool(Line 57) at a time! 
currTask =  'Localizer'; % task name (same name is its main folder). 'curr' is for current!
anatTemplate = '/path/to/your/anatomical/template/TPM.nii'; % fullfilename of our anatomical template (here called "TPM.nii")

%Specify our main PATH (end character should be / )
paths.preprocessing = '/path/to/your/prerocessing/folder/';

%% BEGIN SUBJECT LOOP  
%-----------------------------------------------------------------
tic 
cd (paths.preprocessing) % Set current directory (cd)
paths.task = [paths.preprocessing,currTask,'/'];
     
 batch = cell(length(subjects)); %initialise empty batch. Each cell of the batch will have the matlabbatch for a subject
 for i=1:length(subjects)   

     currsubject = subjects{i};  
        if  isempty(dir([paths.task,'**/',currsubject]))
            disp(['Cannot find ',currsubject,' folder in ',paths.task,' \n'])
        else
            
        % Call CREATE FIELDMAP.Preprocess b0, creates vdm5 file (voxel displacement map)
        AN_create_fieldmap_mac(currsubject,paths,anatTemplate); 

        % Call CREATE MATLABBATCH (stores all settings for our pipeline) 
        [batch{i}] = AN_create_matlabbatch_mac(paths,currsubject,anatTemplate);
        end
 end
     
%% RUN our batch in parallel
%-------------------------------------------------------------------------------------
  if ~isempty(gcp('nocreate'))
             delete(gcp('nocreate'));  
  end
     % if you use parallel for-loop: uncomment (make sure your computers as many cores as specified!! If not, change this number to 4 or 2)
    parpool(1); %set to 3 with current computer (or to 1 if not working)
    parfor i=1:length(subjects)    % comment if not doing parallel 
    %for i=1:length(subjects)      % comment this line if working in parallel 
        try
           
           % RUN THE BATCH ---------------------
           data_out{i} = spm_jobman('run',batch{i})
           %data_out(i) = spm_jobman('interactive',batch{i})
           %spm_jobman('run',batch{i}) 
           %spm_jobman('interactive',batch{i}) 
           %  ----------------------------------
        catch
            data_out{i} = disp('error during preprocessing - check the batch')
        end    
    end
     
   save([paths.preprocessing,['Batch_',currTask,'_',datestr(now,'mmddyyyy-HHMM'),'.mat']],'batch')
   clear batch
  
toc

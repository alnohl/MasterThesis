%--------------------------------------------------------------------------------------------------------------
% RUN FIRST LEVEL ANALYSIS 
%
% Subject-level Localizer task analysis
% - Reads onsets of events from Presentation .log files
% - Creates batch with contrasts
% - Runs batch
%
% Adapted from MH by AN, June 2023
%--------------------------------------------------------------------------------------------------------------


clear all
close all
addpath ('/path/to/your/first/level/scripts');% set path to this script and associated functions


%% Set up directories and some variables  (last character is NOT '/')

paths.mri = '/path/to/your/preprocessing/files';
paths.logs = '/path/to/your/logfiles'; % log files from stimuli computer (used to read onsets)
paths.analysis =  '/path/to/your/fisrt/level/glm/folder/glm';


nscans = 168; %  n volumes 
mask_threshold = 0.2;


% find subjects from our epi dir

files = dir([paths.mri,'/epis/*']); % the epis folder contains the functional data from preprocessing
preprocessingDir = '/path/to/your/preprocessing/files/epis/'
subjects = dir([preprocessingDir,'sub-*']);% list of your participants (sub-...). Same name as their folders!
subjects = {subjects.name}


%% BEGIN SUBJECT LOOP

mkdir(paths.analysis)
cd (paths.analysis)
spm('defaults','fMRI')

for i = 1:length(subjects)
    currSubject = subjects{i}; 
    pathSubject = fullfile(paths.analysis,'/',currSubject); %output path
    if ~isdir(pathSubject)
        mkdir(pathSubject);
    end
    cd(pathSubject)

    %% Get onsets
    % Read Log
    currLog = dir([paths.logs,'/',currSubject, '/', '*.log']);

    if length(currLog)==1 
        disp(['Read ', currLog.name])
        fileID = fopen([currLog.folder '/' currLog.name]);
        content = textscan(fileID,'%s %s %s %s %s %s %s %s %s %s %s %s %s', 'headerlines', 5 ,'delimiter','\t');
        fclose(fileID); 

        % gather onsets
        onsets = {};
            idx_scanonset = find(strcmp(content{4},'199'));% 
            idx_scanonset = idx_scanonset(1);  % find first scanner pulse 
            onsets.words = cellfun(@str2num,(content{5}(strcmp(content{4},'60'))))./10000 - cellfun(@str2num,(content{5}(idx_scanonset)))./10000;
            onsets.faces = cellfun(@str2num,(content{5}(strcmp(content{4},'70'))))./10000 - cellfun(@str2num,(content{5}(idx_scanonset)))./10000;
            onsets.targets = cellfun(@str2num,(content{5}(strcmp(content{4},'65') | strcmp(content{4},'75'))))./10000 - cellfun(@str2num,(content{5}(idx_scanonset)))./10000;
            onsets.wordstargets = cellfun(@str2num,(content{5}(strcmp(content{4},'65'))))./10000 - cellfun(@str2num,(content{5}(idx_scanonset)))./10000;
            onsets.facetargets =  cellfun(@str2num,(content{5}(strcmp(content{4},'75'))))./10000 - cellfun(@str2num,(content{5}(idx_scanonset)))./10000;
            disp(['...found ',num2str(length(onsets.words)),' words ,',num2str(length(onsets.faces)),' faces and ',num2str(length(onsets.wordstargets)),' wordstargets and ',num2str(length(onsets.facetargets)),' facestargets.'])
   
    else
        disp(['<*_*> something wrong Logs of ', currSubject])

    end


    %% Get scans 
    epifile = dir([paths.mri,'/epis/',currSubject,'/s6wuamr*.nii']);

    if isempty(epifile)==1
        disp(['Could not find epi file in ',currSubject])

    else
        scans =  cellstr(spm_select('ExtFPList',epifile.folder, epifile.name, Inf));
        if length(scans)==nscans
            disp(['Found ',num2str(length(scans)),' scans'])
        else
            disp('<*_*> unexpected number of scans!');
        end

    end


    %% Get my regressors (RP and badscans)
    % Realignment parameters 
    rpfile = dir([paths.mri,'/epis/',currSubject,'/rp_amr*.txt']);

    if isempty(rpfile)==1
        disp(['Could not find rp file in ',currSubject])

    else
        formatSpec = '%16f%16f%16f%16f%16f%16f%[^\n\r]';
        rpfileID = fopen([rpfile.folder,'/',rpfile.name],'r');
        rpdat = textscan(rpfileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string',  'ReturnOnError', false);
        fclose(rpfileID);
            

        % load fwd file
        % -----------------------------------------------------------------

        % Specify the path to the text file
        subjectPath = [paths.mri,'/epis/',currSubject];
        fwdPath = fullfile(subjectPath, ['fwd_' currSubject '.txt']);
             
        % Open the text file for reading
        fwdID = fopen(fwdPath, 'r');
             
        % Read the data from the text file
        fwdData = textscan(fwdID, '%s\n');
             
        % Close the file
        fclose(fwdID);
             
        % Access the values as separate cells
        fwdStrings=fwdData{1};
             
        % Convert strings to numeric values
        fwd = cellfun(@str2double, fwdStrings);
             
        % Read bad scans
        regr=zeros(168,6);
        regr=[rpdat{1},rpdat{2},rpdat{3},rpdat{4},rpdat{5},rpdat{6}]

        regr=regr(1:168,:);


        n=1;
             
        for v=1:168
            % censor volumes with framewise displacement > 0.9
            if fwd(v) > 0.9
                regr(v,6+n)=1;
                %regr(v-1,6+n)=1; %schliesst volume vor dem aus
                %regr(v+1,6+n)=1; %schliesst volume nach dem aus
                n=n+1;
            end
        end

        % Save the variable to a text file
        writetable(cell2table(num2cell(regr)),[subjectPath,'/multiReg.txt'],'WriteVariableNames',false)

    end


    %% ANALYSIS

    % Create 1st level batch 
    matlabbatch = AN_create_1stLevel_glm_mac(regr,pathSubject,subjectPath,subjects,scans,onsets,rpfile,mask_threshold);

    % Run the batch for this subject
    disp(['_m_d[^_^]b_m Start running 1st Level for ',currSubject,'...'])
    spm_jobman('run',matlabbatch);
    disp('done.')


    clear matlabbatch   
    clear scans

end



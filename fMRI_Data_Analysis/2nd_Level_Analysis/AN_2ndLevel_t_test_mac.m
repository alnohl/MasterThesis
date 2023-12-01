%% Secondlevel script for t-test
% November 2023, AN


clear matlabbatch;
clear all;

%% Define paths and subjects

% define analysis path
studyPath = '/path/to/your/fMRI/data/analysis/folder/'; % the folder includes all files from preprocessing and first level analysis
dataPath_group1 = '1st_level_analysis/glm_group1/';
dataPath_group2 = '1st_level_analysis/glm_group2/';

% define folder where results from 2nd level analysis (SPM files) will be stored
stats = '/2nd_level_analysis/t-test/';


% Subjects
subject = dir([studyPath, dataPath,'sub-*']); % list of your participants (sub-...). Same name as their folders! 
subject = {subject.name}

% count subjects
n_subj = numel(subject);


%% define number of contrasts
% the following lines do only work up to 99 contrasts

n_cons = 4; % adjust manually (max. 99 contrasts)
%number_ess = '01';


% ['01 EOI']
% ['02 words vs faces']
% ['03 faces vs words']
% ['04 words vs baseline']
% ['05 faces vs baseline']


% make a list of strings from con_0002 until con_0005
Cons = strcat({'con_000'},int2str((2:5).')).';


% count contrasts
nCons = numel(Cons);

% define type of contrast files
%img='.img';
nii = '.nii';

% define path where results from 2nd level analysis will be stored
ConDir = [studyPath stats];

% define folder names where contrasts from 2nd level analysis will be stored
ConFolder = {
['02 words vs faces']
['03 faces vs words']
['04 words vs baseline']
['05 faces vs baseline']
};


% find content of directory
ContDir = dir(ConDir);


%% Specify 2nd level
for j=1:nCons
       
    % find con file of each subject (for the two groups you want to compare)
    for i=1:length(subject)
        file_con_group1 = [studyPath dataPath_group1 subject{i} '/' Cons{j} nii];
        con_group1(i,1)={file_con_group1};
        file_con_group2 = [studyPath dataPath_group2v subject{i} '/' Cons{j} nii];
        con_group2(i,1)={file_con_group2};
    end
    
    % define path for this analysis
    statsDir = [ConDir ConFolder{j}];
    
    if ~isdir(statsDir)
    mkdir(statsDir);
    end



    %% Matlab-Batch for paired t-test

    matlabbatch{1}.spm.stats.factorial_design.dir = {statsDir};
    for i=1:length(subject)
        matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(i).scans = {strcat(studyPath, dataPath_group1, subject{i}, '/', Cons{j}, '.nii,1')
                strcat(studyPath, dataPath_group2, subject{i}, '/', Cons{j}, '.nii,1')};
    end

    matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
    matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
    matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
    matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;


    % run the batch
    spm_jobman('run', matlabbatch(1));



    %% SecondLevel-Estimation

    % define directory where SPM file is stored
    
    matlabbatch{2}.spm.stats.fmri_est.spmmat = {[statsDir,'/SPM.mat']}; %Directory
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;


    % run the batch
    spm_jobman('run', matlabbatch(2));
    


    %% Specify 2nd level - Calculation

    % define directory where estimated SPM file is stored
    
    % define name of contrast
    % in this case the contrast is named after the directory
    name = ConFolder{j};
    
    matlabbatch{3}.spm.stats.con.spmmat = {[statsDir,'/SPM.mat']};  %select estimated SPM file
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = name;       %define name of contrast
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
    %matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = 1;
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = ['-' name]; 
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 0;

    
    % run the batch
    spm_jobman('run', matlabbatch(3));

    clear matlabbatch;

end

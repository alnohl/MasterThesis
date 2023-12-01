%% Secondlevel script for t-test
% November 2023, AN


clear matlabbatch;
clear all;

%% Define paths and subjects

% define analysis path
studyPath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/';
dataPathOld = '1st_level_analysis/glm_old/';
dataPathRev = '1st_level_analysis/glm_rev/';

% define folder where results from 2nd level analysis (SPM files) will be stored
stats = 'Statistical_analysis/2nd_level_analysis/Adults_t-test/';


% Subjects
subject = dir([studyPath, dataPathOld,'BIO*']); % list of your participants. Same name as their folders! 
subject = [subject; dir([studyPath, dataPathOld,'LOC*'])]; % to add both BIO and LOC subject folders
subject = {subject.name}
%subject = {'BIO2302','BIO2304','BIO2305','BIO2306','BIO2307','BIO2308','LOC01', 'LOC02', 'LOC03','LOC04','LOC05','LOC06','LOC07','LOC08','LOC09','LOC10','LOC11','LOC12'}; %use this line if you have a selection of subjects


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
       
    % find con file of each subject
    for i=1:length(subject)
        file_conOld = [studyPath dataPathOld subject{i} '/' Cons{j} nii];
        conOld(i,1)={file_conOld};
        file_conRev = [studyPath dataPathRev subject{i} '/' Cons{j} nii];
        conRev(i,1)={file_conRev};
    end
    
    % define path for this analysis
    statsDir = [ConDir ConFolder{j}];
    
    if ~isdir(statsDir)
    mkdir(statsDir);
    end



    %% Matlab-Batch for paired t-test

    matlabbatch{1}.spm.stats.factorial_design.dir = {statsDir};
    for i=1:length(subject)
        matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(i).scans = {strcat(studyPath, dataPathOld, subject{i}, '/', Cons{j}, '.nii,1')
                strcat(studyPath, dataPathRev, subject{i}, '/', Cons{j}, '.nii,1')};
    end
    %matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(1).scans = conOld(:,1);
    %matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(2).scans = conRev(:,1);

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

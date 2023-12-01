% Second Level Analysis for localizer
% Alexandra Nohl, July 2023 (Adapted from Sarah Di Pietro)

clear matlabbatch;
clear all;


% define path to data
studyPath = '/path/to/your/fMRI/data/analysis/folder/'; % the folder includes all files from preprocessing and first level analysis

dataPath = '1st_Level_Analysis/glm/';

% define folder where results from 2nd level analysis (SPM files) will be stored
stats = '2nd_level_analysis/localizer/'; 

%path_mask = 'K:\FS2023\data\analyses\mask_ICV.nii'; % use default mask


preprocessingDir = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/1st_Level_Analysis/glm/'
subject = dir([preprocessingDir,'sub-*']); % list of your participants (sub-...). Same name as their folders! 
subject = {subject.name}

%% get your contrast files
d=dir([studyPath dataPath subject{1}]);
d={d.name};

% only chose the con (t-contrast) and ess (f-contrast) files and sort them
con_names = {'con', 'ess'}; % define desired names
index = find(contains(d, con_names));
Cons=d(index);
nums = extractBetween(Cons,5,8); % extract the numbers from the names
[~,sortOrder] = sort(nums); % get the order in which to sort the files
Cons = Cons(sortOrder); % sort the files

% count contrasts
nCons = numel(Cons);

% define type of contrast files
%img='.img';
nii = '.nii';

% define path where results from 2nd level analysis will be stored
ConDir = [studyPath stats];

% define folder names where contrasts from 2nd level analysis will be stored
ConFolder = {['01 EOI']
['02 words vs faces']
['03 faces vs words']
['04 words vs baseline']
['05 faces vs baseline']
}; 

%% Specify 2nd level
for j=1:nCons
       
    % find con file of each subject
    for i=1:length(subject)
        file_con = [studyPath dataPath num2str(subject{i}) '/' Cons{j}];
        con(i,1)={file_con};
    end
    
    % define path for this analysis
    statsDir = [ConDir ConFolder{j}];
    
    if ~exist(statsDir)
    mkdir(statsDir);
    end
    
    matlabbatch{j}.spm.stats.factorial_design.dir = {statsDir}; % directory

    matlabbatch{j}.spm.stats.factorial_design.des.t1.scans = con(:,1); % all con file found above
    matlabbatch{j}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{j}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{j}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{j}.spm.stats.factorial_design.masking.im = 1;
    %matlabbatch{j}.spm.stats.factorial_design.masking.em = {path_mask}; % used default mask
    matlabbatch{1}.spm.stats.factorial_design.masking.em = {''}; 
    matlabbatch{j}.spm.stats.factorial_design.globalc.g_omit = 1;
    matlabbatch{j}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
    matlabbatch{j}.spm.stats.factorial_design.globalm.glonorm = 1;

    % run the batch
    spm_jobman('run', matlabbatch(j));
    
end



%% SecondLevel-Estimation

clear matlabbatch;
% find content of directory
ContDir = dir(ConDir);

% select names of directories
% position 1 and 2 are left out, because they do not contain folder names
Folder = {ContDir(3:end,1).name};

% count selected folders
nFolder =numel(Folder);


for j=1:nFolder
    
    % define directory where SPM file is stored
    statsDir = [ConDir Folder{j}];
    
    matlabbatch{j}.spm.stats.fmri_est.spmmat = {[statsDir,'/SPM.mat']}; % Directory
    matlabbatch{j}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{j}.spm.stats.fmri_est.method.Classical = 1;

    % run the batch
    spm_jobman('run', matlabbatch(j));
    

end


%% Specify 2nd level - Calculation
clear matlabbatch;
for j=1:nFolder
    
    % define directory where estimated SPM file is stored
    statsDir = [ConDir Folder{j}];
    
    % define name of contrast
    % in this case the contrast is named after the directory
    name = Folder{j};
    
    matlabbatch{j}.spm.stats.con.spmmat = {[statsDir,'/SPM.mat']};  % select estimated SPM file
    matlabbatch{j}.spm.stats.con.consess{1}.tcon.name = name;       % define name of contrast
    matlabbatch{j}.spm.stats.con.consess{1}.tcon.convec = 1;
    matlabbatch{j}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{j}.spm.stats.con.delete = 1;
        
    % run the batch
    spm_jobman('run', matlabbatch(j));

end

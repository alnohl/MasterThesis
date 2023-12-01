%% Secondlevel script for multiple regression
% Updated September 2023, AN

clear matlabbatch;
clear all;

% define analysis path
studyPath = '/path/to/your/fMRI/data/analysis/folder/'; % the folder includes all files from preprocessing and first level analysis
dataPath = '1st_level_analysis/glm/';

% define folder where results from 2nd level analysis (SPM files) will be stored
stats = '/2nd_level_analysis/Regression/';

tablepath='/path/to/your/excel/sheet/with/values/for/regression/data.xlsx'; % e.g., age, reading ability, etc.
sheetname='reading_ability';

column_subj='Subjects';
column_behavior='mean_reading_ability';

% careful! This uses all subjects that are in the sheet of the Excel file!
T=readtable(tablepath,'Sheet',sheetname); 
subject=(T.(column_subj))'; %gets subjects from column "VP"
behavioral_value=[T.(column_behavior)]'; %gets behavioral value of column you put in line 17
behavioral_name='mean_reading_ability'; %adapt name if you change behavioral test you are correlating with


% count subjects
n_subj = numel(subject);


%% define number of contrasts
% the following lines do only work up to 99 contrasts

n_cons = 4; %% ADJUST manually!!!! max. 99
% number_ess = '01'; % only cons used, not ess

% Overview of our contrasts:
       % ['01 EOI'] % not used (is ess, not con)
       % ['02 words vs faces']
       % ['03 faces vs words']
       % ['04 words vs baseline']
       % ['05 faces vs baseline']


% make a list of strings from con_0001 until con_0005
Cons = strcat({'con_000'},int2str((2:5).')).'; %con_0001 did not exist

% make a list of strings for F-contrasts
%Cons_F = strcat({'ess_00'},number_ess).'; % we did not use F-contrasts

% combine lists from above (if you have F-contrasts)
%Cons = [Cons Cons_F]; % we did not use F-contrasts

% count contrasts
nCons = numel(Cons);

% define type of contrast files
% img='.img';
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

%% Specify 2nd level
for j=1:nCons
       
    % find con file of each subject
    for i=1:length(subject)
        file_con = [studyPath dataPath subject{i} '/' Cons{j} nii];
        con(i,1)={file_con};
    end
    
    % define path for this analysis
    statsDir = [ConDir ConFolder{j}];
    
    if ~isdir(statsDir)
    mkdir(statsDir);
    end
    
    matlabbatch{j}.spm.stats.factorial_design.dir = {statsDir}; %directory
    matlabbatch{j}.spm.stats.factorial_design.des.mreg.scans = con(:,1);
    matlabbatch{j}.spm.stats.factorial_design.des.mreg.mcov.c = behavioral_value;
    matlabbatch{j}.spm.stats.factorial_design.des.mreg.mcov.cname = behavioral_name;
    matlabbatch{j}.spm.stats.factorial_design.des.mreg.mcov.iCC = 1;
    matlabbatch{j}.spm.stats.factorial_design.des.mreg.incint = 1;
    matlabbatch{j}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{j}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
    matlabbatch{j}.spm.stats.factorial_design.masking.tm.tm_none = 1;
    matlabbatch{j}.spm.stats.factorial_design.masking.im = 1;
    matlabbatch{j}.spm.stats.factorial_design.masking.em = {''};
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
% position 1 and 2 are left out, because they do not contain folder names,
% position 3 is left out because it is the ess-contrast ([01 EOI])
Folder = {ContDir(4:end,1).name};

% count selected folders
nFolder =numel(Folder);


for j=1:nFolder
    
    % define directory where SPM file is stored
    statsDir = [ConDir Folder{j}];
    
    matlabbatch{j}.spm.stats.fmri_est.spmmat = {[statsDir,'/SPM.mat']}; %Directory
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
    
    matlabbatch{j}.spm.stats.con.spmmat = {[statsDir,'/SPM.mat']};  %select estimated SPM file
    matlabbatch{j}.spm.stats.con.consess{1}.tcon.name = name;       %define name of contrast
    matlabbatch{j}.spm.stats.con.consess{1}.tcon.weights = [0 1];
    %matlabbatch{j}.spm.stats.con.consess{1}.tcon.convec = 1;
    matlabbatch{j}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{j}.spm.stats.con.consess{2}.tcon.name = ['-' name]; 
    matlabbatch{j}.spm.stats.con.consess{2}.tcon.weights = [0 -1];
    matlabbatch{j}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{j}.spm.stats.con.delete = 0;
    
    % run the batch
    spm_jobman('run', matlabbatch(j));

end


% Adapted July 2023 by Alexandra Nohl

% function [FileNames, maxC, MNIpeak] = getMaxBeta(CON_dir,Mask_file)
%
% findMaxBeta finds the maximal beta-value within a predefined ROI/mask. This
% function must be applied to a folder with con-files-of-interest.

% IN:
% @CON_dir: directory in which the con-Files-of-interest are located. All
% files starting with "con_" will be analyzed. (format example:
  
%
% @Mask_file: string of the name and location of the mask/ROI
  
%
% OUT:
% @FileNames: Cell-array of the filenames from which the data is derived
 
% @maxC: maximal beta-value for each con-file

% @MNIpeak: MNI coordinates of maximal C-value for each file



function [FileNames, maxC, MNIpeak] = getMaxBetaTxt(CON_dir,Mask_file, fileWords)

Mask_file = '/Users/alexandranohl/Desktop/mask_OTC_left.nii';
fileWords = 'mask_OTC_left_'


%% WordsVsBaseline Old

subjectsDirOld = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/1st_Level_Analysis/glm_old/';
subjectsOld = dir([subjectsDirOld,'BIO*']);% list of your participants. Same name as their folders!
subjectsOld = [subjectsOld; dir([subjectsDirOld,'LOC*'])];
subjectsOld = {subjectsOld.name};


contrastBaseline = 'WordsVsBaseline'
roi_dir = ['/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/Statistical_analysis/ROI/Coordinates/VWFA_left/', contrastBaseline];

% load mask
ROI = spm_vol(Mask_file);
[ROI_dat,XYZ] = spm_read_vols(ROI,0);
ROI_xyz = XYZ(:,find(ROI_dat > 0));    % mm space


% create txt file
fid = fopen([roi_dir,'/', fileWords , contrastBaseline '_old.txt'],'a'); %creates txt file, if it doesn't exist yet

% fprintf(fid, 'Contrast: \t');
% fprintf(fid, '%s\n', contrastBaseline);
fprintf(fid, 'Subjects \t max_beta \t x \t y \t z\n');


for i = 1:length(subjectsOld)
    currSubjectOld = subjectsOld{i};
    CON_dirOld = fullfile(subjectsDirOld, currSubjectOld); %output path

    display(currSubjectOld);

    % determine con-files
    cd(CON_dirOld)
    con_files_Baseline = ls('*con_0004.nii'); %WordsVsBaseline


    % extract betas and find max
    betas = [];
    for c = 1:size(con_files_Baseline,1)
        display(['extracting data from file ' con_files_Baseline(c,:) '...']);

        con_tmp_old = spm_vol(con_files_Baseline(c,:));
        con_tmp_old_mat = con_tmp_old.mat;
        for vx = 1:length(ROI_xyz)
            xyz_tmp_old = con_tmp_old_mat\[ROI_xyz(:,vx);1];
            betas(c,vx) = spm_sample_vol(con_tmp_old,xyz_tmp_old(1),xyz_tmp_old(2),xyz_tmp_old(3),0);
        end
        [maxC(c),tmp_old_ind] = max(betas(c,:));
        MNIpeak(c,:) = ROI_xyz(:,tmp_old_ind);
        FileNames{c} = con_files_Baseline(c,:);


        %%%%save in txt file%%%%
        %fprintf(fid,'con files: \t max_beta \t MNI_peak \n');
        fprintf(fid,'%s\t',currSubjectOld); %prints subject name
        fprintf(fid,'%d\t',maxC(c)); %prints max beta values
        fprintf(fid,'%d\t',MNIpeak(c,:)); %prints max peak values
        %fprintf(fid,'\n'); %next line (enter)
        %%%%saved in txt file%%%%%%

    end

    fprintf(fid,'\n'); %next line (enter)

end

fclose(fid); %close txt file
cd(roi_dir);


display('WordsVsBaseline Old done');


%% WordsVsBaseline Rev

subjectsDirRev = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/1st_Level_Analysis/glm_rev/';
subjectsRev = dir([subjectsDirRev,'BIO*']);% list of your participants. Same name as their folders!
subjectsRev = [subjectsRev; dir([subjectsDirRev,'LOC*'])];
subjectsRev = {subjectsRev.name};


% load mask
ROI = spm_vol(Mask_file);
[ROI_dat,XYZ] = spm_read_vols(ROI,0);
ROI_xyz = XYZ(:,find(ROI_dat > 0));    % mm space


% create txt file
fid = fopen([roi_dir,'/',fileWords , contrastBaseline '_rev.txt'],'a'); %creates txt file, if it doesn't exist yet

% fprintf(fid, 'Contrast: \t');
% fprintf(fid, '%s\n', contrastBaseline);
fprintf(fid, 'Subjects \t max_beta \t x \t y \t z\n');


for i = 1:length(subjectsRev)
    currSubjectRev = subjectsRev{i};
    CON_dirRev = fullfile(subjectsDirRev, currSubjectRev); %output path

    display(currSubjectRev);

    % determine con-files
    cd(CON_dirRev)


    % extract betas and find max
    betas = [];
    for c = 1:size(con_files_Baseline,1)
        display(['extracting data from file ' con_files_Baseline(c,:) '...']);

        con_tmp_rev = spm_vol(con_files_Baseline(c,:));
        con_tmp_rev_mat = con_tmp_rev.mat;
        for vx = 1:length(ROI_xyz)
            xyz_tmp_rev = con_tmp_rev_mat\[ROI_xyz(:,vx);1];
            betas(c,vx) = spm_sample_vol(con_tmp_rev,xyz_tmp_rev(1),xyz_tmp_rev(2),xyz_tmp_rev(3),0);
        end
        [maxC(c),tmp_rev_ind] = max(betas(c,:));
        MNIpeak(c,:) = ROI_xyz(:,tmp_rev_ind);
        FileNames{c} = con_files_Baseline(c,:);


        %%%%save in txt file%%%%
        %fprintf(fid,'con files: \t max_beta \t MNI_peak \n');
        fprintf(fid,'%s\t',currSubjectRev); %prints subject name
        fprintf(fid,'%d\t',maxC(c)); %prints max beta values
        fprintf(fid,'%d\t',MNIpeak(c,:)); %prints max peak values
        %fprintf(fid,'\n'); %next line (enter)
        %%%%saved in txt file%%%%%%

    end

    fprintf(fid,'\n'); %next line (enter)

end

fclose(fid); %close txt file
cd(roi_dir);


display('WordsVsBaseline Rev done');



%% WordsVsFaces Old

subjectsDirOld = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/1st_Level_Analysis/glm_old/';
subjectsOld = dir([subjectsDirOld,'BIO*']);% list of your participants. Same name as their folders!
subjectsOld = [subjectsOld; dir([subjectsDirOld,'LOC*'])];
subjectsOld = {subjectsOld.name};


contrastFaces = 'WordsVsFaces'
roi_dir = ['/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/Statistical_analysis/ROI/Coordinates/VWFA_left/', contrastFaces];

% load mask
ROI = spm_vol(Mask_file);
[ROI_dat,XYZ] = spm_read_vols(ROI,0);
ROI_xyz = XYZ(:,find(ROI_dat > 0));    % mm space


% create txt file
fid = fopen([roi_dir,'/', fileWords , contrastFaces '_old.txt'],'a'); %creates txt file, if it doesn't exist yet

% fprintf(fid, 'Contrast: \t');
% fprintf(fid, '%s\n', contrastBaseline);
fprintf(fid, 'Subjects \t max_beta \t x \t y \t z\n');


for i = 1:length(subjectsOld)
    currSubjectOld = subjectsOld{i};
    CON_dirOld = fullfile(subjectsDirOld, currSubjectOld); %output path
    
    display(currSubjectOld);

    % determine con-files
    cd(CON_dirOld)
    con_files_Faces = ls('*con_0002.nii'); %WordsVsFaces
    

    % extract betas and find max
    betas = [];
    for c = 1:size(con_files_Faces,1)
        display(['extracting data from file ' con_files_Faces(c,:) '...']);
    
        con_tmp_old = spm_vol(con_files_Faces(c,:));
        con_tmp_old_mat = con_tmp_old.mat;
        for vx = 1:length(ROI_xyz)
            xyz_tmp_old = con_tmp_old_mat\[ROI_xyz(:,vx);1];
            betas(c,vx) = spm_sample_vol(con_tmp_old,xyz_tmp_old(1),xyz_tmp_old(2),xyz_tmp_old(3),0);
        end
        [maxC(c),tmp_old_ind] = max(betas(c,:));
        MNIpeak(c,:) = ROI_xyz(:,tmp_old_ind);
        FileNames{c} = con_files_Faces(c,:);

    
        %%%%save in txt file%%%%
        %fprintf(fid,'con files: \t max_beta \t MNI_peak \n');
        fprintf(fid,'%s\t',currSubjectOld); %prints subject name
        fprintf(fid,'%d\t',maxC(c)); %prints max beta values
        fprintf(fid,'%d\t',MNIpeak(c,:)); %prints max peak values
        %fprintf(fid,'\n'); %next line (enter)
        %%%%saved in txt file%%%%%%

    end
    
    fprintf(fid,'\n'); %next line (enter)

end

fclose(fid); %close txt file
cd(roi_dir);


display('WordsVsFaces Old done');


%% WordsVsFaces Rev

subjectsDirRev = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/1st_Level_Analysis/glm_rev/';
subjectsRev = dir([subjectsDirRev,'BIO*']);% list of your participants. Same name as their folders!
subjectsRev = [subjectsRev; dir([subjectsDirRev,'LOC*'])];
subjectsRev = {subjectsRev.name};


% load mask
ROI = spm_vol(Mask_file);
[ROI_dat,XYZ] = spm_read_vols(ROI,0);
ROI_xyz = XYZ(:,find(ROI_dat > 0));    % mm space


% create txt file
fid = fopen([roi_dir,'/',fileWords , contrastFaces '_rev.txt'],'a'); %creates txt file, if it doesn't exist yet

% fprintf(fid, 'Contrast: \t');
% fprintf(fid, '%s\n', contrastBaseline);
fprintf(fid, 'Subjects \t max_beta \t x \t y \t z\n');


for i = 1:length(subjectsRev)
    currSubjectRev = subjectsRev{i};
    CON_dirRev = fullfile(subjectsDirRev, currSubjectRev); %output path
    
    display(currSubjectRev);

    % determine con-files
    cd(CON_dirRev)


    % extract betas and find max
    betas = [];
    for c = 1:size(con_files_Faces,1)
        display(['extracting data from file ' con_files_Faces(c,:) '...']);
    
        con_tmp_rev = spm_vol(con_files_Faces(c,:));
        con_tmp_rev_mat = con_tmp_rev.mat;
        for vx = 1:length(ROI_xyz)
            xyz_tmp_rev = con_tmp_rev_mat\[ROI_xyz(:,vx);1];
            betas(c,vx) = spm_sample_vol(con_tmp_rev,xyz_tmp_rev(1),xyz_tmp_rev(2),xyz_tmp_rev(3),0);
        end
        [maxC(c),tmp_rev_ind] = max(betas(c,:));
        MNIpeak(c,:) = ROI_xyz(:,tmp_rev_ind);
        FileNames{c} = con_files_Faces(c,:);

    
        %%%%save in txt file%%%%
        %fprintf(fid,'con files: \t max_beta \t MNI_peak \n');
        fprintf(fid,'%s\t',currSubjectRev); %prints subject name
        fprintf(fid,'%d\t',maxC(c)); %prints max beta values
        fprintf(fid,'%d\t',MNIpeak(c,:)); %prints max peak values
        %fprintf(fid,'\n'); %next line (enter)
        %%%%saved in txt file%%%%%%

    end
    
    fprintf(fid,'\n'); %next line (enter)

end

fclose(fid); %close txt file
cd(roi_dir);


display('WordsVsFaces Rev done');
end


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

Mask_file = '/path/to/your/mask.nii';
file = 'filename' %enter a name for the output file


%%% there are 2 word-processing contrasts: WordsVsBaseline and WordsVsFaces
%% WordsVsBaseline

subjectsDir = '/path/to/your/first/level/folder/glm/';
subjects = dir([subjectsDir,'sub-*']);% list of your participants (sub-...). Same name as their folders!
subjects = {subjects.name};


contrastBaseline = 'WordsVsBaseline'
roi_dir = ['/path/to/folder/whereoutput/should/be/saved/', contrastBaseline];

% load mask
ROI = spm_vol(Mask_file);
[ROI_dat,XYZ] = spm_read_vols(ROI,0);
ROI_xyz = XYZ(:,find(ROI_dat > 0));    % mm space


% create txt file
fid = fopen([roi_dir,'/', file , contrastBaseline '.txt'],'a'); %creates txt file, if it doesn't exist yet

% fprintf(fid, 'Contrast: \t');
% fprintf(fid, '%s\n', contrastBaseline);
fprintf(fid, 'Subjects \t max_beta \t x \t y \t z\n');


for i = 1:length(subjects)
    currSubject = subjects{i};
    CON_dir = fullfile(subjectsDir, currSubject); % output path

    display(currSubject);

    % determine con-files
    cd(CON_dir)
    con_files_Baseline = ls('*con_0004.nii'); % WordsVsBaseline


    % extract betas and find max
    betas = [];
    for c = 1:size(con_files_Baseline,1)
        display(['extracting data from file ' con_files_Baseline(c,:) '...']);

        con_tmp = spm_vol(con_files_Baseline(c,:));
        con_tmp_mat = con_tmp.mat;
        for vx = 1:length(ROI_xyz)
            xyz_tmp = con_tmp_mat\[ROI_xyz(:,vx);1];
            betas(c,vx) = spm_sample_vol(con_tmp,xyz_tmp(1),xyz_tmp(2),xyz_tmp(3),0);
        end
        [maxC(c),tmp_ind] = max(betas(c,:));
        MNIpeak(c,:) = ROI_xyz(:,tmp_ind);
        FileNames{c} = con_files_Baseline(c,:);


        %%%%save in txt file%%%%
        %fprintf(fid,'con files: \t max_beta \t MNI_peak \n');
        fprintf(fid,'%s\t',currSubject); %prints subject name
        fprintf(fid,'%d\t',maxC(c)); %prints max beta values
        fprintf(fid,'%d\t',MNIpeak(c,:)); %prints max peak values
        %fprintf(fid,'\n'); %next line (enter)
        %%%%saved in txt file%%%%%%

    end

    fprintf(fid,'\n'); %next line (enter)

end

fclose(fid); %close txt file
cd(roi_dir);


display('WordsVsBaseline done');



%% WordsVsFaces

subjectsDir = '/path/to/your/first/level/folder/glm/';
subjects = dir([subjectsDir,'sub-*']);% list of your participants (sub-...). Same name as their folders!
subjects = {subjects.name};


contrastFaces = 'WordsVsFaces'
roi_dir = ['/Upath/to/folder/whereoutput/should/be/saved/', contrastBaseline];

% load mask
ROI = spm_vol(Mask_file);
[ROI_dat,XYZ] = spm_read_vols(ROI,0);
ROI_xyz = XYZ(:,find(ROI_dat > 0));    % mm space


% create txt file
fid = fopen([roi_dir,'/', file , contrastFaces '.txt'],'a'); %creates txt file, if it doesn't exist yet

% fprintf(fid, 'Contrast: \t');
% fprintf(fid, '%s\n', contrastBaseline);
fprintf(fid, 'Subjects \t max_beta \t x \t y \t z\n');


for i = 1:length(subjects)
    currSubject = subjects{i};
    CON_dir = fullfile(subjectsDir, currSubject); %output path
    
    display(currSubjectOld);

    % determine con-files
    cd(CON_dir)
    con_files_Faces = ls('*con_0002.nii'); %WordsVsFaces
    

    % extract betas and find max
    betas = [];
    for c = 1:size(con_files_Faces,1)
        display(['extracting data from file ' con_files_Faces(c,:) '...']);
    
        con_tmp = spm_vol(con_files_Faces(c,:));
        con_tmp_mat = con_tmp.mat;
        for vx = 1:length(ROI_xyz)
            xyz_tmp = con_tmp_mat\[ROI_xyz(:,vx);1];
            betas(c,vx) = spm_sample_vol(con_tmp,xyz_tmp(1),xyz_tmp(2),xyz_tmp(3),0);
        end
        [maxC(c),tmp_ind] = max(betas(c,:));
        MNIpeak(c,:) = ROI_xyz(:,tmp_ind);
        FileNames{c} = con_files_Faces(c,:);

    
        %%%%save in txt file%%%%
        %fprintf(fid,'con files: \t max_beta \t MNI_peak \n');
        fprintf(fid,'%s\t',currSubject); %prints subject name
        fprintf(fid,'%d\t',maxC(c)); %prints max beta values
        fprintf(fid,'%d\t',MNIpeak(c,:)); %prints max peak values
        %fprintf(fid,'\n'); %next line (enter)
        %%%%saved in txt file%%%%%%

    end
    
    fprintf(fid,'\n'); %next line (enter)

end

fclose(fid); %close txt file
cd(roi_dir);


display('WordsVsFaces done');



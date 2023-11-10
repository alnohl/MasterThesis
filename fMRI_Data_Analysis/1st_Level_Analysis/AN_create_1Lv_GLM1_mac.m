function [matlabbatch] =  AN_create_1Lv_GLM1_mac(regr,pathSubject,subjectPath,subjects,scans,onsets,rpfile,mask_threshold)
    if nargin < 1
        sprintf('No paths provided!');
        return;
    else
    end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%% BATCH FOR 1nd LEVEL %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch=[];
    matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(pathSubject);
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 1.250;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 42;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 21;
    
     %Scans
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans =  scans; 
    
    % onsets1 
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = 'words';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = onsets.words;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).orth = 0;
    % onsets2 
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = 'faces';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = onsets.faces;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).orth = 0;
    % onsets3 
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = 'targets';
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = onsets.targets;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).orth = 0;
       
    % Multiregressors
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = cellstr([subjectPath, '/', 'multiReg.txt']); 
     
    % Continue Batch
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];  
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = mask_threshold;  
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

    % ESTIMATE  %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    % CONTRASTS %%%%%%%%
    %%%%%%%%%%%%%%%%%%%% 
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    %fcontrast 1 
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'Effects of interest';
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = eye(2);
    matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    %t-contrasts  
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'words vs faces';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [1 -1 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    %t-contrasts  
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'faces vs words';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [-1 1 0];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    %t-contrasts 
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'words vs baseline';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [1 0 0];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    %t-contrasts 
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'faces vs baseline';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0 1 0];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none'; 
     
    disp('Batch created.')
 end
 
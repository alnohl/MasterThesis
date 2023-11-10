function timecourseRoi = AN_extractTimeCourse(maskPath, mask, contrast)
% Receives the path and name of the Mask (our ROI) as well as the contrast (epi)
% Extracts the ROI time courses
% 2011 - Frank Scharnowski - Swiss Institute of Technology
% Adapted by Alexandra Nohl, August 2023

resampledTag = 0;

% check if mask and contrast have the same dimension and resample mask if necessary
roi = spm_select('FPList',maskPath,strcat('^',mask));
roiHeader = spm_vol(roi);
epiHeader = spm_vol(contrast(1,:));
epi = cellstr(contrast);
roi = cellstr(roi);
if roiHeader.dim ~= epiHeader.dim
    % check first if resampled version of the ROI exists already
    cd(maskPath);
    if exist(strcat('resampled-',mask),'file') ~=2
        matlabbatch{1}.spm.util.imcalc.input = {
                                            epi{1}
                                            roi{1}
                                            };
        matlabbatch{1}.spm.util.imcalc.output = strcat('resampled-',mask);
        matlabbatch{1}.spm.util.imcalc.outdir = {maskPath};
        matlabbatch{1}.spm.util.imcalc.expression = 'i2';
        matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
        matlabbatch{1}.spm.util.imcalc.options.mask = 0;
        matlabbatch{1}.spm.util.imcalc.options.interp = 1;
        matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
        % apply batch
        fprintf('ROI HAD TO BE RESAMPLED. \n')
        spm_jobman('run',matlabbatch);
        clear matlabbatch
	else
        %fprintf('USE EXISTING RESAMPLED ROI. \n')
    end
    resampledTag = 1;
end

% load ROI (either resampled or original)
if resampledTag == 0;
    roi = spm_select('FPList',maskPath,mask);
    roi = spm_read_vols(spm_vol(roi));
elseif resampledTag == 1;
    roi = spm_select('FPList',maskPath,strcat('resampled-',mask));
    roi = spm_read_vols(spm_vol(roi));
end

% pull out ROI time course
nfiles = size(epi,1);
findvoxels = find(roi>0);
nvoxels = size(findvoxels,1);
timecourseRoi = zeros(nvoxels,nfiles);
for n = 1:nfiles
    epivol = spm_read_vols(spm_vol(cell2mat(epi(n,:))));
    timecourseRoi(:,n) = epivol(findvoxels);   % timecourse for each voxel in the VOI
end


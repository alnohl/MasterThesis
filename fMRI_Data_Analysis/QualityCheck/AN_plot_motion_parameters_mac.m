%% Plot motion parameters
% Both as the normal six motion parameters we get from SPM
% and as framewise displacement values (you need the script "AN_bramila_framewiseDisplacement.m" for that)
% Alexandra Nohl, adapted July 2023 (from Amelie Haugg 2021)


clear all


%% Define paths and variables

dataPath = '/path/to/your/preprocessing/files/epis/'; % the epis folder contains the functional data
batchPath = '/path/to/your/quality/control/scripts';


threshold = 0.9; % choose threshold

run = 1;


Participants = dir([dataPath,'sub-*']);% list of your participants (sub-...). Same name as their folders!
Participants = {Participants.name}


number_above_threshold = zeros(1, length(Participants));
mean_above_threshold = zeros(1, length(Participants));
max_above_threshold = zeros(1, length(Participants));


mean_fwd_value = zeros(1, length(Participants));


%% Motion Parameters

for n = 1 : length(Participants)
    
    p = cell2mat(Participants(n));
    subjDir = [dataPath filesep p filesep];
   
    % load realignment file and save in rp_values
    rp_file = spm_select('FPList',subjDir,['^rp_.*.txt$']);
    rp_values{n} = load(rp_file);
    
    % create input for the framewise displacement script
    cfg.motionparam = rp_file;
    cfg.prepro_suite = 'spm';
    cfg.radius = 50; % 50 is the default value, but you can change it
    
    subject_fwd = AN_bramila_framewiseDisplacement(cfg);
    
    % I save the values in a cell array, so the script doesn't crash if a
    % participant has longer or shorter runs than the others
    fwd{n} = subject_fwd;

    % Create the full file path
    %fileName = [subjDir Participants '.txt'];
    fileName = fullfile(subjDir, ['fwd_' Participants{n} '.txt']);

    % Open file for writing
    fileID = fopen(fileName, 'w');

    % Write entry to file
    fprintf(fileID, '%s\n', subject_fwd);

    % Close the file
    fclose(fileID);
    
    
    % Check for this subject how many times he/she has a framewise
    % displacement value above the threshold (we can change that later)
    
    locations_above_threshold = find(subject_fwd > threshold);
    number_above_threshold(n) = length(locations_above_threshold);
    
    if length(locations_above_threshold) > 0
        max_above_threshold(n) = max(subject_fwd(locations_above_threshold));
        mean_above_threshold(n) = mean(subject_fwd(locations_above_threshold));
    else
        max_above_threshold(n) = 0;
        mean_above_threshold(n) = 0;
    end
    
    %damit nur 1 value pro Proband
    %if length(locations_above_threshold) > 0
    mean_fwd_value(n) = mean(subject_fwd)

end

    
%% Save results

save('output_workspace_motion_rev')
csvwrite('number_above_threshold_rev.csv', number_above_threshold)
csvwrite('mean_above_threshold_rev.csv', mean_above_threshold)
csvwrite('max_above_threshold_rev.csv', max_above_threshold)


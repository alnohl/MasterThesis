%% Plot motion parameters
% Both as the normal six motion parameters we get from SPM
% and as framewise displacement values (you need the script
% "AN_bramila_framewiseDisplacement.m" for that)
% Alexandra Nohl, adapted July 2023 (from Amelie Haugg 2021)


clear all


%% Define paths and variables

dataPath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/Preprocessing/Localizer_old/epis/';
%dataPath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/Preprocessing/Localizer_rev/epis/';
batchPath = '/Users/alexandranohl/Documents/MSc IDB/Master thesis/Projects/Localizer/MRI Data Analysis/Analysis_adults/1st_Level_Analysis/Scripts';


threshold = 0.9; % 0.3 is the deafult for task (0.2 for rest)

run = 1;


Participants = dir([dataPath,'BIO*']);% list of your participants. Same name as their folders!
Participants = [Participants; dir([dataPath,'LOC*'])]; % to add both LOC and BIO subject folders
Participants = {Participants.name}
%Participants = {'LOC03', 'LOC04', 'LOC05', 'LOC06','LOC07', 'LOC08', 'LOC09', 'LOC10', 'LOC11', 'LOC12'}; %use this line if you have a selection of subjects


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
    


   
%% Plot results
    
% % plot motion parameters from SPM
% figure; hold on;
% for i = 1:length(Participants)
%     % first two numbers of subplot indicate number of rows and columns
%     % adapt this according to your participant number
%     subplot(1,1,i); hold on;
%     plot(rp_values{i});
%     % add correction needed
%     %stem(correction_needed{i},'Marker','none','LineWidth',0.1);
%     ylim([-2 2]);
% end    

plot framewise displacement
figure (215)
for i = 1:length(Participants)
    % first two numbers of subplot indicate number of rows and columns
    % adapt this according to your participant number
    subplot(3,2,i); %for localizer old/rev with 6 participants
    plot(fwd{i});
    % change limits of y-axis if you see a lot of movement
    ylim([0 10]);
    xlim([0 180])
    line([0,335],[threshold,threshold],'Color','r');
    line([0,335],[-threshold,-threshold],'Color','r');
end    



%% Save results

save('output_workspace_motion_rev')
csvwrite('number_above_threshold_rev.csv', number_above_threshold)
csvwrite('mean_above_threshold_rev.csv', mean_above_threshold)
csvwrite('max_above_threshold_rev.csv', max_above_threshold)


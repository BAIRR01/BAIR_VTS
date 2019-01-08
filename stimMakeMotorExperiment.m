function stimMakeMotorExperiment(stimParams,  runNum, TR)
% 
% NOTE: This is super hacky at the moment, will update soon 
% 
% 
%
% stimMakeTaskExperiment(stimParams,  runNum, TR)

site = stimParams.experimentSpecs.sites{1};
% imageSizeInPixels = size(stimParams.stimulus.images);

% set up some basic info about the stimulus
numPresentations    = 12;
stimTime            = 5; % seconds
ISI                 = 10;
blockLength = stimTime+ISI ;
trsPerBlock         = round(blockLength/ TR);
blockLength         = trsPerBlock * TR;
experimentLength    = blockLength * numPresentations;
frameRate           = stimParams.display.frameRate;

%for now, just use this to test
onsets = 1: blockLength:experimentLength;
% Match the stimulus presentation to the frame rate
onsets = round(onsets*frameRate)/frameRate;
stimulus.onsets = onsets;


stimulus = [];
stimulus.cmap       = stimParams.stimulus.cmap;
stimulus.srcRect    = stimParams.stimulus.srcRect;
stimulus.dstRect    = stimParams.stimulus.destRect;
stimulus.display    = stimParams.display;
stimulus.cat        = [1 2 3 4];
stimulus.categories = { 'D', 'F', 'V', 'Y'};%'B',

% % Pre-allocate arrays to store images
% images = zeros([imageSizeInPixels length(stimulus.categories)], 'uint8');

% find all the bitmaps
bitmapPth = fullfile(sensorimotorRootPath , 'motor','UMCU-Stimuli', 'bitmaps');
files = dir([bitmapPth '/*jpg']);

% Create the stimuli
for cc = 1:length(stimulus.categories)
    whichImg = contains ({files.name}, stimulus.categories{cc});
    imageForThisTrial = imread(fullfile(files(whichImg).folder, files(whichImg).name));
    resizedIm = imresize(imageForThisTrial, [244 134]); %just force this for now
    images(:,:,:,cc) = resizedIm;
end


stimulus.images     = images;
stimulus.seqtiming  = round(0:1/frameRate:experimentLength);

stimulus.seq        = ones(size(stimulus.seqtiming));
% for ll = 1:length(onsets)
%     stimulus.seq(1:blockLength = onsets(ll))
    


% stimulus.fixSeq     = ones(size(stimulus.seqtiming));

% idx = mod(stimulus.seqtiming,blockLength*2)<blockLength;
%  stimulus.fixSeq(idx) = 3;
% 
% 
% % Add triggers for non-fMRI modalities
% switch lower(stimParams.modality)
%     case 'fmri'
%         % no trigger sequence needed
%     otherwise
%         % Write binary trigger sequence:
%         stimulus.trigSeq   = blips;
% end
%
% % Sparsify stimulus sequence
% maxUpdateInterval = 0.25;
% stimulus = sparsifyStimulusStruct(stimulus, maxUpdateInterval);

% Create stim_file name
fname = sprintf('%s_motor_%d.mat', site, runNum);

% Add table with elements to write to tsv file for BIDS
conditions  = { 'D', 'F', 'V', 'Y'};
condition_idx = mod(0:numPresentations-1,2)+1;

onset       = ((0:numPresentations-1)*blockLength)';
duration    = ones(size(onset)) * blockLength;
trial_type  = stimulus.cat(condition_idx)';
trial_name  = conditions(condition_idx)';
stim_file   = repmat(fname, length(onset),1);
stim_file_index = ones(size(onset));

stimulus.tsv = table(onset, duration, trial_type, trial_name, stim_file, stim_file_index);

% Save
fprintf('[%s]: Saving stimuli in: %s\n', mfilename, fullfile(vistadispRootPath, 'StimFiles',  fname));
save(fullfile(vistadispRootPath, 'StimFiles',  fname), 'stimulus')

end



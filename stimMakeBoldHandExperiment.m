function stimMakeBoldHandExperiment(stimParams,  runNum, TR, stimDurationSeconds)
% stimMakeTaskExperiment(stimParams,  runNum, TR)

site = stimParams.experimentSpecs.sites{1};
% 9 alternations of 24 s (12 s task, 12 s no task)

numBlocks           = 54;
desiredBblockLength = 0.5; % seconds
trsPerBlock         = round(desiredBblockLength / TR);
blockLength         = trsPerBlock * TR;
experimentLength    = blockLength * numBlocks;
frameRate           = stimParams.display.frameRate;

stimulus = [];
stimulus.cmap       = stimParams.stimulus.cmap;
stimulus.srcRect    = stimParams.stimulus.srcRect;
stimulus.dstRect    = stimParams.stimulus.destRect;
stimulus.display    = stimParams.display;

stimulus.images     = [];
stimulus.cat        = [1 2];
stimulus.categories = {'CLENCH', 'REST'};

stimulus.seqtiming  = 0:1/frameRate:experimentLength;
stimulus.seq        = ones(size(stimulus.seqtiming));
stimulus.fixSeq     = ones(size(stimulus.seqtiming));

idx = mod(stimulus.seqtiming,blockLength*2)<blockLength;
stimulus.fixSeq(idx) = 3;

switch(lower(stimParams.modality))
        case 'fmri'
            minISI   = 3; % seconds
            maxISI   = 18;  % seconds
            prescan  = round(30/TR)*TR; % seconds 
            postscan = prescan; 

            % Jitter ITIs
            ISIs = linspace(ITI_min,ITI_max,numberOfStimuli-1);                

            % Round off to onsetMultiple
            ISIs = round(ITIs/onsetTimeMultiple)*onsetTimeMultiple;

        case {'ecog' 'eeg' 'meg'}
            ITI_min  = 1.25;
            ITI_max  = 1.75;
            prescan  = 3; % seconds
            postscan = 3; % seconds

            % Jitter ITIs
            ITIs = linspace(ITI_min,ITI_max,numberOfStimuli-1);

        otherwise
            error('Unknown modality')
end

%fixSeq = createFixationSequence(stimulus, 1/frameRate, minISI, maxISI);
blips  = abs(diff([1 fixSeq]))>0;

stimulus.fixSeq(blips) = stimulus.fixSeq(blips)+1;

% For this motor task, the fixation changes are the task instructions
% (clench vs rest). So we use the fixation sequence to define the
% stimulus.seq and stimulus.trigSeq:
stimulus.seq = stimulus.fixSeq;

% Add triggers for non-fMRI modalities
switch lower(stimParams.modality)
    case 'fmri' 
        % no trigger sequence needed
    otherwise
        % Write binary trigger sequence:
        stimulus.trigSeq = blips;
end

% Sparsify stimulus sequence % ADAPT THIS FOR MOTOR??
%maxUpdateInterval = 0.25;
%stimulus = sparsifyStimulusStruct(stimulus, maxUpdateInterval);

% Create stim_file name
fname = sprintf('%s_boldhandtask_%d.mat', site, runNum);

% Add table with elements to write to tsv file for BIDS
conditions  = {'clench' 'rest'};
condition_idx = mod(0:numBlocks-1,2)+1;

onset       = ((0:numBlocks-1)*blockLength)';
duration    = ones(size(onset)) * blockLength;
trial_type  = stimulus.cat(condition_idx)';
trial_name  = conditions(condition_idx)';
stim_file   = repmat(fname, length(onset),1);
stim_file_index = zeros(size(onset));

stimulus.tsv = table(onset, duration, trial_type, trial_name, stim_file, stim_file_index);

% Save
fprintf('[%s]: Saving stimuli in: %s\n', mfilename, fullfile(vistadispRootPath, 'StimFiles',  fname));
save(fullfile(vistadispRootPath, 'StimFiles',  fname), 'stimulus')

end



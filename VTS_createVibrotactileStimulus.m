% Creates a matrix containing the signal for the stimulation pattern for
% the Vibrotactile device. Also adds a blank to the beginning of the
% experiment for running at the 3T

function [vibrotactileStimulus, tsv, fileName] = VTS_createVibrotactileStimulus(params, VTSOpts, VTSExperimentOpts)

%% Check for Options and inputs
if exist('params' , 'var') && ~isempty(params)
    experiment      = params.experiment;
    makeFigure      = params.makeFigure;
    subjID          = params.subjID;
    sessionID       = params.sessionID;
    runID           = params.runID;
else
    error('specifications needed');
end

if exist('VTSOpts' , 'var') && ~isempty(VTSOpts)
    nrStimulators                       = VTSOpts.nrStimulators;
    NIdaqRate                           = VTSOpts.NIdaqRate;
else
    error('specifications needed');
end


if exist('VTSExperimentOpts' , 'var') && ~isempty(VTSExperimentOpts)
    nrStimPerCycle           = VTSExperimentOpts.nrStimPerCycle;
    nrBlanksPerCycle         = VTSExperimentOpts.nrBlanksPerCycle;
    nrCyclesPerExp           = VTSExperimentOpts.nrCyclesPerExp;
    preExpBlanks             = VTSExperimentOpts.preExpBlanks;
    postExpBlanks            = VTSExperimentOpts.postExpBlanks;
    blankStimDur             = VTSExperimentOpts.blankStimDur;
    vibrFreq                 = VTSExperimentOpts.vibrFreq;
    nrPulsesPerStim          = VTSExperimentOpts.nrPulsesPerStim;
    pulseOnDur               = VTSExperimentOpts.pulseOnDur; 
    stimDur                  = VTSExperimentOpts.stimDur;
else
    error('specifications needed');
end

%% Figure out duration of On/Off periods

if mod( blankStimDur, stimDur) ~= 0 
    error('Number of pulses does not match stimulus duration')
end

pulseOffDur = ((stimDur*1000)/ nrPulsesPerStim) - pulseOnDur;

% Store durations (in msec or sec up to now) in samples
pulseOnDurSamp = (pulseOnDur/1000) * NIdaqRate; %msec
pulseOffDurSamp = (pulseOffDur/1000) * NIdaqRate; % msec

blankStimDurRatio = blankStimDur/ stimDur;
%% Make the signal

% Make a different stimulator index depending on experiment, 1 tactile
% stimulus on, 0 tactile stimulus off at respective stimulator
switch experiment
    % Alternation between two different tactile stimuli (3 stimulators per stimuli)
    % and blanks equal to 2*length(stimulus)
   case 'blocked'
        % create matrix that holds in which rows = idx within cycle and columns = stimulators
         stimDesignMatrix = zeros((nrStimPerCycle  * blankStimDurRatio * nrCyclesPerExp...
            + nrBlanksPerCycle * blankStimDurRatio * nrCyclesPerExp...
            + preExpBlanks * blankStimDurRatio...
            + postExpBlanks * blankStimDurRatio) , nrStimulators);
        
        % loop through the cycles
        for jj = 1:nrCyclesPerExp
            % loop through the stimuli in a cycle
            for ii = 1:nrStimPerCycle
                % loop through the stimuli in a cycle
                for kk = 1:blankStimDurRatio
                    stimDesignMatrix(...
                        1 + (ii-1) * 2 ...
                        + (jj-1)*(nrStimPerCycle*blankStimDurRatio... 
                        + nrBlanksPerCycle*blankStimDurRatio) ...
                        + (kk-1) ...
                        + ii*blankStimDurRatio ...
                        + preExpBlanks*blankStimDurRatio,...
                        [1,3,5]*mod(kk,2) + [2,4,6]*mod(kk+1,2)) = 1;
                end
            end
        end
        % from low stimulator number to high stimulator number with blanks
        % at beginning and end
    case 'ascending'
        % create matrix in which stimulators will be switched on one at a
        % time in ascending order where rows = idx within cycle and 
        % columns = stimulators
        stimDesignMatrix = zeros(nrStimPerCycle * nrCyclesPerExp ...
            + nrBlanksPerCycle * blankStimDurRatio * nrCyclesPerExp ...
            + preExpBlanks*blankStimDurRatio ...
            + postExpBlanks*blankStimDurRatio, nrStimulators);
        % loop through the cycles
        for jj = 1:nrCyclesPerExp
            % loop through the tactile stimuli in a cylce
            for ii = 1:nrStimPerCycle
                stimDesignMatrix(ii+(jj-1)*nrStimPerCycle+preExpBlanks*blankStimDurRatio,ii) = 1;
            end
        end
        % from high stimulator number to low stimulator number with blanks at
        % beginning and end
    case 'descending'
       % create matrix in which stimulators will be switched on one at a
        % time in descending order where rows = idx within cycle and 
        % columns = stimulators
        stimDesignMatrix = zeros(nrStimPerCycle * nrCyclesPerExp ...
            + nrBlanksPerCycle * blankStimDurRatio * nrCyclesPerExp ...
            + preExpBlanks*blankStimDurRatio ...
            + postExpBlanks*blankStimDurRatio, nrStimulators);
        % loop through the cycles
        for jj = 1:nrCyclesPerExp
            % loop through the tactile stimuli in a cylce
            for ii = 1:nrStimPerCycle
                stimDesignMatrix(ii+(jj-1)*nrStimPerCycle+preExpBlanks*blankStimDurRatio,nrStimPerCycle+1-ii) = 1;
            end
        end
    otherwise
        error ('No stimulation sequence specified')
end

% One base unit of tactile stimulation vibrating with tactile frequency for
% base on time and not vibrating for tactile off time (in samples)
vibrInSamples = vibrFreq/ NIdaqRate;
pulse = [1 + sin(linspace(0, 2 * pi * vibrInSamples * pulseOnDurSamp ,...
    pulseOnDurSamp)'); zeros(pulseOffDurSamp, 1)];

% signal for one tactile stimulus (e.g., per finger)
stimulusSignal          = repmat(pulse, nrPulsesPerStim, 1); % signal for one tactile stimulus
stimulusSignalDuration  = length(stimulusSignal);%in samples

% Prepare matrix with all signals to send to the stimulators
vibrotactileStimulus = zeros(size(stimDesignMatrix,1)*stimulusSignalDuration,...
    nrStimulators);

% Loop through the stimulus sequence
for jj = 1:size(stimDesignMatrix,1)
    % Loop through the stimulators
    for kk = 1:size(stimDesignMatrix,2)
        % Insert the tactile signal at the respective time point and stimulator
        vibrotactileStimulus((1:stimulusSignalDuration)...
            + (jj - 1)*stimulusSignalDuration,kk) ...
            = stimulusSignal * stimDesignMatrix(jj, kk);
     end
end
 
%% Save stimulus matrix, tsv info and make figures
fileName = sprintf('sub-%s_ses-%s_task-%s_run-%d', subjID, sessionID, experiment,runID);

save(fullfile('./Stimuli',sprintf('%s.mat', fileName)),...
    'vibrotactileStimulus','params', 'VTSOpts', 'VTSExperimentOpts','stimDesignMatrix')

% check whether figures should be made
if makeFigure == 1
    % save figure with images of stimulus
    f = figure('visible', 'off');
    imagesc(stimDesignMatrix)
    title (experiment)
    xlabel('Stimulators');
    ylabel(['Stimulus units (1 unit = ', num2str(stimDur), ' s)']);
    saveas(f, fullfile('./StimImages', sprintf('%s.png',fileName)))
end

%% Set values for tsv file

% find the onsets and stimulator numbers using the experiment design matrix
% to find the time point when a stimulus is presented (a 0 becomes a 1)
 [onsets, stimNums] = find(diff(stimDesignMatrix)==1);
     sortedOnsets = sort(onsets);
 for ii = 1: length(onsets)
 idx = find(onsets == sortedOnsets(ii));
    tsv.onsets(ii) = sortedOnsets(ii)*stimDur;
    tsv.duration(ii) = stimDur; %in seconds
    tsv.stimNums (ii)  = {stimNums(idx)'};
    tsv.stimFile{ii} = sprintf('%s.mat', fileName);
    tsv.trialType{ii} = experiment;
 end
end

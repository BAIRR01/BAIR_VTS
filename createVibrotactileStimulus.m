% Creates a matrix containing the signal for the stimulation pattern for
% the Vibrotactile device. Also adds a blank to the beginning of the
% experiment for running at the 3T

function vibrotactileStimulus = createVibrotactileStimulus(experiment, VTSOptions)

%% Check for Options and inputs
if exist('VTSOptions' , 'var') && ~isempty(VTSOptions)
    nrStimulators                       = VTSOptions.nrStimulators;
    tactileFrequency                    = VTSOptions.tactileFrequency;
    nrOnOffPeriodsPerStimulus           = VTSOptions.nrOnOffPeriodsPerStimulus;
    nrStimuliPerCycle                   = VTSOptions.nrStimuliPerCycle;
    nrBlanksPerCycle                    = VTSOptions.nrBlanksPerCycle;
    nrCyclesPerExperiment               = VTSOptions.nrCyclesPerExperiment;
    NIdaqRate                           = VTSOptions.NIdaqRate;
    onDuration                          = VTSOptions.onDuration;
    offDuration                         = VTSOptions.offDuration;
    blankTactileStimulusDurationRatio   = VTSOptions.blankTactileStimulusDurationRatio;
else
    error('specifications needed');
end

% without specification of the experiment nothing will work
if ~experiment, return; end


%% Make the signal

% create matrix that holds the per stimulus in sequence which stimulators
% will be switched on, rows = idx within cycle, columns = stimulators
stimulusOrder = zeros(nrStimuliPerCycle * nrCyclesPerExperiment + nrBlanksPerCycle*blankTactileStimulusDurationRatio, nrStimulators);

% Make a different stimulator index depending on experiment, 1 tactile
% stimulus on, 0 tactile stimulus of at respective stimulator
switch experiment
    % random stimulators with blanks
    % at beginning and end
    case 'random'
        % loop through the cycles
        for j = 1:nrCyclesPerExperiment
            tmp = randperm(nrStimuliPerCycle);
            % loop through the tactile stimuli in a cylce
            for i = 1:nrStimuliPerCycle
                stimulusOrder(i+(j-1)*nrStimuliPerCycle + nrBlanksPerCycle*blankTactileStimulusDurationRatio/2,tmp(i)) = 1;
            end
        end
        % from low stimulator number to high stimulator number with blanks
        % at beginning and end
    case 'ascending'
        % loop through the cycles
        for j = 1:nrCyclesPerExperiment
            % loop through the tactile stimuli in a cylce
            for i = 1:nrStimuliPerCycle
                stimulusOrder(i+(j-1)*nrStimuliPerCycle+nrBlanksPerCycle*blankTactileStimulusDurationRatio/2,i) = 1;
            end
        end
        % from high stimulator number to low stimulator number with blanks at
        % beginning and end
    case 'descending'
        % loop through the cycles
        for j = 1:nrCyclesPerExperiment
            % loop through the tactile stimuli in a cylce
            for i = 1:nrStimuliPerCycle
                stimulusOrder(i+(j-1)*nrStimuliPerCycle+nrBlanksPerCycle*blankTactileStimulusDurationRatio/2,nrStimuliPerCycle+1-i) = 1;
            end
        end
    otherwise
        error ('No stimulation sequence specified')
end


% One base unit of tactile stimulation vibrating with tactile frequency for
% base on time and not vibrating for tactile off time (in samples)
onOffPeriod = [1 + sin(...
    linspace(0,...
    2 * pi * tactileFrequency * onDuration / NIdaqRate,...
    onDuration)'...
    );...
    zeros(offDuration, 1)];

% signal for one tactile stimulus (e.g., per finger)
stimulusSignal          = repmat(onOffPeriod, nrOnOffPeriodsPerStimulus, 1); % signal for one tactile stimulus
stimulusSignalDuration  = length(stimulusSignal);%in samples


% Prepare matrix with all signals to send to the stimulators
vibrotactileStimulus = zeros(size(stimulusOrder,1)*stimulusSignalDuration,...
    nrStimulators);

% Loop through the stimulus sequence
for jj = 1:size(stimulusOrder,1)
    % Loop through the stimulators
    for kk = 1:size(stimulusOrder,2)
        % Insert the tactile signal at the respective time point and stimulator
        vibrotactileStimulus((1:stimulusSignalDuration)...
            + (jj - 1)*stimulusSignalDuration,...
            kk) ...
            = stimulusSignal * stimulusOrder(jj, kk);
    end
end


% Creates a matrix containing the signal for the stimulation pattern for
% the Vibrotactile device. Also adds a blank to the beginning of the
% experiment for running at the 3T

function vibrotactileStimulus = VTS_createVibrotactileStimulus(params, VTSSessionOptions, VTSExperimentOptions)

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

if exist('VTSSessionOptions' , 'var') && ~isempty(VTSSessionOptions)
    nrStimulators                       = VTSSessionOptions.nrStimulators;
    NIdaqRate                           = VTSSessionOptions.NIdaqRate;
else
    error('specifications needed');
end


if exist('VTSExperimentOptions' , 'var') && ~isempty(VTSExperimentOptions)
    nrStimuliPerCycle                   = VTSExperimentOptions.nrStimuliPerCycle;
    nrBlanksPerCycle                    = VTSExperimentOptions.nrBlanksPerCycle;
    nrCyclesPerExperiment               = VTSExperimentOptions.nrCyclesPerExperiment;
    startBlanksPerExperiment            = VTSExperimentOptions.startBlanksPerExperiment;
    endBlanksPerExperiment              = VTSExperimentOptions.endBlanksPerExperiment;
    blankStimulusDuration               = VTSExperimentOptions.blankStimulusDuration;
    tactileFrequency                    = VTSExperimentOptions.tactileFrequency;
    nrOnOffPeriodsPerStimulus           = VTSExperimentOptions.nrOnOffPeriodsPerStimulus;
    tactileStimulusDuration             = VTSExperimentOptions.tactileStimulusDuration;
else
    error('specifications needed');
end

% calculate the number of tactile stimuli that equals a blank
if mod(blankStimulusDuration, tactileStimulusDuration) == 0
    blankTactileStimulusDurationRatio = blankStimulusDuration / tactileStimulusDuration;
else
    error('blank stimulus duration should be a multiple of tactile stimulus druation');
end
% Check for input consistency
if mod(VTSExperimentOptions.tactileStimulusDuration*VTSSessionOptions.NIdaqRate, VTSExperimentOptions.nrOnOffPeriodsPerStimulus) ~= 0
    help(mfilename)
    error('not possible to divide the tactile stimulus into on-off periods of consistent length');
end
% store duration of one on-off period in samples
VTSExperimentOptions.onOffPeriodDuration = VTSExperimentOptions.tactileStimulusDuration*VTSSessionOptions.NIdaqRate / VTSExperimentOptions.nrOnOffPeriodsPerStimulus;
% store duration of one on period in samples
onDuration = round(VTSExperimentOptions.onOffPeriodDuration*VTSExperimentOptions.tactileOnOffRatio);
% store duration of off on period in samples
offDuration = round(VTSExperimentOptions.onOffPeriodDuration*(1-VTSExperimentOptions.tactileOnOffRatio));
% Check for input consistency
if VTSExperimentOptions.onOffPeriodDuration ~= onDuration + offDuration
    help(mfilename)
    error('not possible to create on-off periods of required length');
end

%% Make the signal


% Make a different stimulator index depending on experiment, 1 tactile
% stimulus on, 0 tactile stimulus of at respective stimulator
switch experiment
    % random stimulators with blanks
    % at beginning and end
    case 'blocked'
        % create matrix that holds the per stimulus in sequence which stimulators
        % will be switched on, rows = idx within cycle, columns = stimulators
        stimulusOrder = zeros(nrStimuliPerCycle * blankTactileStimulusDurationRatio * nrCyclesPerExperiment ...
            + nrBlanksPerCycle * blankTactileStimulusDurationRatio * nrCyclesPerExperiment ...
            + startBlanksPerExperiment*blankTactileStimulusDurationRatio ...
            + endBlanksPerExperiment*blankTactileStimulusDurationRatio, nrStimulators);
        % loop through the cycles
        for j = 1:nrCyclesPerExperiment
            % loop through the stimuli in a cycle
            for i = 1:nrStimuliPerCycle
                % loop through the stimuli in a cycle
                for k = 1:blankTactileStimulusDurationRatio
                    stimulusOrder(...
                        1 + (i-1) * 2 ...
                        + (j-1)*(nrStimuliPerCycle*blankTactileStimulusDurationRatio+nrBlanksPerCycle*blankTactileStimulusDurationRatio) ...
                        + (k-1) ...
                        + i*blankTactileStimulusDurationRatio ...
                        + startBlanksPerExperiment*blankTactileStimulusDurationRatio,...
                        [1,3,5]*mod(k,2) + [2,4,6]*mod(k+1,2)) = 1;
                end
            end
        end
        % from low stimulator number to high stimulator number with blanks
        % at beginning and end
    case 'ascending'
        % create matrix that holds the per stimulus in sequence which stimulators
        % will be switched on, rows = idx within cycle, columns = stimulators
        stimulusOrder = zeros(nrStimuliPerCycle * nrCyclesPerExperiment ...
            + nrBlanksPerCycle * blankTactileStimulusDurationRatio * nrCyclesPerExperiment ...
            + startBlanksPerExperiment*blankTactileStimulusDurationRatio ...
            + endBlanksPerExperiment*blankTactileStimulusDurationRatio, nrStimulators);
        % loop through the cycles
        for j = 1:nrCyclesPerExperiment
            % loop through the tactile stimuli in a cylce
            for i = 1:nrStimuliPerCycle
                stimulusOrder(i+(j-1)*nrStimuliPerCycle+startBlanksPerExperiment*blankTactileStimulusDurationRatio,i) = 1;
            end
        end
        % from high stimulator number to low stimulator number with blanks at
        % beginning and end
    case 'descending'
        % create matrix that holds the per stimulus in sequence which stimulators
        % will be switched on, rows = idx within cycle, columns = stimulators
        stimulusOrder = zeros(nrStimuliPerCycle * nrCyclesPerExperiment ...
            + nrBlanksPerCycle * blankTactileStimulusDurationRatio * nrCyclesPerExperiment ...
            + startBlanksPerExperiment*blankTactileStimulusDurationRatio ...
            + endBlanksPerExperiment*blankTactileStimulusDurationRatio, nrStimulators);
        % loop through the cycles
        for j = 1:nrCyclesPerExperiment
            % loop through the tactile stimuli in a cylce
            for i = 1:nrStimuliPerCycle
                stimulusOrder(i+(j-1)*nrStimuliPerCycle+startBlanksPerExperiment*blankTactileStimulusDurationRatio,nrStimuliPerCycle+1-i) = 1;
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

% check whether figures should be made
if makeFigure == 1
    % save figure with images of stimulus
    f = figure('visible', 'off');
    imagesc(stimulusOrder)
    title (experiment)
    xlabel('Stimulators');
    ylabel(['Stimulus units (1 unit = ', num2str(VTSExperimentOptions.tactileStimulusDuration), ' s)']);
    saveas(f, fullfile('./StimImages', sprintf('sub-%s_ses-%s_task-%s_run-%d.png',...
        subjID, sessionID, experiment,runID)))
end
end

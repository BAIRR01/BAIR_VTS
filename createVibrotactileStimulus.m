% Creates a matrix containing the signal for the stimulation pattern for
% the Vibrotactile device. Also adds a blank to the beginning of the
% experiment for running at the 3T

function vibrotactileStimulus = createVibrotactileStimulus(nrStimulators, nrSweeps,...
    stimTime, blankTime, order, VTSOptions, VTSDesviceSess)

%% Check for Options and inputs
if exist('VTSOptions' , 'var') && ~isempty(VTSOptions)
    nrStimulators = VTSOptions.nrStimulators;
    nrSweeps      = VTSOptions.nrSweeps;
    stimTime      = VTSOptions.stimTime;
    order         = VTSOptions.experiment{1};
    blankTime     = VTSOptions.blankTime;
end

% Set defaults if not given
if ~exist('nrStimulators', 'var') || isempty(nrStimulators)
    nrStimulators = 5;
end
if ~exist('order', 'var') || isempty(order)
    order = 'ascending';
end
if ~exist('nrSweeps', 'var') || isempty(nrSweeps)
    nrSweeps = 6;
end
if ~exist('stimTime', 'var') || isempty(stimTime)
    stimTime = 6;
end
if ~exist('blankTime', 'var') || isempty(blankTime)
    blankTime = 12;
end

%% Make the signal 

% Set parameters for making the tactile signal
stimFreq            = 30;   % frequency of signal
stimDur             = 400;  % duration of one continuous tactile stimulation in ms
interStimDur        = 100;  % duration of wait period between stimulations

% One cycle of stimulation to be repeated for each finger
x         = (2 * pi * stimFreq * stimDur/1000);
stimCycle = sin(linspace(0,x, stimDur * VTSDesviceSess.Rate/1000)');

% One cycle of stimulation with pause to be repeated for each finger
fullCycle = [stimCycle; zeros(interStimDur * VTSDesviceSess.Rate/1000, 1)];

% signal for one tactile stimulus (e.g., per finger)
stimPerLocation     = stimTime/(length(fullCycle)/VTSDesviceSess.Rate); % #reps/finger
outputSignal        = repmat(fullCycle,stimPerLocation,1); % signal for one finger
outputSignalLength  = length(outputSignal);

% Make a different stimulator index depending on finger order
switch order
    case 'random'     % random sampling of fingers
        stimOrderIdx = randperm(nrStimulators);
    case 'ascending'  % from thumb towards pinky
        stimOrderIdx = sort((1:nrStimulators), 'ascend');
    case 'descending' % from pinky towards thumb
        stimOrderIdx = sort((1:nrStimulators), 'descend');
    otherwise
        error ('No order sequence specified')
end

% Prepare matrix with all signals to send to the stimulators
vibrotactileStimulus = zeros(2 * blankTime * VTSDesviceSess.Rate ...
    + outputSignalLength * length(stimOrderIdx) * nrSweeps, nrStimulators);

% Loop through the sweeps/cycles of one full stimulus order
for ii = 1:nrSweeps
    % Loop through one stimulus sequence
    for jj = 1:length(stimOrderIdx)
        % Insert the tactile signal at the respective time point and stimulator
        vibrotactileStimulus((1:outputSignalLength) + blankTime * VTSDesviceSess.Rate...
            + (jj - 1)*outputSignalLength + (ii - 1)*outputSignalLength*length(stimOrderIdx),...
            (stimOrderIdx(jj))) = outputSignal;
    end
end


% Runs through the list of sequences from .txt file and calls the appropriate function to
%   start stimulation

function stimulusVibrotactileExperiment = createVibrotactileStimulus(nrStimulators, nrSweeps, stimTime, blankTime, order, VTSOptions, handleVibrotactileDevice)

%% Check for Options

if exist('VTSOptions' , 'var') && ~isempty(VTSOptions)
    nrStimulators = VTSOptions.nrStimulators;
    nrSweeps      = VTSOptions.nrSweeps;
    stimTime      = VTSOptions.stimTime;
    order         = VTSOptions.experiment{1};
    blankTime     = VTSOptions.blankTime;
end

% Set defaults if not given
if ~exist('nrStimulators', 'var') || isempty(nrStimulators)
    nrStimulators     = 5;
end
% Set defaults if not given
if ~exist('order', 'var') || isempty(order)
    order     = 'ascending';
end
% Set defaults if not given
if ~exist('nrSweeps', 'var') || isempty(nrSweeps)
    nrSweeps     = 4;
end
if ~exist('stimTime', 'var') || isempty(stimTime)
    stimTime = 6;
end
if ~exist('blankTime', 'var') || isempty(blankTime)
    blankTime = 12;
end

% Set parameters for making the tactile signal
stimFreq            = 30;   % frequency of signal
stimDur             = 400;  % duration of one continuous tactile stimulation in ms
interStimDur        = 100;  % duration of wait period between stimulations

% One cycle of stimulation to be repeated for each finger
x         = (2 * pi * stimFreq * stimDur/1000);
stimCycle = sin(linspace(0,x, stimDur * handleVibrotactileDevice.Rate/1000)');

% One cycle of stimulation with pause to be repeated for each finger
fullCycle = [stimCycle; zeros(interStimDur * handleVibrotactileDevice.Rate/1000, 1)];

% signal for one tactile stimulus (e.g., per finger)
stimPerLocation     = stimTime/(length(fullCycle)/handleVibrotactileDevice.Rate);
outputSignal        = repmat(fullCycle,stimPerLocation,1);
outputSignalLength  = length(outputSignal);


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

%prepare matrix with all signals send
stimulusVibrotactileExperiment = zeros(2 * blankTime * handleVibrotactileDevice.Rate + outputSignalLength * length(stimOrderIdx) * nrSweeps, nrStimulators);

%loop through the sweeps/cycles of one full stimulus order
for ii = 1:nrSweeps
    %loop through one stimulus sequence
    for jj = 1:length(stimOrderIdx)
        % insert the tactile signal at the respective time point and
        % stimulator
        stimulusVibrotactileExperiment((1:outputSignalLength) + blankTime * handleVibrotactileDevice.Rate + (jj - 1)*outputSignalLength ...
            + (ii - 1)*outputSignalLength*length(stimOrderIdx),...
            (stimOrderIdx(jj))) = outputSignal;
    end
end


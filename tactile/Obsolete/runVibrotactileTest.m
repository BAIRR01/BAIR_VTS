function runVibrotactileTest (nrStimulators, nrSweeps, nrFingers, stimTime, blankTime , VTSOptions)
% Runs a simple tactile experiment
%
% runVibrotactileTest (nrStimulators, nrSweeps, [nrFingers] , [stimTime], [VTSOptions])
%
% Required Input:
%
%   nrStimulators   : Number of stumulators
%   nrSweeps          : Number of repetitions (sweeps)
%
% Optional Input:
%     nrFingers     : Number of fingers to be stimulate
%         default : 5
%     stimTime      : Seconds of stimulation
%         default : 6     
%     VTSOptions    : Struct containing other inputs
%
% Example:
%
% nrStimulators = 5;
% nrSweeps        = 6;
% nrFingers     = 5;
% stimTime      = 6;
%
% runVibrotactileTest (nrStimulators, nrFingers , nrSweeps , stimTime )
%
% Example 2:
%
% VTSOptions.nrStimulators = 5;
% VTSOptions.nrSweeps      = 6;
% VTSOptions.nrFingers     = 5;
% VTSOptions.stimTime      = 6;
%
% runVibrotactileTest ([],[],[],[],[], VTSOptions);

%% Check for Options and Inputs

if exist('VTSOptions' , 'var') && ~isempty(VTSOptions)
    nrStimulators = VTSOptions.nrStimulators;
    nrSweeps      = VTSOptions.nrSweeps;
    nrFingers     = VTSOptions.nrFingers;
    stimTime      = VTSOptions.stimTime;
    orderList     = VTSOptions.experiment;
    blankTime = VTSOptions.blankTime;
end

% Check for Required inputs
if ~exist('nrStimulators', 'var')
    error ('nrStimulators is a required input')
end
if ~exist('nrSweeps', 'var') || isempty(nrSweeps)
    error ('nrSweeps is a required input')
end

% Set defaults if not given
if ~exist('nrFingers', 'var') || isempty(nrFingers)
    nrFingers     = 5;
end
if ~exist('stimTime', 'var') || isempty(stimTime)
    stimTime = 6;
end

%% Set up the session

% Initialize the session and parameters
s       = daq.createSession('ni');
s.Rate  = 1000; % Rate of operation (scans/s)

% DAQ names (each can run up to 10 stimulators)
daq1 =  'cDAQ1mod1';
%daq2 = 'cDAQ1mod2';

% Add all the output channels to the session
for ii = 0: (nrStimulators-1)
    stimName = sprintf('ao%d', ii);
    addAnalogOutputChannel(s,daq1, stimName, 'Voltage');
end

%% Create output tactile signal (for now, use a sin wave)

% Set parameters for making the tactile signal
stimFreq            = 30;   % frequency of signal
stimDur             = 400;  % duration of one continuous tactile stimulation in ms
interStimDur        = 100;  % duration of wait period between stimulations
    
% One cycle of stimulation to be repeated for each finger
x         = (2 * pi * stimFreq * stimDur/1000);
stimCycle = sin(linspace(0,x, stimDur * s.Rate/1000)');

% One cycle of stimulation with pause to be repeated for each finger
fullCycle = [stimCycle; zeros(interStimDur * s.Rate/1000, 1)];

% signal for one tactile stimulus (e.g., per finger)
stimPerLocation     = stimTime/(length(fullCycle)/s.Rate);
outputSignal        = repmat(fullCycle,stimPerLocation,1);

%% Load in the experimental sequence order if not given
if ~exist('orderList', 'var') || isempty(orderList)
    % Prompt user input
    [fname,path] = uigetfile('.txt' ,'Select order sequence file');
    orderList = importdata(fullfile (path,fname));
end

%% Stimulate the piezo stimulators

allOutputs = stimulateFingers(s,outputSignal,nrStimulators, nrSweeps,orderList, nrFingers, blankTime)

 % queue the data and start the vibration
        queueOutputData(s, allOutputs);
        s.startForeground; 
        

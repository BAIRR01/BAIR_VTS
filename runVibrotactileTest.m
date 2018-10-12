function runVibrotactileTest (nrStimulators, nrReps, nrFingers  , stimTime , pauseTime, VTSOptions)
% Runs a simple tactile experiment
%
% runVibrotactileTest (nrStimulators, nrReps, [nrFingers] , [stimTime] , [pauseTime], [VTSOptions])
% 
% Required Input:
% 
%   nrStimulators   : Number of stumulators
%   nrReps          : Number of repetitions
% 
% Optional Input:
%     nrFingers     : Number of fingers to be stimulate 
%         default : 5 
%     stimTime      : Seconds of stimulation
%         default : 12
%     pauseTime     : Seconds to pause
%         default : 12
%     VTSOptions    : Struct containing other inputs
%
% Example:
%
% nrStimulators = 5;     
% nrReps        = 5;     
% nrFingers     = 5;     
% stimTime      = 12;   
% pauseTime     = 12;   
% 
% runVibrotactileTest (nrStimulators, nrFingers , nrReps , stimTime , pauseTime)
% 
% Example 2:
% 
% VTSOptions.nrStimulators = 5;
% VTSOptions.nrReps        = 5;
% VTSOptions.nrFingers     = 5;
% VTSOptions.stimTime      = 12;
% VTSOptions.pauseTime     = 12;
% 
% runVibrotactileTest ([],[],[],[],[], VTSOptions);

% Check for Options

if exist('VTSOptions' , 'var') && ~isempty(VTSOptions)
    nrStimulators = VTSOptions.nrStimulators;
    nrReps        = VTSOptions.nrReps;
    nrFingers     = VTSOptions.nrFingers;
    stimTime      = VTSOptions.stimTime;
    pauseTime     = VTSOptions.pauseTime;
    orderList     = VTSOptions.experiment;
end

% Check for Required inputs
if ~exist('nrStimulators', 'var') 
    error ('nrStimulators is a required input')
end
if ~exist('nrReps', 'var') || isempty(nrReps)
    error ('nrReps is a required input')
end

% Set defaults if not given
if ~exist('nrFingers', 'var') || isempty(nrFingers)
    nrFingers     = 5;
end
if ~exist('stimTime', 'var') || isempty(stimTime)
    stimTime = 12;
end
if ~exist('pauseTime', 'var') || isempty(pauseTime)
    pauseTime     = 12;
end

%% Set up the session

% Initialize the session and parameters
s = daq.createSession('ni');

% Rate of operation in scans per second
s.Rate              = 1000;
% DAQ names (each can run up to 10 stimulators)
daq1 =  'cDAQ1mod1';
%daq2 = 'cDAQ1mod2';

% Create output signal (for now, use a square wave)
outputSignal = square(linspace(0, (2*pi*5),(a.Rate * stimTime)'));

% add all the output channels to the session
for ii = 0: (nrStimulators-1)
    stimName = sprintf('ao%d', ii);
    addAnalogOutputChannel(s,daq1, stimName, 'Voltage');
end

% %% Load in the experimental sequence order 
% 
% % Prompt user input
% [fname,path] = uigetfile('.txt' ,'Select order sequence file');
% orderList = importdata(fullfile (path,fname));

%% Stimulate the piezo stimulators

stimulateFingers(s,outputSignal,nrStimulators, pauseTime, nrReps,orderList, nrFingers)

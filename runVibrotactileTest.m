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

%% Check for Options

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
s.Rate              = 2000;

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
stimPerLocation     = 6;    % number of consecutive stimulations per location (e.g., per finger)

% One cycle of stimulation to be repeated for each finger
x = (2 * pi * stimFreq * stimDur/1000);
stimCycle = sin(linspace(0,x, stimDur * s.Rate/1000)');

% one cycle of stimulation with pause to be repeated for each finger
fullCycle = [stimCycle; zeros(interStimDur * s.Rate/1000, 1)]; 

% signal for one tactile stimulus (e.g., per finger)
outputSignal = repmat(fullCycle,stimPerLocation,1); 

 %% Load in the experimental sequence order if not given

if ~exist('orderList', 'var') || isempty(orderList)
    % Prompt user input
    [fname,path] = uigetfile('.txt' ,'Select order sequence file');
    orderList = importdata(fullfile (path,fname));
end

%% Stimulate the piezo stimulators

stimulateFingers(s,outputSignal,nrStimulators, pauseTime, nrReps,orderList, nrFingers)

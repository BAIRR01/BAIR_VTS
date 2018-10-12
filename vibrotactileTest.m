function runVibrotactileTest (nrStimulators, nrFingers , nrReps , stimTime , pauseTime)




% Initialize the session and parameters
s = daq.createSession('ni');

% Rate of operation in scans per second
s.Rate              = 1000;

stimTime     = 12;   % of stimulation for computation
nrReps        = 5;    % Number of repetitions
nrStimulators = 5;    % Number of stumulators
nrFingers     = 5;    % Number of fingers to be stimulated
pauseTime     = 12;   % in seconds

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

%% Load in the experimental sequence order

% Prompt user input
[fname,path] = uigetfile('.txt' ,'Select order sequence file');
orderList = importdata(fullfile (path,fname));

%% Stimulate the piezo stimulators

stimulateFingers(s,outputSignal,nrStimulators, pauseTime, nrReps,orderList, nrFingers)

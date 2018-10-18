function handleVibrotactileDevice = setupVibrotactileDevice(nrStimulators, VTSOptions)
% sets up the NIdaq device with number of channels equal to nrStimulators
% setupVibrotactileDevice (nrStimulators, [VTSOptions])
%
% Required Input:
%
% nrStimulators   : Number of stumulators
%
% Optional Input:
%
% VTSOptions    : Struct containing other inputs
%
%% Check for Options

if exist('VTSOptions' , 'var') && ~isempty(VTSOptions)
    nrStimulators = VTSOptions.nrStimulators;
end

% Check for Required inputs
if ~exist('nrStimulators', 'var')
    error ('nrStimulators is a required input')
end

%% Set up the session

% Initialize the session and parameters
handleVibrotactileDevice       = daq.createSession('ni');
handleVibrotactileDevice.Rate  = 1000; % Rate of operation (scans/s)

% DAQ names (each can run up to 10 stimulators)
daq1 =  'cDAQ1mod1';
%daq2 = 'cDAQ1mod2';

% Add all the output channels to the session
for ii = 0:(nrStimulators-1)
    stimName = sprintf('ao%d', ii);
    addAnalogOutputChannel(handleVibrotactileDevice,daq1, stimName, 'Voltage');
end

fprintf('NIdaq box successfully initialized')

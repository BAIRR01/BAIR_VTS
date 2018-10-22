function VTSDevice = setupVibrotactileDevice(VTSOptions)
% sets up the NIdaq device with number of channels equal to nrStimulators
% setupVibrotactileDevice (VTSOptions)
%
% Required Input:
%
% VTSOptions    : Struct containing inputs for vibrotactile experiment
%
%% Check for Options and inputs

if exist('VTSOptions' , 'var') && ~isempty(VTSOptions)
    nrStimulators = VTSOptions.nrStimulators;
    NIdaqRate = VTSOptions.NIdaqRate;
end
if ~exist('nrStimulators', 'var')
    error ('nrStimulators is a required input')
end
if ~exist('NIdaqRate', 'var')
    error ('NIdaqRate is a required input')
end

%% Set up the session

% Initialize the session and parameters
VTSDevice       = daq.createSession('ni');
VTSDevice.Rate  = NIdaqRate; % Rate of operation (scans/s)

% DAQ names (each can run up to 10 stimulators)
daq1 =  'cDAQ1mod1';

% Add all the output channels to the session
for ii = 0:(nrStimulators-1)
    stimName = sprintf('ao%d', ii);
    addAnalogOutputChannel(VTSDevice, daq1, stimName, 'Voltage');
end

fprintf('NIdaq box successfully initialized')
end

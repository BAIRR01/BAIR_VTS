function VTSDeviceSess = setupVibrotactileDevice(nrStimulators, VTSOptions)
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
%% Check for Options and inputs

if exist('VTSOptions' , 'var') && ~isempty(VTSOptions)
    nrStimulators = VTSOptions.nrStimulators;
end
if ~exist('nrStimulators', 'var')
    error ('nrStimulators is a required input')
end

%% Set up the session

% Initialize the session and parameters
VTSDeviceSess       = daq.createSession('ni');
VTSDeviceSess.Rate  = 1000; % Rate of operation (scans/s)

% DAQ names (each can run up to 10 stimulators)
daq1 =  'cDAQ1mod1';
%daq2 = 'cDAQ1mod2';

% Add all the output channels to the session
for ii = 0:(nrStimulators-1)
    stimName = sprintf('ao%d', ii);
    addAnalogOutputChannel(VTSDeviceSess,daq1, stimName, 'Voltage');
end

fprintf('NIdaq box successfully initialized')
end

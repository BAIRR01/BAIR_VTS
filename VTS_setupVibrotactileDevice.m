function VTSDevice = VTS_setupVibrotactileDevice(VTSOpts)
% sets up the NIdaq device with number of channels equal to nrStimulators
% setupVibrotactileDevice (VTSOptions)
%
% Required Input:
%
% VTSOptions    : Struct containing inputs for vibrotactile experiment
%
%% Check for Options and inputs

if exist('VTSOptions' , 'var') && ~isempty(VTSOpts)
    NIdaqNames = VTSOpts.NIdaqNames;
    nrStimulators = VTSOpts.nrStimulators;
    NIdaqRate = VTSOpts.NIdaqRate;
end
if ~exist('nrStimulators', 'var')
    error ('\n\nnrStimulators is a required input\n\n')
end
if ~exist('NIdaqRate', 'var')
    error ('\n\nNIdaqRate is a required input\n\n')
end

%% Set up the session

% Initialize the session and parameters
VTSDevice       = daq.createSession('ni');
VTSDevice.Rate  = NIdaqRate; % Rate of operation (scans/s)

% DAQ names (each can run up to 10 stimulators)
NIdaqName = NIdaqNames{1};

% Add all the output channels to the session
for ii = 0:(nrStimulators-1)
    stimName = sprintf('ao%d', ii);
    addAnalogOutputChannel(VTSDevice, NIdaqName, stimName, 'Voltage');
end

fprintf('\nNIdaq box successfully initialized\n\n')

end

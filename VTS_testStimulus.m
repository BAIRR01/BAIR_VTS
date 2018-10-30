% What experimental parameters?
[VTSOpts, fileSelected] = VTS_selectSessionOptions();
if ~fileSelected, return; end

% Setup the device
VTSDevice = VTS_setupVibrotactileDevice(VTSOpts);

% creata params structure for this test case
params.experiment = 'ascending';
params.subjID     = 'testingStimulator';
params.makeFigure = 0;
params.sessionID  = 'testingStimulator';
params.runID      = 'testingStimulator';

% select/create json file with stimulus options
stimOptPath = VTS_selectExperimentOptions(params.experiment);
% Read the content of the stimulus json file
json = loadjson(stimOptPath);

% Assign json fields to VTSSessionOptions fields
VTSExperimentOpts = json.VTSExperimentOpts;

% create vibrotactile stimulus
vibrotactileStimulus = VTS_createVibrotactileStimulus(params, VTSOpts, VTSExperimentOpts);

%initialize keyboard
KbCheck;
ListenChar(2);

%initialize response
response = 'x';

% check keyboard input
while (response ~= 'y' && response ~= 'q')
    % flush previous input
    FlushEvents;
    % just print instruction to terminal window
    fprintf('\n\n Press y to start another stimulation and q to quit!\n\n');
    % wait for response
    [response, ~] = GetChar;
    
    % if there should be a stimulation
    if response == 'y'
        
        % queue the data
        queueOutputData(VTSDevice, vibrotactileStimulus);
        
        % present the stimulus
        [startTime,endTime] = VTS_presentStimulus(VTSDevice);
        
        %reset response
        response = 'x';
    end
end

%switch keyboard back on
ListenChar(0);


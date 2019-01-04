%adjust this to tactile experiment

function quitProg = sensoryMotorRunme(experiment, experimentRunID, siteSpecs, subjID,...
    sessionID, VTSOptions, VTSDevice, VTSStimulusOptions , task)
% Check for inputs
if notDefined('siteSpecs')
    help(mfilename)
    error('siteSpecs is a required input');
end
if notDefined('runID'), experimentRunID = 1; end
if notDefined('sessionID'), sessionID = '01'; end
if notDefined('VTSOptions'), VTSOptions = []; end

% Set parameters for this experiment
params.experiment       = experiment;
params.subjID           = subjID;
params.runID            = experimentRunID;
params.sessionID        = sessionID;
params.modality         = siteSpecs.modalities{1};
params.site             = siteSpecs.sites{1};
params.calibration      = siteSpecs.displays{1};
params.triggerKey       = siteSpecs.trigger{1};
params.useSerialPort    = siteSpecs.serialport;
params.useEyeTracker    = siteSpecs.eyetracker;
params.shiftDestRect    = siteSpecs.displaypos;

% Additional parameters
params.prescanDuration  = 0;
params.startScan        = 0;

% Set priority (depends on operating system)
if ispc
    params.runPriority  = 2;
elseif ismac
    params.runPriority  = 7;
end

% Specify fixation
params.fixation = 'cross';

% Debug mode?
params.skipSyncTests = 1;

% store stimulus as figure
params.makeFigure = 1;

% Go!
if contains(task, 'tactile','IgnoreCase',true)
    quitProg = VTS_doExperiment(params, VTSOptions, VTSDevice, VTSStimulusOptions);
elseif contains(task, 'tactile','IgnoreCase',true)
    %figure out if you can use the bair runme for this
end

end

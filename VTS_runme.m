%adjust this to tactile experiment

function quitProg = VTS_runme(experimentOrder, runID, siteSpecs, subjID, sessionID, VTSOptions)

if notDefined('siteSpecs')
    help(mfilename)
    error('siteSpecs is a required input');
end
if notDefined('runID'), runID = 1; end
if notDefined('sessionID'), sessionID = '01'; end
if notDefined('VTSOptions'), VTSOptions = []; end

% Set parameters for this experiment

params.experiment       = experimentOrder;
params.subjID           = subjID;
params.runID            = runID;
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
VTSOptions.experiment   = {params.experiment};

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

% Go!
quitProg = doVTSExperiment(params, VTSOptions);

end

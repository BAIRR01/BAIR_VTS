% Before running, use 'tbUse bairstimuli' and make sure the following path:
% '/Users/winawerlab/MATLAB/toolboxes/Psychtoolbox-3/Psychtoolbox/PsychBasic/MatlabWindowsFilesR2007a'
% is moved up one level or the experiment will not run on windows
% do this by running :
% addpath C:\Users\winawerlab\Documents\MATLAB\toolboxes\Psychtoolbox-3\Psychtoolbox\PsychBasic\MatlabWindowsFilesR2007a\

% Which site?
[experimentSpecs, whichSite, selectionMade] = bairExperimentSpecs('prompt', true);
if ~selectionMade, return; end

% Which subject and session?
[subjID, sessionID, ssDefined] = bairWhichSubjectandSession();
if ~ssDefined, return; end

% What general stimulus parameters?
[VTSOptions, fileSelected] = VTS_selectSessionOptions();
if ~fileSelected, return; end

% What experiment list?
[experimentsList, experimentStimFilesList, experimentsRunIDs, fileSelected] = VTS_selectExperimentsList;
if ~fileSelected, return; end

% Setup the device
VTSDevice = VTS_setupVibrotactileDevice(VTSOptions);

% Run these experiments!
for ii = 1:length(experimentsList)
    % Read the content of the stimulus json file
    json = loadjson(experimentStimFilesList{ii});
    
    % Assign json fields to VTSOptions fields
    VTSExperimentOptions = json.VTSExperimentOptions;
    
    quitProg = VTS_runme(experimentsList{ii}, experimentsRunIDs(ii),...
        experimentSpecs(whichSite,:), subjID, sessionID, VTSOptions, VTSDevice, VTSExperimentOptions);
    if quitProg, break; end
end


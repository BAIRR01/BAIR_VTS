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
[VTSOpts, fileSelected] = VTS_selectSessionOptions();
if ~fileSelected, return; end

% Setup the device
VTSDevice = VTS_setupVibrotactileDevice(VTSOpts);

% What experiment list?
[experimentsList, experimentOptsList, runIDs, fileSelected] = VTS_selectExperimentsList;
if ~fileSelected, return; end

% Run these experiments!
for ii = 1:length(experimentsList)
    % Read the content of the stimulus json file
    json = loadjson(experimentOptsList{ii});
    
    % Assign json fields to VTSOptions fields
    VTSExperimentOpts = json.VTSExperimentOptions;
    
    quitProg = VTS_runme(experimentsList{ii}, runIDs(ii), experimentSpecs(whichSite,:),...
        subjID, sessionID, VTSOpts, VTSDevice, VTSExperimentOpts);
    if quitProg, break; end
end


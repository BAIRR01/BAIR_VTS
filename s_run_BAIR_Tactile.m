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

% What experiment list? 
[experimentsList, experimentRepsList, fileSelected] = VTSWhichExperimentList;
if ~fileSelected, return; end

% What experimental parameters?
[VTSOptions, selectionMade] = VTSSelectOptions();
if ~selectionMade, return; end

% Setup the device
VTSDevice = setupVibrotactileDevice(VTSOptions);

% Run these experiments!
for ii = 1:length(experimentsList)
    quitProg = VTS_runme(experimentsList{ii}, experimentRepsList(ii),...
        experimentSpecs(whichSite,:), subjID, sessionID, VTSOptions, VTSDevice);
    if quitProg, break; end
end
        

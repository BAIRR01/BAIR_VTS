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

% Which type of experiment?
[sensoryDomain, selectionMade] = bairWhichSensoryModality();
if ~selectionMade, return; end

% What experiment list?
[experimentsList, experimentOptsList, runIDs, fileSelected] = selectExperimentsList(sensoryDomain);
if ~fileSelected, return; end

% For the moment, tactile and motor stimuli are handled differently so call
% them separately
switch sensoryDomain
    case 'TACTILE'
        % What general stimulus parameters?
        [VTSOpts, fileSelected] = VTS_selectSessionOptions();
        if ~fileSelected, return; end
        
        % Setup the device
        VTSDevice = VTS_setupVibrotactileDevice(VTSOpts);
        
        % Run these experiments!
        for ii = 1:length(experimentsList)
            % Read the content of the stimulus json file
            json = loadjson(experimentOptsList{ii});
            
            % Assign json fields to VTSOptions fields
            VTSExperimentOpts = json.VTSExperimentOpts;
            
            % Run it
            quitProg = sensoryMotorRunme(experimentsList{ii}, runIDs(ii), experimentSpecs(whichSite,:),...
                subjID, sessionID, VTSOpts, VTSDevice, VTSExperimentOpts, sensoryDomain);
            if quitProg, break; end
        end
        
        
    case 'MOTOR'
         % Run it
        for ii = 1:length(experimentsList)
            quitProg = sensoryMotorRunme(experimentsList{ii}, runIDs(ii), experimentSpecs(whichSite,:),...
                subjID, sessionID, [],[], [], sensoryDomain);
            if quitProg, break; end
        end
       
    otherwise
        error('Cannot run selected task: %s', sensoryDomain)
        
end




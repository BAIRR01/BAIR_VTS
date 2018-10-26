function VTSoptPath = makeVTSoptFile  

prompt = {'Enter number of stimulators to use',...
    'Enter number of locations to stimulate',...
    'Enter number of cycles per experiment', ...
    'Enter how many tactile stimuli constitute one stimulus cycle', ...
    'Enter how many blank stimuli are within one stimulus cycle', ...
    'Enter the length of one tactile stimulus (s)', ...
    'Enter the number of on-off periods within one tactile stimulus',...
    'Enter the ratio of on-off during one period',...
    'Enter the length of blank stimuli inserted around/between tactile stimuli within one cycle(s)',...
    'Enter base frequency of the tactile stimulus (Hz)', ...
    'Enter frequency of the NIdaq device (Hz)'...
    'Enter file name for Opts file'};

defaults = {'8', '8', '4', '8', '2', '6', '8', '0.8', '12', '30', '1000', ...
    sprintf('VTSOpts-%s', date)};

[answer] = inputdlg(prompt, 'VTS Options', 1, defaults);

if ~isempty(answer)
    json.VTSOptions.nrStimulators                = str2double(answer{1,:});
    json.VTSOptions.nrStimulatorLocations        = str2double(answer{2,:});
    json.VTSOptions.nrCyclesPerExperiment        = str2double(answer{3,:});
    json.VTSOptions.nrStimuliPerCycle            = str2double(answer{4,:});
    json.VTSOptions.nrBlanksPerCycle             = str2double(answer{5,:});
    json.VTSOptions.tactileStimulusDuration      = str2double(answer{6,:});
    json.VTSOptions.nrOnOffPeriodsPerStimulus    = str2double(answer{7,:});
    json.VTSOptions.tactileOnOffRatio            = str2double(answer{8,:});
    json.VTSOptions.blankStimulusDuration        = str2double(answer{9,:});
    json.VTSOptions.tactileFrequency             = str2double(answer{10,:});
    json.VTSOptions.NIdaqRate                    = str2double(answer{11,:});
    json.VTSOptions.optionFileName               = answer{12,:};
    selectionMade               = 1;
else
   json.VTSOptions              = [];
    selectionMade               = 0;
end

if ~selectionMade, return; end
VTSoptPath = fullfile('./VTSopts', sprintf('%s.json', json.VTSOptions.optionFileName));
savejson('', json, 'FileName', VTSoptPath);
end
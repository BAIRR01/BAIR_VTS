function VTSoptPath = VTS_makeExperimentOptFile(experiment)

prompt = {'Enter the duration of a blank stimulus(s)',...
    'Enter the number of blanks at the beginning of a experiment', ...
    'Enter the number of blanks at the end of a experiment', ...
    'Enter number of cycles per experiment', ...
    'Enter how many tactile stimuli constitute one stimulus cycle', ...
    'Enter how many blank stimuli are within one stimulus cycle', ...
    'Enter the length of one tactile stimulus (s)', ...
    'Enter the number of on-off periods within one tactile stimulus',...
    'Enter the ratio of on-off during one period',...
    'Enter base frequency of the tactile stimulus (Hz)', ...
    'Enter filename'};

defaults = {'12', '1', '1', '6', '6', '0', '6', '8', '0.8', '30', ...
    ['VTSExperimentOptions_', experiment]};

[answer] = inputdlg(prompt, 'VTS Experiment Options', 1, defaults);

if ~isempty(answer)
    json.VTSExperimentOptions.blankStimulusDuration     = str2double(answer{1,:});
    json.VTSExperimentOptions.startBlanksPerExperiment  = str2double(answer{2,:});
    json.VTSExperimentOptions.endBlanksPerExperiment    = str2double(answer{3,:});
    json.VTSExperimentOptions.nrCyclesPerExperiment     = str2double(answer{4,:});
    json.VTSExperimentOptions.nrStimuliPerCycle         = str2double(answer{5,:});
    json.VTSExperimentOptions.nrBlanksPerCycle          = str2double(answer{6,:});
    json.VTSExperimentOptions.tactileStimulusDuration           = str2double(answer{7,:});
    json.VTSExperimentOptions.nrOnOffPeriodsPerStimulus         = str2double(answer{8,:});
    json.VTSExperimentOptions.tactileOnOffRatio                 = str2double(answer{9,:});
    json.VTSExperimentOptions.tactileFrequency                  = str2double(answer{10,:});
    json.VTSExperimentOptions.optionFileName            = answer{11,:};
    selectionMade               = 1;
else
    json.VTSExperimentOptions     = [];
    selectionMade               = 0;
end


if ~selectionMade, return; end
VTSoptPath = fullfile('./ExperimentOpts', sprintf('%s.json', json.VTSExperimentOptions.optionFileName));
savejson('', json, 'FileName', VTSoptPath);
end
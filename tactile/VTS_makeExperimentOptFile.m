function VTSoptPath = VTS_makeExperimentOptFile(experiment)

prompt = {'Enter the duration of experiment blank(s)',...
    'Enter the number of pre-experiment blanks', ...     
    'Enter the number of post-experiment blanks', ...
    'Enter number of cycles (sweeps) per experiment', ...
    'Enter number of tactile stimuli (i.e. locations) per cycle', ...
    'Enter number of blanks per cycle', ...
    'Enter the length of one tactile stimulus(s)', ...
    'Enter the number of pulses per tactile stimulus',...
    'Enter the pulse length (ms)',...
    'Enter base frequency of the tactile stimulus (Hz)', ...
    'Enter filename'};

defaults = {'12', '1', '1', '6', '6', '0', '6', '8', '0.8', '30', ...
    ['Opts_', experiment]};

[answer] = inputdlg(prompt, 'VTS Experiment Options', 1, defaults);

if ~isempty(answer)
    json.VTSExperimentOpts.blankStimDur      = str2double(answer{1,:});
    json.VTSExperimentOpts.preExpBlanks      = str2double(answer{2,:});
    json.VTSExperimentOpts.postExpBlanks     = str2double(answer{3,:});
    json.VTSExperimentOpts.nrCyclesPerExp    = str2double(answer{4,:});
    json.VTSExperimentOpts.nrStimPerCycle    = str2double(answer{5,:});
    json.VTSExperimentOpts.nrBlanksPerCycle  = str2double(answer{6,:});
    json.VTSExperimentOpts.stimDur           = str2double(answer{7,:});
    json.VTSExperimentOpts.nrPulsesPerStim   = str2double(answer{8,:});
    json.VTSExperimentOpts.pulseOnDur        = str2double(answer{9,:});
    json.VTSExperimentOpts.vibrFreq          = str2double(answer{10,:});
    json.VTSExperimentOpts.optsFname         = answer{11,:};
    selectionMade               = 1;
else
    json.VTSExperimentOpts     = [];
    selectionMade               = 0;
end


if ~selectionMade, return; end
VTSoptPath = fullfile('./ExperimentOpts', sprintf('%s.json', json.VTSExperimentOpts.optsFname));
savejson('', json, 'FileName', VTSoptPath);
end
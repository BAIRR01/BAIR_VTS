function [VTSOptions, selectionMade] = VTSSelectOptions

[fname,path,fileselected] = uigetfile(fullfile('./VTSopts','*.json')...
    ,'Select VTS Options file');

if ~fileselected
    prompt = 'Would you like to make a VTS Options file now? Y/N ';
    answer = inputdlg(prompt,'Input', 1,{'y'});
    if string(answer) == 'Y'||'y'
        VTSoptPath = makeVTSoptFile;
    else
        VTSOptions                  = [];
        selectionMade               = 0;
        return
    end
elseif fileselected
    VTSoptPath = fullfile(path, fname);
end

% Read the content of the selected text file
json = loadjson(VTSoptPath);

% Assign json fields to VTSOptions fields
VTSOptions = json.VTSOptions;
selectionMade                         = 1;

% Check for input consistency
if mod(VTSOptions.blankStimulusDuration, VTSOptions.tactileStimulusDuration) ~= 0
    help(mfilename)
    error('the length of a blank should be equal to or a multiple of the tactile stimulus length');
end
% add variable
VTSOptions.blankTactileStimulusDurationRatio = VTSOptions.blankStimulusDuration / VTSOptions.tactileStimulusDuration;

% Check for input consistency
if mod(VTSOptions.tactileStimulusDuration*VTSOptions.NIdaqRate, VTSOptions.nrOnOffPeriodsPerStimulus) ~= 0
    help(mfilename)
    error('not possible to divide the tactile stimulus into on-off periods of consistent length');
end
% store duration of one on-off period in samples
VTSOptions.onOffPeriodDuration = VTSOptions.tactileStimulusDuration*VTSOptions.NIdaqRate / VTSOptions.nrOnOffPeriodsPerStimulus;
% store duration of one on period in samples
VTSOptions.onDuration = round(VTSOptions.onOffPeriodDuration*VTSOptions.tactileOnOffRatio);
% store duration of off on period in samples
VTSOptions.offDuration = round(VTSOptions.onOffPeriodDuration*(1-VTSOptions.tactileOnOffRatio));
% Check for input consistency
if VTSOptions.onOffPeriodDuration ~= VTSOptions.onDuration + VTSOptions.offDuration
    help(mfilename)
    error('not possible to create on-off periods of required length');
end




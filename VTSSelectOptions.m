function [VTSOptions, selectionMade] = VTSSelectOptions

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
    'Enter frequency of the NIdaq device (Hz)'};

defaults = {'8', '8', '4', '8', '2', '6', '8', '0.8', '12', '30', '1000'};

[answer] = inputdlg(prompt, 'VTS Options', 1, defaults);

if ~isempty(answer)
    VTSOptions.nrStimulators                = str2double(answer{1,:});
    VTSOptions.nrStimulatorLocations        = str2double(answer{2,:});
    VTSOptions.nrCyclesPerExperiment        = str2double(answer{3,:});
    VTSOptions.nrStimuliPerCycle            = str2double(answer{4,:});
    VTSOptions.nrBlanksPerCycle             = str2double(answer{5,:});
    VTSOptions.tactileStimulusDuration      = str2double(answer{6,:});
    VTSOptions.nrOnOffPeriodsPerStimulus    = str2double(answer{7,:});
    VTSOptions.tactileOnOffRatio            = str2double(answer{8,:});
    VTSOptions.blankStimulusDuration        = str2double(answer{9,:});
    VTSOptions.tactileFrequency             = str2double(answer{10,:});
    VTSOptions.NIdaqRate                    = str2double(answer{11,:});
    selectionMade               = 1;
else
    VTSOptions                  = [];
    selectionMade               = 0;
end

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




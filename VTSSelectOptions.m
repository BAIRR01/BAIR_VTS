function [VTSOptions, selectionMade] = VTSSelectOptions

prompt = {'Enter number of Stimulators to use','Enter number of fingers to stimulate',...
    'Enter number of repetitions', 'Enter stimulation time (s)', 'Enter pause time (s)'};

defaults = {'5', '5', '5','12', '12'};
[answer] = inputdlg(prompt, 'VTS Options', 1, defaults);

if ~isempty(answer)
    VTSOptions.nrStimulators = answer{1,:};
    VTSOptions.nrReps        = answer{2,:};
    VTSOptions.nrFingers     = answer{3,:};
    VTSOptions.stimTime      = answer{4,:};
    VTSOptions.pauseTime     = answer{5,:};
    selectionMade            = 1;
else
    VTSOptions               = [];
    selectionMade            = 0;
end


   
 
   
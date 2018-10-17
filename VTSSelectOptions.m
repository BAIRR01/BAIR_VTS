function [VTSOptions, selectionMade] = VTSSelectOptions

prompt = {'Enter number of Stimulators to use','Enter number of fingers to stimulate',...
    'Enter number of repetitions', 'Enter stimulation time (s)'};

defaults = {'5', '5', '6','6'};
[answer] = inputdlg(prompt, 'VTS Options', 1, defaults);

if ~isempty(answer)
    VTSOptions.nrStimulators = str2num(answer{1,:});
    VTSOptions.nrFingers     = str2num(answer{2,:});
    VTSOptions.nrReps        = str2num(answer{3,:});
    VTSOptions.stimTime      = str2num(answer{4,:});
    selectionMade            = 1;
else
    VTSOptions               = [];
    selectionMade            = 0;
end


   
 
   
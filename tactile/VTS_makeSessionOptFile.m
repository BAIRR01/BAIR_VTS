function VTSoptPath = VTS_makeSessionOptFile

prompt = {'Enter number of stimulators to use',...
    'Enter frequency of the NIdaq device (Hz)'...
    'Enter names(s) of the NIdaq device(s) (Hz)'...
    'Enter file name for Opts file'};

defaults = {'8', '1000', 'cDAQ1mod1', ...
    sprintf('VTSOpts-%s', date)};

[answer] = inputdlg(prompt, 'VTS Options', 1, defaults);

if ~isempty(answer)
    json.VTSOpts.nrStimulators    = str2double(answer{1,:});
    json.VTSOpts.NIdaqRate        = str2double(answer{2,:});
    json.VTSOpts.NIdaqNames       = {answer{3,:}};
    json.VTSOpts.optionFileName   = answer{4,:};
    selectionMade               = 1;
else
    json.VTSOpts             = [];
    selectionMade               = 0;
end

if ~selectionMade, return; end
VTSoptPath = fullfile('./SessionOpts', sprintf('%s.json', json.VTSOpts.optionFileName));
savejson('', json, 'FileName', VTSoptPath);
end
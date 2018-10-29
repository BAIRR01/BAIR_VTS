function [VTSOptions, selectionMade] = VTS_selectSessionOptions

[fname,path,fileselected] = uigetfile(fullfile('./SessionOpts','*.json')...
    ,'Select VTS Options file');

if ~fileselected
    prompt = 'Would you like to make a VTS Options file now? Y/N ';
    answer = inputdlg(prompt,'Input', 1,{'y'});
    if string(answer) == 'Y'||'y'
        VTSoptPath = VTS_makeSessionOptFile;
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





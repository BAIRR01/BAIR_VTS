function stimOptPath = VTS_selectExperimentOptions(experiment)
       %check for options file
        % Prompt user input to load file
        [fnameTMP,pathTMP,fileselectedTMP] = uigetfile(fullfile('./ExperimentOpts','*.json'),...
            ['Select options file for -- ', experiment]);
        
        if ~fileselectedTMP
            prompt = 'Would you like to make a stimulus options file? Y/N ';
            answer = inputdlg(prompt,'Input', 1,{'y'});
            if string(answer) == 'Y'||'y'
                stimOptPath = VTS_makeExperimentOptFile(experiment);
            else
                return
            end
        elseif fileselectedTMP
            stimOptPath = fullfile(pathTMP, fnameTMP);
        end

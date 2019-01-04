function [experimentList, experimentOptsList, runIDs, selectionMade] = selectExperimentsList(task)

% Prompt user input to load file
[fnameTMP,pathTMP,fileselectedTMP] = uigetfile(fullfile('./runme','*.txt'),...
    'Select experiment sequence file');

if fileselectedTMP
    % Read the content of the selected text file
    experimentList = importdata(fullfile(pathTMP,fnameTMP));
    
    %initialize list with filenames of stimulus opts
    experimentOptsList = cell(size(experimentList));
    
    % Parse the filename string
    experimentTypes = unique(experimentList);
    % Assign a run number for every experiment type
    for ii = 1:length(experimentTypes)
        %for now, the tactile experiment uses json files, so search for it
        if contains(task, 'tactile','IgnoreCase',true)
            % select options for experiment type
            stimOptPath = VTS_selectExperimentOptions(experimentTypes{ii});
            %add to array
            experimentOptsList(ismember(experimentList, experimentTypes(ii))) = {stimOptPath};   
        else
            experimentOptsList = [];
        end
              
        
        % find every instance of each experiment type and assign a runnum
        idx = find(strcmp(experimentList, experimentTypes(ii)));
        for jj = 1:length(idx)
            runIDs(idx(jj)) = jj;
        end
    end
    selectionMade = 1;
else
    runIDs = [];
    selectionMade = 0;
end
end


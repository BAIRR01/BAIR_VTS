function [experimentList, runIDs, selectionMade] = VTSWhichExperimentList

% Prompt user input to load file
[fname,path,fileselected] = uigetfile(fullfile('./StimOrders','*.txt'),...
    'Select experiment sequence file');

if fileselected
    % Read the content of the selected text file
    experimentList = importdata(fullfile (path,fname));
    
    % Parse the filename string
    experimentTypes = unique(experimentList);
    % Assign a run number for every experiment type
    for ii = 1:length(experimentTypes)
        idx = find(strcmp(experimentList, experimentTypes(ii)));
        for jj = 1:length(idx)
            runIDs(idx(jj)) = jj;
        end
    end
    selectionMade = 1;
else
    experimentTypes = [];
    runIDs = [];
    selectionMade = 0;
end
end


function [experimentList, experimentStimFilesList, experimentsRunIDs, selectionMade] = VTS_selectExperimentsList

% Prompt user input to load file
[fnameTMP,pathTMP,fileselectedTMP] = uigetfile(fullfile('./StimOrders','*.txt'),...
    'Select experiment sequence file');

if fileselectedTMP
    % Read the content of the selected text file
    experimentList = importdata(fullfile(pathTMP,fnameTMP));
    
    %initialize list with filenames of stimulus opts
    experimentStimFilesList = cell(size(experimentList));
    
    % Parse the filename string
    experimentTypes = unique(experimentList);
    % Assign a run number for every experiment type
    for ii = 1:length(experimentTypes)
        % select options for experiment type
        stimOptPath = VTS_selectExperimentOptions(experimentTypes{ii});
        %add to array
        experimentStimFilesList(find(ismember(experimentList, experimentTypes(ii)))) = {stimOptPath};
        
        idx = find(strcmp(experimentList, experimentTypes(ii)));
        for jj = 1:length(idx)
            experimentsRunIDs(idx(jj)) = jj;
        end
    end
    selectionMade = 1;
else
    experimentsRunIDs = [];
    selectionMade = 0;
end
end


function [orderList, runIDs, selectionMade] = VTSWhichExperimentList

% Prompt user input to load file
[fname,path,fileselected] = uigetfile('.txt' ,'Select order sequence file');

if fileselected
    % Read the content of the selected text file
    orderList = importdata(fullfile (path,fname));
    
    % Parse the filename string
    numberOfExperiments = length(orderList);
    experimentTypes = unique(orderList);
    % Assign a run number for every experiment type
    for ii = 1:length(experimentTypes)
        idx = find(strcmp(orderList, experimentTypes(ii)));
        for jj = 1:length(idx)
            runIDs(idx(jj)) = jj;
        end
    end
    selectionMade = 1;
else
    numberOfExperiments = [];
    experimentTypes = [];
    runIDs = [];
    selectionMade = 0;
end
end


% Checking...
% for ii = 1:numberOfExperiments
%     sprintf('%s-%d', orderList{ii},runIDs(ii))
% end
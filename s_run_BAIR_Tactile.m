
% Which site?
[experimentSpecs, whichSite, selectionMade] = bairExperimentSpecs('prompt', true);
if ~selectionMade, return; end

% Which subject and session?
[subjID, sessionID, ssDefined] = bairWhichSubjectandSession();
if ~ssDefined, return; end

% What experiment list? 
[orderList, runIDs, fileSelected] = VTSWhichExperimentList;
if ~fileSelected, return; end

% What experimental parameters?
[VTSOptions, selectionMade] = VTSSelectOptions();
if ~selectionMade, return; end

% Run these experiments!
for ii = 1: length(orderList)
    quitProg = VTS_runme(orderList{ii}, runIDs(ii),experimentSpecs(whichSite,:), subjID, sessionID, VTSOptions);
    if quitProg, break; end
end
        

% Make Motor Experiment Files


% Prompt for ExperimentSpecs
[experimentSpecs, whichSite, selectionMade] = bairExperimentSpecs('prompt', true);
if ~selectionMade, return; end

% Which experiment to make?
[experimentType, selectionMade] = bairWhichExperiment();
if ~selectionMade, return; end

% Generate stimulus template

%   max stimulus radius (in deg)
%       16.6º is the height of the screen for the 3T display at Utrecht,
%       which is the smallest FOV among NYU-3T, UMC-3T, NYU-ECoG, UMC-ECoG,
%       NYU-MEG

TR              = 0.850;      % ms
stimDiameterDeg = 16.6;       % degrees


stimParams = stimInitialize(experimentSpecs, whichSite, stimDiameterDeg);

% for now make one experiment as a test so no need for a switch

numberOfRuns = 1;
for runNum = 1:numberOfRuns
    % MAKE TASK EXPERIMENT
    stimMakeMotorExperiment(stimParams, runNum, TR);
end





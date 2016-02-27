function g=analyzeExpGHK(fp)


%% - Decide auto vs manual, usually run in manual mode
% Auto mode
if nargin==0
    [fp]=getUserInput();
end
%% - get params struct
% loads params, p
load(fullfile(fp.pathParams,fp.fileParams));

g=struct();
g=addNiceInfo(fp,p);

g=extractIV_GHK(fp,g,p);

if strcmp(fp.userChoice(4),'y')
    g=addSymcond(fp,g,p);
end

if strcmp(fp.userChoice(5),'y')
    g=addCationSweep(fp,g,p);
end

%% - Post processing functions added later
% - find and append zeros from fits
g = addVrev(g);
% - Fit Vrev vs Concratio to find selectivity ratio R
g = fitRfromVrevVsConcRatio(g);
%use monte carlo to synthesize errors for Vrev and concentration
g = addSynthVrev(g);
%fit to find R from synthesized datasets
g = addFitVrevSynth(g);
% - add conductance estimate from a linear fit to pH series data
g = addSymmetricConductance(g);
% - add conductance sweep summary if user wants it
if strcmp(g.doCond{1},'y');g = addConductanceSweep(g);end
% - add cation sweep summary if user wants it
if strcmp(g.doCat{1},'y'); g = addCationSweep(g);end
%% - Save the hard work
save(fullfile(fp.pathSave,fp.fileSave),'g','-v7.3');
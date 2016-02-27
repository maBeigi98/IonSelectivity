function g=analyzeExpGHK(varargin)
%
%function g=analyzeExpGHK(varargin)
% this program calculates the IV curves for various pHs and conductance
% ratios between cis and trans. The main subroutine is anlyzeGHKrun.m
% which operates on one zap session at a time. The user is asked to input
% the folder where all the zap files are, the params mat file where
% parameters like the salt solutions are, and other info and saves them in
% a struct g with all of the data. Does not need to be called with any
% arguments, but if you do they must be these
%     pathname       = varargin{1};
%     filenameParams = varargin{2}; 
%     pathnameParams = varargin{3};
%     answer         = varargin{4};
%     filenameSave   = varargin{5};
%     pathnameSave   = varargin{6};

%% - Decide auto vs manual, usually run in manual mode
% Auto mode
if nargin>0
    pathname       = varargin{1};
    filenameParams = varargin{2}; 
    pathnameParams = varargin{3};
    answer         = varargin{4};
    filenameSave   = varargin{5};
    pathnameSave   = varargin{6};
else
    %% - User inputs
    %gat path for all zaps
    [pathname] = uigetdir('p:\public\Operation White Anvil\Analysis\ZappingConductance\',...
        'Pick pore folder containing zap folders');
    % get parameters
    [filenameParams, pathnameParams] = uigetfile({'*.mat','.mat files'},...
        'Pick the params file','p:\public\Operation White Anvil\Analysis\ZappingConductance\',... 
        'MultiSelect', 'off');
    % get porename, and some other info
    prompt = {'Pore name',...
              'Data page and book number',...
              'Comments',...
              'Analyze symmetric conductanc sweep',...
              'Analyze cation sweep',...
              'Do bootstrap instead of monte carlo'};
    dlg_title = 'Optional input, but pore name used downstream!';
    num_lines = 1;
    c = strsplit(pathname,'\'); %find porename in path
    def = {c{end},'','','n','n','n'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);
    %% - find a good place to save the hard work
    [filenameSave, pathnameSave] = uiputfile({'*.mat';'*.*'},'When complete, save as');
end

%% - Main loop, run once for each zap
% pass info that doesn't change with each zap such as parameters
fileandpath.pathnameParams = pathnameParams;
fileandpath.filenameParams = filenameParams;
% and user input info
fileandpath.answer = answer;
% find number of zaps in experiment
zaplist   = ls([pathname '\zap*']);
numZap = size(zaplist,1);
% initialize variables
g=struct;
%load parameters struct to pass concentration data for fitting later
%this loads the struct p, and constants struct c
load([ pathnameParams filenameParams ])
% iterate over each zap folder
for i=1:numZap
    if i<10; zapfolder = ['\zap0' num2str(i)];
    else     zapfolder = ['\zap'  num2str(i)];
    end
  
    fileandpath.zapfolder=strrep(zapfolder, '\', '');
    %get pH folder names for this zap
    pHFolderList = ls([pathname zapfolder '\pH*']);
    numpH = size(pHFolderList,1);    
    for j=1:length(p.pH)
        %get pH folder list
        fileandpath.pathnameABF = [pathname zapfolder '\pH' num2str(p.pH(j))];
        % find pH file list
        pHFileList = ls([fileandpath.pathnameABF '\*.abf']);
        % convert to expected input for analyzing function
        fileandpath.filenameABF = cellstr(pHFileList)';
        %call the analysis function, runs over entire zap folder
        [n]=analyzeGHKrun(fileandpath);
        
        % if this is the first pH, fill g
        if j==1
            %get rid of the backslash
            modzapfolder = strrep(zapfolder, '\', '');
            g.(modzapfolder) = n;
        %otherwise append to g
        else
            %append to struct
            %get rid of the backslash
            modzapfolder = strrep(zapfolder, '\', '');
            %g.(modzapfolder) = updatecondstructGHK(g,modzapfolder,n);
            g.(modzapfolder).fitresults         = [g.(modzapfolder).fitresults; n.fitresults];
            g.(modzapfolder).Vs                 = [g.(modzapfolder).Vs; n.Vs];
            g.(modzapfolder).Is                 = [g.(modzapfolder).Is; n.Is];
            g.(modzapfolder).filenames          = [g.(modzapfolder).filenames; n.filenames];
        end
        
        %now, see if there is a conductance subfolder
        condFileList = ls([fileandpath.pathnameABF '\conductance\*.abf']);
        fileandpath.filenameABF = cellstr(condFileList)';
        %check if there is a folder 'conductance' with files and make sure
        %user said to look for it
        g.doCond = answer(4);
        if strcmp(g.doCond{1},'y') || strcmp(g.doCond{1},'yes') && ~isempty(condFileList);%
            %if so, then make a new substruct for appending
            [m] = analyzeConductanceSweep(fileandpath);
            modzapfolder = strrep(zapfolder, '\', '');
            %if first pH, create a new subfield
            if j==1;
                g.(modzapfolder).m=m;
            %else append to the subfield, this is terribly ugly
            else
                g.(modzapfolder).m.fitresults    = [g.(modzapfolder).m.fitresults    ; m.fitresults];
                g.(modzapfolder).m.Vs            = [g.(modzapfolder).m.Vs            ;m.Vs];
                g.(modzapfolder).m.Is            = [g.(modzapfolder).m.Is            ;m.Is];
                g.(modzapfolder).m.linearfit     = [g.(modzapfolder).m.linearfit     ;m.linearfit];
                g.(modzapfolder).m.lineargof     = [g.(modzapfolder).m.lineargof     ;m.lineargof];
                g.(modzapfolder).m.linearoptions = [g.(modzapfolder).m.linearoptions ;m.linearoptions];
                g.(modzapfolder).m.cond          = [g.(modzapfolder).m.cond          ;m.cond];
                g.(modzapfolder).m.conf          = [g.(modzapfolder).m.conf          ;m.conf];
                g.(modzapfolder).m.cond_yint     = [g.(modzapfolder).m.cond_yint     ;m.cond_yint];
                g.(modzapfolder).m.cond_xint     = [g.(modzapfolder).m.cond_xint     ;m.cond_xint];
            end
        end
    end
    
    %check if there is a cation series of data in 'cation' folder
    %now, see if there is a conductance subfolder
    fileandpath.pathnameABF = [pathname zapfolder];
    cationFileList = ls([fileandpath.pathnameABF '\cation\*.abf']);
    fileandpath.filenameABF = cellstr(cationFileList)';
    %check if there is a folder 'conductance' with files
    if ~isempty(cationFileList);%
        %if so, then make a new substruct for appending
        [a] = analyzeCationSweep(fileandpath);
        g.(modzapfolder).a=a;
    end

end
%save data for export
g.numZap = numZap; %just a nice thing to save
g.pH = p.pH;
g.numpH=length(p.pH);%just a nice thing to save
g.concCis = p.concCis;
g.concTrans = p.concTrans;
g.numConc = size(p.concCis,2);%nice to have
g.concRatio = p.concCis./p.concTrans;
g.porename = answer(1);
g.page     = answer(2);
g.comments = answer(3);
g.doCond  = answer(4);
g.doCat   = answer(5);
g.doBoot  = answer(6);
g.c = p.c;
%if conduction salt was done, this should exist
if isfield(p,'condTags');g.condTags=p.condTags;g.numCation=length(p.condTags);end;
%if specific symmetric conductance dataset was taken, save it
if isfield(p,'condConc');g.condConc = p.condConc; g.numCond=length(p.condConc); end
%stuff all the params into a substruct, just in case
g.p = p;

%% - Post processing functions added later
% - extracting fit coeffs and making nice arrays of them
[g] = addCoeffArray(g);
% - find and append zeros from fits
[g] = addVrev(g);
% - add Vrev fit Permability ratios R=Pk/PCl, and corrected R_c, and the
% 'outputs' which contain residuals for residual analysis
[g]=fitPermRatiofromVrev(g);
% - add confidence interval for error bars for R
[g] = addRconfInt(g);
% - add synthesized Vev fits to find R
if ~isfield(p,'errDist')
    disp('Assuming uniform error model for synthesized data')
    p.errDist='uniform';
end
%use monte carlo to synthesize errors for Vrev and concentration
g=addSynthVrev(g);
%fit to find R from synthesized datasets
g=addFitVrevSynth(g);

% - add conductance estimate from a linear fit to pH series data
[g] = addSymmetricConductance(g);
% - add conductance sweep summary if user wants it
if strcmp(g.doCond{1},'y') || strcmp(g.doCond{1},'yes')
      [g] = addConductanceSweep(g); 
else  disp('Conductance sweep skipped because you didn`t tell me to do it');
end
% - add cation sweep summary if user wants it
if strcmp(g.doCat{1},'y') || strcmp(g.doCat{1},'yes')
    [g] = addCationSweep(g);
else  disp('Cation sweep skipped because you didn`t tell me to do it');
end
%% - Save the hard work
save([pathnameSave filenameSave],'g','-v7.3');
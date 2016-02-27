function [fp]=getUserInput()
% gets user input through dialogs and saves it in strict fp (file and path)

%% - User inputs
%gat path for all zaps
[path] = uigetdir('p:\public\Operation White Anvil\Analysis\ZappingConductance\',...
    'Pick pore folder containing zap folders');
% get parameters
[fileParams, pathParams] = uigetfile({'*.mat','.mat files'},...
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
c = strsplit(path,'\'); %find porename in path
def = {c{end},'','','n','n','n'};
userChoice = inputdlg(prompt,dlg_title,num_lines,def);
%% - find a good place to save the hard work
[fileSave, pathSave] = uiputfile({'*.mat';'*.*'},'When complete, save as');

%organize everythin in output struct
fp.path=path;
fp.fileParams=fileParams;
fp.pathParams=pathParams;
fp.userChoice=userChoice;
fp.fileSave=fileSave;
fp.pathSave=pathSave;

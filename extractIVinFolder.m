function [n]=extractIVinFolder(zp,p)
% extracts all IV curves in folder and saves them in n.Vs and n.Is
% zp are structs with the data

% get number of files
%assuming there is more than one
if iscell(zp.fileABF)
    numFiles=size(zp.fileABF,2);
    % and sort them, unless there is only one
    zp.fileABF=sortrows(zp.fileABF');  
else %there is only one file
    numFiles=1;
end

%initialize output struct
n               = struct();
n.fitresults    = cell(1);
n.Vs=[];
n.Is=[];

for i=1:numFiles
    %extract IV curve data
    if numFiles ~=1
        %access element of cell of names
        [Vs, Is]=extract_iv_GHK([zp.pathABF zp.fileABF{i,1}],p);
    else
        %access just the lonely name
        [Vs, Is]=extract_iv_GHK([zp.pathABF zp.fileABF],p);
    end
    %save cell array of data for output or reanalysis later
    n.Vs{i} = Vs;
    n.Is{i} = Is;
end

function [a] = analyzeCationSweep(fp,g,p)
%data taken starting around July 25th added multiple symmetric conductances
%to the dataset. This function looks for a folder named 'conductance'
%within each pH folder, loads the IV curves in that folder, fits a linear
%IV curve and then summarizes the data. This is very similar ot the
%function addSymmetricConductance, but runs for each concentration,. m is a
%new struct output, will use as a substruct of g.zap

% get number of files
%assuming there is more than one
if iscell(fp.fileABF)
    numFiles=size(fp.fileABF,2);
    % and sort them, unless there is only one
    fp.fileABF=sortrows(fp.fileABF');  
else %there is only one file
    numFiles=1;
end

%load params file and create object to extract Gbulk from mat file
%p is the only struct in the file and has all the params
load([ pathParams fileParams ]);
for i=1:numFiles
        %extract IV curve data
        if numFiles ~=1
            %access element of cell of names
            [Vs, Is]=extract_iv_GHK(fullfile(fp.pathABF,fp.fileABF{i,1}),p);
        else
            %access just the lonely name
            %[Vs, Is]=extract_iv_GHK([fp.pathABF fp.fileABF{i,1}],p);
            [Vs, Is]=extract_iv_GHK(fullfile(fp.pathABF,fp.fileABF),p);
        end
        %save cell array of data for output or reanalysis later
        a.Vs{i} = Vs;
        a.Is{i} = Is;
        
        %do some fitting on this data
        %and pack the fits, goodnes of fits, option data
        [a.linearfit{i},a.lineargof{i},a.linearoptions{i}] = fit(Vs,Is,'poly1');
            
        %extract slopes (p1) which is the conductance in nS
        a.cond(i) = a.linearfit{i}.p1;
        %Find matlab's conf intervals and save 'em in array
        a.conf{i} = confint(a.linearfit{i});
        %save y intercept
        a.cond_yint(i) = a.linearfit{i}.p2;
        %save fit estimated x intercept, is ratio of y int and slope
        a.cond_xint(i) = a.linearfit{i}.p2/a.linearfit{i}.p1;
        
    end
end
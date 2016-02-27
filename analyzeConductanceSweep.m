function [m] = analyzeConductanceSweep(zp,p)
%data taken starting around July 25th added multiple symmetric conductances
%to the dataset. This function looks for a folder named 'conductance'
%within each pH folder, loads the IV curves in that folder, fits a linear
%IV curve and then summarizes the data. This is very similar ot the
%function addSymmetricConductance, but runs for each concentration,. m is a
%new struct output, will use as a substruct of g.zap
    
% get number of files
%assuming there is more than one
if iscell(zp.fileABF)
    numFiles=size(zp.fileABF,2);
    % and sort them, unless there is only one
    zp.fileABF=sortrows(zp.fileABF');  
else %there is only one file
    numFiles=1;
end

for i=1:numFiles
        %extract IV curve data
        if numFiles ~=1
            %access element of cell of names
            [Vs, Is]=extract_iv_GHK(fullfile(zp.pathABF,zp.fileABF{i,1}),p);
        else
            %access just the lonely name
            [Vs, Is]=extract_iv_GHK(fullfile(zp.pathABF,zp.fileABF),p);
        end
        %save cell array of data for output or reanalysis later
        m.Vs{i} = Vs;
        m.Is{i} = Is;
        
        %do some fitting on this data
        %and pack the fits, goodnes of fits, option data
        [m.linearfit{i},m.lineargof{i},m.linearoptions{i}] = fit(Vs,Is,'poly1');
        %extract slopes (p1) which is the conductance in nS
        m.cond(i) = m.linearfit{i}.p1;
        %Find matlab's conf intervals and save 'em in array
        m.conf{i} = confint(m.linearfit{i});
        %save y intercept
        m.cond_yint(i) = m.linearfit{i}.p2;
        %save fit estimated x intercept, is ratio of y int and slope
        m.cond_xint(i) = m.linearfit{i}.p2/m.linearfit{i}.p1;

    end
end
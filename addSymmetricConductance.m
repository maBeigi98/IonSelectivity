function [g] = addSymmetricConductance(g)
%This function looks for symmetric salt conditions, that is
%concCis=concTrans and fits a straight line to the Iv curve data and saves
%the slope as the conductance. This function does not analyze raw abfs that
%were done as a series of symmetric concentrations, that is done by
%analyzeConductanceSweep, this is a little cludgy, but works for all files
%so far.

%Loop over each zap
for z=1:g.numZap
    %take care of naming the zap sub-struct
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %find where salt concentration is symmetric
    idx = find(g.concRatio==1);
    %run once over each ph
    for i=1:g.numpH
        [linearfit{i},lineargof{i},linearoptions{i}] =...
            fit(g.(zap).Vs{idx,i},g.(zap).Is{idx,i},'poly1');
        %extract slopes (p1) which is the conductance in nS
        g.SymCond(i,z)         = linearfit{i}.p1;
        %Find matlab's conf intervals and save 'em in array
        conf = confint(linearfit{i});
        g.SymCond_lowErr(i,z)  = conf(1,1);
        g.SymCond_highErr(i,z) = conf(2,1);
    end
    %pack the fits goodnes of fits and for this zap
    g.(zap).linearfit=linearfit;
    g.(zap).lineargof=lineargof;
    g.(zap).linearoptions=linearoptions;
end

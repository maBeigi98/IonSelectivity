function [g]=fitRfromVrevVsConcRatio(g)
% finds best fit permeability ratio R for the given data g for all pH's.
% The fit is done over Vrev vs conc ratio. R is the raw data fits, while
% R_c has all data subtracted by the offset measured under symmetric salt
% concentration conditions. R has pH's as rows and zaps as cols

%once for each zap
for z=1:g.numZap
    %name the zap file
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %once for each pH
    for i=1:g.numpH
        %perform fit on without forcing symmetric Vrev to zero corrected data
        Vrev = g.(zap).Vrev(i,:);
        [fitresults_GHK_V{i,z},~,output_GHK_V{i,z}] = fitGHKvoltage(Vrev',g.concCis',g.concCis',g.concTrans,g.concTrans,g.c);
        g.R(i,z) = fitresults_GHK_V{i,z}.R;
        g.Voff(i,z) = fitresults_GHK_V{i,z}.Voff;
    end
end
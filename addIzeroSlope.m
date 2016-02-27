function [g]=addIzeroSlope(g)
%this function finds slope of I(V=0) vs concentration difference between
%cis and trans, with is one way to fin the permeability using 
% I = Pk(C1-C2)-PCl(C1-C2)=Pk-Pcl(C1-C2). Thiss assumes addIzero has
% already been run and has found the I(V=0 intercepts already. This
% function only fits the concentration difference from 0 to 0.07, since the
% .99 data doesn't sit on a linear curve very well half the time.
%
%g is the struct that contains the data

%Loop over each zap
for z=1:g.numZap
    %take care of naming the zap sub-struct
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %i indexes over pH (rows), run once for each ph
    for i=1:length(g.pH)
        %difference in concentration
        deltaC=g.concTrans-g.concCis;
        %set up the linear fit
        f = fittype('poly1');
        %and fit over the I(V=0)
        [linearfit,gof,output] = fit(deltaC(1:end-1)',g.(zap).Irev(i,1:end-1)',f);
        %save everything for safe keeping as a fit object
        g.(zap).Izerofitresults{i} = linearfit;
        g.(zap).Izerofitgof{i} = gof;
        g.(zap).Izerofitoutput{i} = output;
        
        %but extract the slope explicitly (coeff p1) for ease of use later
        %and divide out the coefficient A to get P in the right units
        A=(g.c.e*96485/g.c.kT);
        g.(zap).IzeroSlope(i) = linearfit.p1/A;
    end
    %add a summary of the slopes 
    IzeroSlope_summary(:,z) = g.(zap).IzeroSlope';
end
%pack the slope summary into the first level of the struct for safe keeping
g.IzeroSlope_summary =  IzeroSlope_summary;

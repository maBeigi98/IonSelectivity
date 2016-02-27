function [g]=addCoeffArray(g)
%this function finds the GHK fit coefficients for each zap and sames then g 
%in that zap's substruct
%
%g is the struct that contains the data

%Loop over each zap
for z=1:g.numZap
    %take care of naming the zap sub-struct
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %i indexes over pH (rows), run once for each ph
    for i=1:length(g.pH)
        %j indexes over concentration (cols) run once fore ach conc
        for j=1:g.numConc
            P_Karray(i,j)  = g.zap01.fitresults{i,j}.P_K;
            P_Clarray(i,j) = g.zap01.fitresults{i,j}.P_Cl;
            Vcarray(i,j) = g.zap01.fitresults{i,j}.Vc;
        end
    end
    g.(zap).P_Karray = P_Karray;
    g.(zap).P_Clarray = P_Clarray;
    g.(zap).Vcarray = Vcarray;
end
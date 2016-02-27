function [g]=addVrev(g)
%this function finds the voltage at which I=0, the reversal potential, for
%both the GHK fid and a linear fit near the closest value to zero.
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
            %find the zero of the GHK fit
            %Vrev_fit(i,j)  = fzero(g.(zap).fitresults{i,j},0);
            %find the zero of the data from a linear fit, but first
            %find index of data nearest to I=0
            idx = find(abs(g.(zap).Is{i,j})==min(abs(g.(zap).Is{i,j})));
            %select +-10 points around the min, but do 2 if not enough points
            try 
                Iregion = g.(zap).Is{i,j}(idx-10:idx+10);
                Vregion = g.(zap).Vs{i,j}(idx-10:idx+10);
            catch
                Iregion = g.(zap).Is{i,j}(idx-2:idx+5);
                Vregion = g.(zap).Vs{i,j}(idx-2:idx+5);
                fprintf('Vrev fit with only +-5 points instead of 10 %s pH %g concCis %g\n',zap,g.pH(i),g.concCis(j));
            end
            %create a linear fit to this region object for this region
            f = fittype('poly1');
            linearfit = fit(Vregion,Iregion,f);
            %find the zero of the fit and call it Vrev
            Vrev(i,j) = fzero(linearfit,0);
        end
    end
    %pack the estimates of Vrev into the struct for safe keeping
    g.(zap).Vrev = Vrev;
    g.Vrev(:,:,z)=Vrev;
end
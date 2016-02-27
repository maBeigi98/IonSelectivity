function [g]=addIzero(g)
%this function finds the current at V=0, the zero voltage 
%spontaneous current, for both the GHKcurrent equation fit to the IV curve
%fid and a linear fit near the closest value to V=0.
%
%g is the struct that contains the data

%Loop over each zap
for z=1:g.numZap
    %take care of naming the zap sub-struct
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %i indexes over pH (rows), run once for each ph
    for i=1:length(g.pH)
        %j indexes over concentration (cols) run once fore each conc
        for j=1:g.numConc
            % - find the I intercept of the GHK fit, V=0
            Izero_fit(i,j)  = feval(g.(zap).fitresults{i,j},0);
            
            % - find the zero of the data from a linear fit, but first
            %   find index of data nearest to V=0
            idx = find(abs(g.(zap).Vs{i,j})==min(abs(g.(zap).Vs{i,j})));
            %select data +-10 points around the min
            Iregion = g.(zap).Is{i,j}(idx-10:idx+10);
            Vregion = g.(zap).Vs{i,j}(idx-10:idx+10);
            %create a linear fit to this region object for this region
            f = fittype('poly1');
            linearfit = fit(Vregion,Iregion,f);
            %find the intercept (coeff p2) of the fit and call it Izero
            Izero(i,j) = linearfit.p2;
        end
    end
    %pack the estimates of Izero into the struct for safe keeping
    g.(zap).Izero_fit = Izero_fit;
    g.(zap).Izero = Izero;
end
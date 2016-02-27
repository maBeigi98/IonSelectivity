function [g]=plotIzero(g)
%[g]=plotIzero(g)
%this function plots I at V=0 vs pH and creates a sub-plot for each zap
%useful for evaluating the theory I = Pk(C1-C2)-PCl(C1-C2)=Pk-Pcl(C1-C2). 
% Thiss assumes addIzero has
% already been run and has found the I(V=0 intercepts already. This
% function only fits the concentration difference from 0 to 0.07, since the
% .99 data doesn't sit on a linear curve very well half the time.
%
%g is the struct that contains the data



%Loop over each zap
for z=1:g.numZap
    %take care of naming the zap sub-struct
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    
    %difference in concentration
    deltaC=g.concTrans-g.concCis;
    subplot(2,ceil(g.numZap/2),z)
    %i indexes over pH (rows), run once for each ph
    for i=1:length(g.pH)
        deltaC=g.concTrans-g.concCis;
        hold on
        plot(deltaC,g.(zap).Izero(i,:),'-o')
        %title({'Linear fit for I(V=0) assuming I=(P_{K}-P_{Cl})*\Deltac ', ['Pore name: ',g.porename{1}]})
        ylabel('P_K-P_{Cl} (m/s)')
        xlabel('C_{Trans}-C_{Cis} (M)')
        grid on 
        title(['Pore name: ', strrep(g.porename{1},'_','\_'),' ', zap])
        axis([min(deltaC)*.9 max(deltaC)*1.1 -1 1]); axis autoxy
    end
end


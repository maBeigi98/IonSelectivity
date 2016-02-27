function []=plotVrevVsConc(g)
%plot Vrev vs conc for all pHs on one plot, and make a new 
%subplot for each zap

for z=1:g.numZap
    %name the zap file
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %then plot the actual data
    map=colormap(lines(4));
    subplot(2,ceil(g.numZap/2),z)
    d=plot(g.concCis/g.concTrans,(g.(zap).Vrev-repmat(g.(zap).Vrev(:,1),1,5))*1000,'o','Linewidth',2);
    %construct a legend for the phs
    for i=1:g.numpH;dataleg{i} = num2str(g.pH(i));end;
    %and plot one legend with data
    if z==1; legend(d',dataleg); end
    %finally, make the plot pretty
    title(['Pore ' strrep(g.porename,'_','\_') ', ' zap]')
    ylabel('Vrev (mV)')
    xlabel('Concentration ratio C_{cis}/C_{trans}')
    axis([0 1 -120 40])
end
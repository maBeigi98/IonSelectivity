function [] = plotCondCationForEachZap(g)

for z=1:g.numZap
    %take care of naming the zap sub-struct
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    
    hold on
    plot(g.condCation(z,:),'-o')
    ax = gca;
    ax.XTick = 1:g.numCation;
    ax.XTickLabel = g.condTags;
    ylabel('Conductance (nS)')
    xlabel('Cation type')
    grid on
    leg{z}=zap;
end
title(['Pore name: ', strrep(g.porename{1},'_','\_')])
legend(leg);
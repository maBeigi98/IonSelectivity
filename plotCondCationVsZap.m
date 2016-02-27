function [] = plotCondCationVsZap(g)

plot(g.condCation,'-o')
legend(g.condTags)

%Annotate the graph and make it pretty
xlabel('Zap number')
ylabel('Conductance (nS)')
grid on
legend(g.condTags);
title(['Pore name: ', strrep(g.porename{1},'_','\_')])
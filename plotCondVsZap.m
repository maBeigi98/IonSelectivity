function [] = plotCondVsZap(g)
%yet another plotting function, plots conductance sweep conductances vs zap
%number, this of course assumes only one ph value for the sweep

%plot the data
plot(g.cond','-o')

%make legend
for i=1:g.numCond
    leg{i} = [num2str(g.condConc(i)), ' M'];
end

legend(leg)
ylabel('Conductance (nS)')
xlabel('Zap number')
grid on
title(['Pore name: ', strrep(g.porename{1},'_','\_')])



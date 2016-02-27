function [] = plotCondCationVsKClcond(g)

%index of pH 8 data in g.cond
idxpH=find(g.pH==8);
%index of 1M data in condConc
idxc =find(g.condConc==1);

plot(reshape(g.cond(idxpH,idxc,:),1,g.numZap),g.condCation,'-o')
legend(g.condTags)

%Annotate the graph and make it pretty
xlabel('1M KCl, pH 8, Conductance (nS)')
ylabel('Conductance (nS)')
grid on
legend(g.condTags);
title(['Pore name: ', strrep(g.porename{1},'_','\_')])


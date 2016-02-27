function [] = plotCationSelectivity(g,normMethod)




bulk    = repmat(g.p.cbulk100mM   ,g.numZap,1   );
bulkKCl = repmat(g.p.cbulk100mM(4),1,g.numCation);

for i=1:g.numCation
    S(:,i)=(g.condCation(:,i)/g.p.cbulk100mM(:,i))./(g.condCation(:,normMethod)/g.p.cbulk100mM(normMethod));
end

plot(g.condCation(:,normMethod),S,'-o')
    xlabel('.1M KCl conductance (nS)')

ylabel({'KCL normalized conductance';'G_{.1M X}/\sigma_{.1M X}/G_{.1M KCL}/\sigma_{1M KCL}'})
grid on
legend(g.condTags)

title(['Pore name: ', strrep(g.porename{1},'_','\_')])
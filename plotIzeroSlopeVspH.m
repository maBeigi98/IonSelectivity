function [] = plotIzeroSlopeVspH(g)


plot(g.pH,g.IzeroSlope_summary,'-o')

title({'Linear fit for I(V=0) assuming I=(P_{K}-P_{Cl})*\Deltac ', ['Pore name: ',g.porename{1}]})
ylabel('P_K-P_{Cl} (m/s)')
xlabel('pH')
axis([1 9 -1 10])
axis autoy


%make a legend
for z=1:g.numZap
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    leg{z} = zap;
end

legend(leg)
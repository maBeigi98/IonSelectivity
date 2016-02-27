function [] = plotSynthCheck(g)
%plots synthesized Vrev vs concentration ratio data for inspection.

pos=0;
for z=1:g.numZap
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    for i=1:g.numpH
        pos = pos+1;
        subplot(g.numZap,g.numpH,pos);
        for s=1:g.numSynth
            hold on
            plot(g.synthConc(:,i,s)'/g.concTrans,g.synthVrev(i,:,z,s)*1000,...
            '.','Linewidth',2);
        end
    axis([0 1 -120 20])
    title([zap ' pH ' num2str(g.pH(i)) ]);
    end
end

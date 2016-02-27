function [] = plotRsynthCheck(g,numToPlot)
%Plots the fits of Vrev vs concentration ratio in a series of subplots for
%inspection to make sure things make sense. Formatted the same was as
%plotSynthCheck, which will add the actual datapoint. Warning, plotting all
%the lines is very cumbersone, you probably only need a small subsection
%which you can enter in the optional numToPlot.

if nargin==1 numToPlot=g.numSynth;end

pos=0;
for z=1:g.numZap
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    for i=1:g.numpH
        pos = pos+1;
        subplot(g.numZap,g.numpH,pos);
        hold on
        for s=1:numToPlot
            %derive Vrev vs conc from Rsynth
            V = 1000*vcalcGHK(g.synthConc(:,z,s)',g.synthConc(:,z,s)',...
                          g.concTrans,g.concTrans,...
                          g.Rsynth(i,z,s),g.c);
            %and plot it
            plot(g.synthConc(:,z,s)'/g.concTrans,V);
        end
        %make it pretty
        axis([0 1 -120 20])
        title([zap ' pH ' num2str(g.pH(i)) ]);
    end
end


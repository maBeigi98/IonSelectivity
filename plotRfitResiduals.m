function [] = plotRfitResiduals(g,type)
%this function grabs the residuals from g.output_GHK_V (or the corrected)
%and plots them, with the means for inspection. if type='c' then the zero
%corrected version is plotted

v=[];concRatios=[];
for z=1:g.numZap
    for i=1:g.numpH
        %extract residuals, asking if corrected is desired
        if nargin>1&&type=='c'
            v = [v; g.output_GHK_V_c{i,z}.residuals];
        else
            v = [v; g.output_GHK_V{i,z}.residuals];
        end
        %conctenate the x-axis stuff
        concRatios=[concRatios g.concRatio];
    end
end
rv=reshape(v,[g.numConc,g.numZap*g.numpH])';
%find the means to plot on top of the data
mv = mean(rv,1);
%dithered x values for ease of seeing
concRatioDither = concRatios+.03*rand(1,length(concRatios));
%color the dots by zap number, make a color arra for one zap first
c=ones(1,g.numConc*g.numpH);
ca=[];
%concatentate color matrix to get data in format for scatter function
for i=1:g.numZap
    ca = [ca,c*i];
end
%size of dots for scatterplot
scatterSize = 20*ones(1,length(v));
%plot the scatterplot to look at the residuals
hold on
scatter(concRatioDither,v*1000,scatterSize,ca,'filled')
colormap(lines(6)); colorbar;
plot(g.concRatio,mv*1000,'+','Color','black','MarkerSize',10)
grid on
legend('Residuals','Mean')
%and label it
title(['Residual plot for GHK voltage fit for ', strrep(g.porename{1},'_','\_')])
ylabel('Vrev (mV)');
xlabel('Concentration ratio');

%now make a histogram of each set of residuals
figure
%histograms of each set of residuals as each oint
for i=1:g.numConc
    subplot(1,g.numConc,i)
    %[f,xi]=ksdensity(rv(:,i),'kernel','box');
    %stairs(xi,f);
    hist(rv(:,i));
    grid on
    if i==1;ylabel('Number per bin');end
    xlabel('Vrev residual (mV)')
    title(['Conc ratio ',num2str(g.concRatio(i))]);
end

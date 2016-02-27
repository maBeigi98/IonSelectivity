function [] = plotRfitVsConc(g,type)
%plot Vrev vs conc for all pHs on one plot, and make anew plot for each
%zap,and then put the fit Rfit data on top. type is a string for if you
%want corrected data or not type='c' if you want zero subtracted fits
%
%Versioning - overhaul RR 7/7/15

for z=1:g.numZap
    %name the zap file
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %then plot the actual data
    map=colormap(lines(g.numpH));
    subplot(2,ceil(g.numZap/2),z)

    %find out which kind of fit the user wants and find it
    if nargin >1 && type=='c',
        R=g.R_c;
        %remove the baseline values
        Vrev = g.(zap).Vrev-repmat(g.(zap).Vrev(:,1),1,5);
    else R=g.R; 
        Vrev = g.(zap).Vrev;
    end
        
    %plot one fit for each fit value, for some reason matlab's plot of the
    %fit object isn't working, so I'm reconstructing the fit with my own
    %function
    for i=1:g.numpH
        %plot the data
        d(i)=errorbar(g.concRatio,Vrev(i,:)*1000,g.lowErrVrev(i,:)*1000,g.highErrVrev(i,:)*1000,....
            'o','Linewidth',1,'Color',map(i,:));
        %construct the GHK predicted voltages
        minConcCis = min(g.concCis);
        maxConcCis = max(g.concCis);
        denseConcCis   = linspace(minConcCis,maxConcCis,100);
        denseConcRatio = denseConcCis/g.concTrans;
        %vcalcGHK(concCisK,concCisCl,concTransK,concTransCl,R,c)
        V(i,:) = g.Voff(i,z) + vcalcGHK(denseConcCis,denseConcCis,g.concTrans,g.concTrans,R(i,z),g.c);
        %put V in mV
        V=V*1000;
        %and plot them on the data
        hold on;
        f(i) = plot(denseConcRatio,V(i,:),'Linewidth',1,'Color',map(i,:));
        %construct a legend for the R values
        leg{i}=num2str(R(i,z));
    end
    %add the theoretical max curve
    maxV   = 1000*vcalcGHK(denseConcCis,denseConcCis,g.concTrans,g.concTrans,1e9,g.c);
    f(i+1) = plot(denseConcRatio,maxV,'Linewidth',1,'Color','black');
    leg{i+1}='Infinite';
    
    %construct a legend for the phs
    for i=1:g.numpH;dataleg{i} = num2str(g.pH(i));end;
    %and plot the legend with data and theory
    legend([d f],[dataleg leg])
    %finally, make the plot pretty
    title([strrep(g.porename{1},'_','\_') ', ' zap])
    ylabel('Vrev (mV)')
    xlabel('Concentration ratio C_{cis}/C_{trans}')
    grid on
    axis([0 1 -130 40])
end
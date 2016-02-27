function []=plotIvsVforAllpH(g,z,pHnum,concNum)
%
%g is the struct that contains the data while which zap is a a number for
%which zap number. condNum is the index of the conductance concentration
%you want to plot

if z<10; zap = ['zap0' num2str(z)'];else zap = ['zap'  num2str(z)'];end

%plot an IV line for each pH run
map = colormap(lines(g.numConc));
markConc = {'^','o','+','s'};
hold on
c=1;
%so we can select just one ph
for i=1:g.numpH
    if nargin>2 && i~=pHnum;continue;end
    %make a line for each conductance
     for j=1:g.numConc
        % a cluge to only condNum if it is entered
        if nargin>3 && j~=concNum;continue;end;
        hdata(c) = plot(g.(zap).Vs{i,j},g.(zap).Is{i,j});
        hdata(c).Color = map(j,:);
        hdata(c).Marker = markConc{i};
        hdata(c).LineStyle = 'none';
        hfit(c) = plot(g.(zap).fitresults{i,j});
        hfit(c).Color = map(j,:);
        %append to legend
        concStr   = [num2str(g.concCis(j)) ' M, pH', num2str(g.pH(i))];
        %pHStr     = ['pH ' num2str(g.pH(i))];
        leg{c}    = [concStr];
        c=c+1;
     end
end

%Annotate the graph and make it pretty
xlabel('Voltage (mV)')
ylabel('Current (nA)')
grid on
legend(hdata,leg);
title(['Pore name: ', strrep(g.porename{1},'_','\_'),' ', zap])


function [] = plotCondCationRatioVsKClcond(g,gnum,gdenom)
%g is the data, gnum is the numerator conductance, and gdenom is the
%denominator conductance, so far 4 means kcl and 7 meangs mgcl, probably
%the most interesting. Hey, the DynamicLegend thing lets new lines be
%appended and automatically added to the fig legend.


%index of pH 8 data in g.cond
idxpH=find(g.pH==8);
%index of 1M data in condConc
idxc =find(g.condConc==1);
%cation ratio
gratio = g.condCation(:,gnum)./g.condCation(:,gdenom);
leg=[g.condTags{gnum} '/' g.condTags{gdenom}];
if isfield(g,'cond')
    plot(reshape(   g.cond(idxpH,idxc,:),1,g.numZap),gratio,'-o','Displayname',leg)
else
    plot(g.SymCond(idxpH,:)                         ,gratio,'-o','Displayname',leg)
end
%Annotate the graph and make it pretty
if isfield(g,'cond')
    xlabel('1M KCl conductance (nS)')
else
    xlabel('.1M KCl conductance (nS)')
end
ylabel('Conductance Ratio')
grid on
legend('-DynamicLegend');
title(['Pore name: ', strrep(g.porename{1},'_','\_')])

%plot ratio of G1m/1m to G.1m/.1m vs G1m/1m conductance
figure;
hold on
plot(reshape(g.cond(1,1,:),1,7),reshape(g.cond(1,1,:)./g.cond(1,2,:),1,7),'-o')
plot(reshape(g.cond(1,1,:),1,7),reshape(g.cond(1,1,:)./g.cond(1,3,:),1,7),'-o')
plot(reshape(g.cond(1,1,:),1,7),reshape(g.cond(1,1,:)./g.cond(1,4,:),1,7),'-o')
%Annotate the graph and make it pretty
xlabel('1M KCl conductance (nS)')
ylabel('G_{1M/1M}/G_{X/X} Conductance Ratio')
grid on
legend('X=.1M','X=.01M','X=.001M')
title(['Pore name: ', strrep(g.porename{1},'_','\_')])
figure;
plot(reshape(g.cond(1,1,:),1,7));
hold on
plot(reshape(g.cond(1,2,:),1,7));
xlabel('Zap number')
ylabel('Conductance (nS)')
legend('1M','.1M')
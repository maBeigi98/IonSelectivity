function [] = plotCondCationRatioVs100mMKClcond(g,gnum,gdenom)
%g is the data, gnum is the numerator conductance, and gdenom is the
%denominator conductance, so far 4 means kcl and 7 meangs mgcl, probably
%the most interesting. Hey, the DynamicLegend thing lets new lines be
%appended and automatically added to the fig legend.


%index of pH 8 data in g.cond
idxpH=find(g.pH==8);
%cation ratio
gratio = g.condCation(:,gnum)./g.condCation(:,gdenom);
leg=[g.condTags{gnum} '/' g.condTags{gdenom}];
plot(g.SymCond(idxpH,:),gratio,'-o','Displayname',leg)
xlabel('1M KCl conductance (nS)')
xlabel('.1M KCl conductance (nS)')
ylabel('Conductance Ratio')
grid on
legend('-DynamicLegend');
title(['Pore name: ', strrep(g.porename{1},'_','\_')])
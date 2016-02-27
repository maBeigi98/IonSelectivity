function [g] = addCatRSummary(g,normMethod)
%[g] = addCatRSummary(g,normMethod)
%Adds cation selectivity ratio to g as g.catR_Summary array
%This takes the conductance found in g.zapXX.a.cond and calculates the
%bulk conductance normalized values

%run once for each zap
for z=1:g.numZap
    if z<10; zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %extract the conductances
    catCond_Summary(z,:) = g.(zap).a.cond;
    %calculate R, the normailized ratio
    R_summary(z,:)=(catCond_Summary(z,:)./g.p.cbulk100mM)/(catCond_Summary(z,normMethod)/g.p.cbulk100mM(normMethod));

end
%pack everything into neat arrays in g
g.catCond_Summary = catCond_Summary;
g.catR_Summary = R_summary;
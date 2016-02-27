function [g] = addCatCondSummary(g,cbulk100mM)
%[g] = addCatCondSummary(g,cbulk100mM)
%Adds cation conductance summary array to struct g as g.catCond_Summary. 
%This takes the conductance found in g.zapXX.a.cond and packs it into an
%easy to access array g.catCond_Summary.

for z=1:g.numZap
    if z<10; zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    catCond_Summary(z,:) = g.(zap).a.cond;
end
g.catCond_Summary = catCond_Summary;
if nargin>1
    g.p.cbulk100mM = cbulk100mM;
end
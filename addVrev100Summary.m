function [g]=addVrev100Summary(g)
%[g]=addVrev100Summary(g)
%looks for and adds a matrix summarizing the 100 to 1 conc ratio single
%point Vrev data, row=pH, col=zap

for z=1:g.numZap
   if z<10; zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
   for i=1:g.numpH
       idx = find(g.concRatio==.01);
       Vrev100(i,z) = g.(zap).Vrev(i,idx);
   end
    
end
g.Vrev100=Vrev100;
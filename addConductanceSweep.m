function [g] = addConductanceSweep(g)
%extract the conductance seep conductances for ph(row) conductance(col) 
%and zap (pages) 
% This assumes that the data is stored in
%g.(zap).a.cond, canclulated by analyzeConductanceSweep.m

for z=1:g.numZap
    %zap labeling for extraction
    if z<10; zap = ['zap0' num2str(z)'];else zap = ['zap'  num2str(z)'];end
    %save the date column by column
    cond(:,:,z) = g.(zap).m.cond;
end
%pack data into struct for safe keeping
g.cond = cond;
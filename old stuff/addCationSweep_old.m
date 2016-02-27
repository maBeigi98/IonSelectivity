function [g] = addCationSweep(g)
%extract the cation swee conductances for cation(cols) and zap (rows)
%only one concentration, only one ph and store them as a subfield under g. 
% This assumes that the data is stored in
%g.(zap).a.cond, canclulated by analyzeConductanceSweep.m

for z=1:g.numZap
    %zap labeling for extraction
    if z<10; zap = ['zap0' num2str(z)'];else zap = ['zap'  num2str(z)'];end
    %save the date column by column
    condCation(z,:) = g.(zap).a.cond;
end
%pack data into struct for safe keeping
g.condCation = condCation;
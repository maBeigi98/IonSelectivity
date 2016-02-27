function [g] = addIzeroSlope_summary(g)


for z=1:g.numZap
    %take care of naming the zap sub-struct
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %i indexes over pH (rows), run once for each ph
    IzeroSlope_summary(:,z) = g.(zap).IzeroSlope';
end

g.IzeroSlope_summary=IzeroSlope_summary(:,z);

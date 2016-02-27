function [g] = addRconfInt(g)

for z=1:g.numZap
    %name the zap file
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %once per  pH
    for i=1:g.numpH
        conf = confint(g.fitresults_GHK_V{i,z});
        g.RlowConf(i,z) = conf(1);
        g.RhighConf(i,z) = conf(2);
    end
end
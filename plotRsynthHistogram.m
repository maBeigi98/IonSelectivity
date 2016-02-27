function [] = plotRsynthHistogram(g,type)
%takes data struct g and extracts the synthesized means of R, the
%selectivity ratio fit from Vrev measurements. type is a string, either
%nothing or 'c' for corrected to output the symmetric salt
%zeroed Vrev data

% R=reshape([g.Rsynth{1:end}],g.numpH,g.numZap,g.numSynth);

%plot position
pos=0;
for z=1:g.numZap
    if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    for i=1:g.numpH
        pos = pos+1;
        subplot(g.numZap,g.numpH,pos);
        if nargin>1 && type=='c'
            hist(squeeze(g.Rsynth_c(i,z,:)));
        else
            hist(squeeze(g.Rsynth(i,z,:)),100);
        end
        title([zap ' pH ' num2str(g.pH(i)) ]);
    end
end

function [g]= addSynthVrev(g,errDist)

for s=1:g.p.numSynth
    disp(['Synthesizing data set ' num2str(s) ' of ' num2str(g.p.numSynth)]);
    %synthesize the data, running once over each zap
    for z=1:g.numZap
        if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
        %calculate the error for all pH and conc at once
        if nargin>1 && strcmp(errDist,'normal')
            str ='Monte carlo error model is normal';
            synthErrVrev = ((g.p.lowErrVrev+g.p.highErrVrev)/2).*(randn(g.numpH,g.numConc));
            synthErrConc = ((g.p.highErrConc-g.p.highErrConc)/2).*(randn(1,g.numConc));
        else
            str ='Monte carlo error model is uniform';
            synthErrVrev = (g.p.lowErrVrev+g.p.highErrVrev).*(rand(g.numpH,g.numConc)-0.5);
            synthErrConc = ((g.p.lowErrConc-g.p.highErrConc)/2).*(rand(1,g.numConc)  -0.5);
        end

        %add that error to the data
        synthDataVrev(:,:,z,s) = g.(zap).Vrev +synthErrVrev;
        synthDataConc(:,z,s)   = g.concCis    +synthErrConc;
    end
end
g.synthVrev = synthDataVrev;
g.synthConc = synthDataConc;
g.errDist=str;


%Save the parameters used in g's first level
g.numSynth    = g.p.numSynth;
g.lowErrVrev  = g.p.lowErrVrev;
g.highErrVrev = g.p.highErrVrev;
g.lowErrConc  = g.p.lowErrConc;
g.highErrVrev = g.p.highErrVrev;
g.lowErrConc  = g.p.lowErrConc;
g.highErrConc = g.p.highErrConc;
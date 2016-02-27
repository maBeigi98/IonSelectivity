function [g,Rsynth,Rsynth_c] = fitErr(g,numSynth,lowErrVrev,highErrVrev,lowErrConc,highErrConc,errDist)
% fits Vrev vs conc ratio data over numSynth different synthesized sets of
% Vrev data. The minarray and max array are the min and max values expected
% from a uniform distribution of errors. The errors are added to the data,
% samev in the cell synthData and then fits are saved in Rcell and Rcell_c
% all of which are cell arrays numSynth long, containing the synthesized

for i=1:numSynth
    disp(['Synthesizing data set ' num2str(i) ' of ' num2str(numSynth)]);
    %synthesize the data, running once over each zap
    for z=1:g.numZap
        %name the zap file
        if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
        %calculate the error for all pH and conc at once, using eitehr uniform or normal 
        %distribution
        %dim 1 ph, dim 2 conc, dim 3 zap, dim 4 synth run
        if     nargin>6 && strcmp(errDist,'normal')
            str ='Monte carlo error model is normal';
            %dim 1 ph, dim 2 conc, dim 3 zap, dim 4 synth run
            synthErrVrev = ((lowErrVrev+highErrVrev)/2).*(randn(g.numpH,g.numConc));
            %dim 1 conc, dim 2 zap, dim 3 synth run
            synthErrConc = ((highErrConc-highErrConc)/2).*(randn(1,g.numConc));
        else
            str ='Monte carlo error model is uniform';
            %dim 1 ph, dim 2 conc, dim 3 zap, dim 4 synth run
            synthErrVrev = (lowErrVrev+highErrVrev).*(rand(g.numpH,g.numConc)-0.5);
            %dim 1 conc, dim 2 zap, dim 3 synth run
            synthErrConc = ((lowErrConc-highErrConc)/2).*(rand(1,g.numConc)  -0.5);
        end

        %add that error to the data
        synthDataVrev(:,:,z,i) = g.(zap).Vrev +synthErrVrev;
        synthDataConc(:,z,i)   = g.concCis    +synthErrConc;
        %and pack it into the synthesized struct
        gs(i)=g;
        gs(i).(zap).Vrev    = synthDataVrev(:,:,z,i);
        gs(i).(zap).concCis = synthDataConc(:,z,i);
    end

    %find the fits for the synthesized data
    gs(i) = fitPermRatiofromVrev(gs(i));
    %Save the FIT results in a 3D array
    Rsynth(:,:,i)   = gs(i).R;
    Rsynth_c(:,:,i) = gs(i).R_c;
end

%save results in g
g.Rsynth=Rsynth;
g.Rsynth_c=Rsynth_c;
%Save Raw data in g
g.synthVrev = synthDataVrev;
g.synthConc = synthDataConc;

%calculate basic statistics and save them
g.Rsynth_mean   = mean(g.Rsynth,3);
g.Rsynth_std    = std(g.Rsynth,0,3);
g.Rsynth_5p     = prctile(g.Rsynth,5,3);
g.Rsynth_95p    = prctile(g.Rsynth,95,3);

g.Rsynth_c_mean = mean(g.Rsynth_c,3);
g.Rsynth_c_std  = std(g.Rsynth_c,0,3);
g.Rsynth_c_5p   = prctile(g.Rsynth_c,5,3);
g.Rsynth_c_95p  = prctile(g.Rsynth_c,95,3);

%save the parameteres used
g.numSynth = numSynth;
g.lowErrVrev = lowErrVrev;
g.highErrVrev = highErrVrev;
g.lowErrConc = lowErrConc;
g.highErrVrev = highErrVrev;
g.lowErrConc = lowErrConc;
g.highErrConc = highErrConc;

%print error model to sceen
disp(str);

        
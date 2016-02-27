function [g,Rsynth,Rsynth_c,VrevSynth] = fitBootErr(g,numBoot)
% fits Vrev vs conc ratio data over numBoot different bootstrap sampled
% synthesized sets of Vrev data. This is similar to the monte carlo fitErr
% method of estimating errors. The errors are added to the data,
% samev in the cell synthData and then fits are saved in Rcell and Rcell_c
% all of which are cell arrays numBoot long, containing the synthesized

%make a new struct to write the synth data over
gs = g;

for i=1:numBoot
    disp(['Bootstraping data set ' num2str(i) ' of ' num2str(numBoot)]);
    %synthesize the data, running once over each zap
    for z=1:g.numZap
        %name the zap file
        if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
        %add that error to the data
        %select at random, with replacement (aka bootstrap) the points 
        idx = sort(randi(g.numConc,1,g.numConc));
        bootDataVrev = g.(zap).Vrev(:,idx);
        bootDataConc = g.concCis(idx);
        %and pack it into the synthesized struct
        gs(i)=g;
        gs(i).(zap).Vrev = bootDataVrev;
        gs(i).concCis    = bootDataConc;
    end

    %find the fits for the bootstrapped data
    [R,R_c] = fitPermRatiofromVrev(gs(i));
    %save the resuls in a 3D array
    VrevSynth(:,:,i) = gs(i).(zap).Vrev;
    Rsynth(:,:,i)   = R;
    Rsynth_c(:,:,i) = R_c;
    %calculate useful error stats and save in g
end

%save results in g
g.Rsynth=Rsynth;
g.Rsynth_c=Rsynth_c;
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
g.numBoot = numBoot;
% g.lowErrVrev = lowErrVrev;
% g.highErrVrev = highErrVrev;
% g.lowErrConc = lowErrConc;
% g.highErrVrev = highErrVrev;
% g.lowErrConc = lowErrConc;
% g.highErrConc = highErrConc;       
        
        
        
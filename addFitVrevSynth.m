function [g]=addFitVrevSynth(g)
% finds best fit permeability ratio R for the given data g for all pH's.
% The fit is done over Vrev vs conc ratio. R is the raw data fits, while
% R_c has all data subtracted by the offset measured under symmetric salt
% concentration conditions. R has pH's as rows and zaps as cols. This is
%done over all the synthesized data


%once for each synth dataset
for s=1:g.numSynth
    disp(['Fitting dataset ', num2str(s), ' of ' num2str(g.numSynth)]);
    %once for each zap
    for z=1:g.numZap
        if z<10;zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
        %once for each pH
        for i=1:g.numpH
            %perform fit without forcing symmetric Vrev to zero corrected data
            Vrev = g.(zap).Vrev(i,:);%one pH at a time
            [f{i,z},~,output_GHK_V{i,z}] = fitGHKvoltage(g.synthVrev(i,:,z,s)',g.synthConc(:,z,i),g.synthConc(:,z,i),g.concTrans,g.concTrans,g.c);
            Rsynth(i,z,s) = f{i,z}.R;
            VoffSynth(i,z,s) = f{i,z}.Voff;
    %         %force symmetric concentration Vrev to zero
    %         Vrev_correct = g.(zap).Vrev(i,:)'-g.(zap).Vrev(i,1)';
    %         %syntax of fit func fitGHKvoltage(Vrev,cC_K,cC_Cl,cT_K,cT_Cl,c);
    %         [fitresults_GHK_V_c{i,z},~,output_GHK_V_c{i,z}] = fitGHKvoltage(Vrev_correct,g.concCis',g.concCis',g.concTrans,g.concTrans,g.c);
    %         R_c(i,z) = fitresults_GHK_V_c{i,z}.R;
        end
    end
    
end

%pack everything into g
g.Rsynth = Rsynth;
%The voffset fitting parameter
g.VoffSynth = VoffSynth;
%calculate basic statistics and save them
g.Rsynth_mean   = mean(g.Rsynth,3);
g.Rsynth_std    = std(g.Rsynth,0,3);
g.Rsynth_5p     = prctile(g.Rsynth,5,3);
g.Rsynth_95p    = prctile(g.Rsynth,95,3);



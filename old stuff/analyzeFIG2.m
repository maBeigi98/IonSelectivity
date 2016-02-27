function gs=analyzeFIG2(varargin)
%
pathname       = varargin{1};
filenameParams = varargin{2}; 
pathnameParams = varargin{3};


numZap =4;
numpH  = 4;
numConc=5;
concCis = [.1 .07 .03 .01 .001];%M KCl
pH = [8 6 4 2];
concTrans = .1;%M KCl
numSynth=100;
errVrev=.003;%3mV absolute err estimate on Vrev
errConc=[.005 .0035 .0015 .0005 .00005];%M absolute err for concentration
j=1;

%load parameters struct to pass concentration data for fitting later
%this loads the struct p, and constants struct c
load([ pathnameParams filenameParams ])
gs.concCis=concCis;
% iterate over each zap folder
for z=1:numZap
    if z<10; zap = ['zap0' num2str(z)];else zap = ['zap' num2str(z)];end
    for i=1:numpH
    %sliced from analyzerun
    %load params file and create object to extract Gbulk from mat file
    %get pH folder list
    pathnameABF = fullfile(pathname,zap,['pH' num2str(p.pH(i))]);
    % find pH file list
    pHFileList = ls([pathnameABF '\*.abf']);
    filenameABF = cellstr(pHFileList);
        for j=1:numConc
            %extract IV curve data
            [Vs, Is]=extract_iv_GHK(fullfile(pathnameABF,filenameABF{j,1}),p);
            %create struct gs (g-simple) for saving data
            gs.Vs{z,i,j} = Vs;
            gs.Is{z,i,j} = Is;
            
            %find the zero of the data from a linear fit, but first
            %find index of data nearest to I=0
            idx = find(abs(gs.Is{z,i,j})==min(abs(gs.Is{z,i,j})) );
            %select +-10 points around the min, but do 2 if not enough points
            try 
                Iregion = gs.Is{z,i,j}(idx-10:idx+10);
                Vregion = gs.Vs{z,i,j}(idx-10:idx+10);
            catch
                Iregion = gs.Is{z,i,j}(idx-5:idx+5);
                Vregion = gs.Vs{z,i,j}(idx-5:idx+5);
                fprintf('Vrev fit with only +-5 points instead of 10 %s pH %g concCis %g\n',zap,pH(i),concCis(j));
            end
            %create a linear fit to this region object for this region
            f = fittype('poly1');
            linearfit = fit(Vregion,Iregion,f);
            %find the zero of the fit and call it Vrev
            gs.Vrev(z,i,j) = fzero(linearfit,gs.Is{z,i,j}(idx));
        end
            %now the fitting of vrev vs concratio to find selectivity and offset voltage,(called R)
            fitresults_data = fitGHKvoltage(reshape(gs.Vrev(z,i,:),[numConc,1]),concCis',concCis',concTrans,concTrans,p.c);
            gs.R(z,i) = fitresults_data.R;
            gs.Voff(z,i) = fitresults_data.Voff;
    end
end

%calculate all monte carlo errors all pH and conc for this zap
%create a 
synthErrVrev = errVrev.*randn(numZap,numpH,numConc,numSynth);
synthErrConc = repmat(permute(errConc,[4,1,2,3]),[4,1,1,numSynth]).*randn(numZap, 1,numConc,numSynth);
%add absolute error to Vrev
gs.Vrev_s    = repmat(gs.Vrev   ,[1,1,1,numSynth])+synthErrVrev;
%multiply relative error to conc
gs.concCis_s = repmat(permute(gs.concCis,[4,1,2,3]),[4,1,1,numSynth])+synthErrConc;

%Fitting synthetic Vrev vs conc data
for z=1:numZap
    if z<10; zap = ['zap0' num2str(z)];else zap = ['zap' num2str(z)];end
    disp(sprintf('Fitting synthetic data for %s of %u.',zap,numZap));
    for i=1:numpH
        for s=1:numSynth
            %now the fitting to find selectivity and offset voltage,(called R)
            fitresults_synth = fitGHKvoltage(...
                reshape(gs.Vrev_s(z,i,:,s),[numConc,1]),squeeze(gs.concCis_s(z,1,:,s)),squeeze(gs.concCis_s(z,1,:,s)),concTrans,concTrans,p.c);
            gs.R_s(z,i,1,s)    = fitresults_synth.R;
            gs.Voff_s(z,i,1,s) = fitresults_synth.Voff;
        end
    end
end



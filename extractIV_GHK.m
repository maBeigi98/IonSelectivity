function g=extractIV_GHK(fp,g,p)

%extract ph and conc ratio I-V
numZap = size(ls([fp.path '\zap*']),1);
for z=1:numZap
    if z<10; zap = ['zap0' num2str(z)]; else zap = ['zap' num2str(z)];end
    %get pH folder names for this zap
    pHFolderList = ls(fullfile(fp.path,zap,'\pH*'));
    for i=1:length(p.pH)
        %get pH path and file list
        zp.pathABF = fullfile(fp.path,zap,['\pH' num2str(p.pH(i))]);
        pHFileList = ls([zp.pathABF '\*.abf']);
        % convert to expected input for analyzing function
        zp.fileABF = cellstr(pHFileList)';
        %call the analysis function, runs over entire zap folder
        n=analyzeGHKrun(zp,p);
        %append IV curves to g
        if ~isfield(g,zap)
            g.(zap)=n;
        else
            nms=fieldnames(n);
            for k=1:length(nms)
                g.(zap).(nms{k})=[g.(zap).(nms{k});n.(nms{k})];
            end
        end
    end
end
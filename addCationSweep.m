function g=addCationSweep(fp,g,p)



numZap = size(ls([fp.path '\zap*']),1);
for z=1:numZap
    if z<10; zap = ['zap0' num2str(z)]; else zap = ['zap' num2str(z)];end
    %check if there is a cation series of data in 'cation' folder
    %now, see if there is a conductance subfolder
    fp.pathABF = fullfile(fp.path,zap);
    cationFileList = ls([fp.pathABF '\cation\*.abf']);
    fp.fileABF = cellstr(cationFileList)';
    %check if there is a folder 'conductance' with files
    if ~isempty(cationFileList);%
        %if so, then make a new substruct for appending
        [a] = analyzeCationSweep(fp);
        g.(zap).a=a;
    end

end
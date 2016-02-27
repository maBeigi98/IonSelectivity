function g=addSymcond(fp,g,p)

%now, see if there is a conductance subfolder
numZap = size(ls([fp.path '\zap*']),1);
for i=1:numZap
    if i<10; zap = ['zap0' num2str(i)]; else zap = ['zap' num2str(i)];end
    pHFolderList = ls(fullfile(fp.path,zap,'\pH*'));
    for j=1:length(p.pH)
        %now, see if there is a conductance subfolder
        condFileList = ls([fp.path '\conductance\*.abf']);
        zp.fileABF = cellstr(condFileList)';
        zp.pathABF = [fp.path '\conductance'];
        %if so, then make a new substruct for appending
        [m] = analyzeConductanceSweep(zp,p);
        %if first pH, create a new subfield
        if j==1;
            g.(zap).m=m;
        %else append to the subfield, this is terribly ugly
        else
            g.(zap).m.fitresults    = [g.(zap).m.fitresults    ;m.fitresults];
            g.(zap).m.Vs            = [g.(zap).m.Vs            ;m.Vs];
            g.(zap).m.Is            = [g.(zap).m.Is            ;m.Is];
            g.(zap).m.linearfit     = [g.(zap).m.linearfit     ;m.linearfit];
            g.(zap).m.lineargof     = [g.(zap).m.lineargof     ;m.lineargof];
            g.(zap).m.linearoptions = [g.(zap).m.linearoptions ;m.linearoptions];
            g.(zap).m.cond          = [g.(zap).m.cond          ;m.cond];
            g.(zap).m.conf          = [g.(zap).m.conf          ;m.conf];
            g.(zap).m.cond_yint     = [g.(zap).m.cond_yint     ;m.cond_yint];
            g.(zap).m.cond_xint     = [g.(zap).m.cond_xint     ;m.cond_xint];
        end
    end
end


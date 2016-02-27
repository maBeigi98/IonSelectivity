function g=addNiceInfo(fp,p)
% sub-struct stuff that's nice to have

g.numZap   = size(ls([fp.path '\zap*']),1);; %just a nice thing to save
g.pH       = p.pH; 
g.numpH    = length(p.pH);%just a nice thing to save
g.concCis  = p.concCis;
g.concTrans= p.concTrans;
g.numConc  = size(p.concCis,2);%nice to have
g.concRatio= p.concCis./p.concTrans;
%dialog user input
g.porename = fp.userChoice(1);
g.page     = fp.userChoice(2);
g.comments = fp.userChoice(3);
g.doCond   = fp.userChoice(4);
g.doCat    = fp.userChoice(5);
g.doBoot   = fp.userChoice(6);
g.c = p.c;%constants struct
g.p=p;%params struct


%if conduction salt was done, this should exist
if isfield(p,'condTags');g.condTags=p.condTags;g.numCation=length(p.condTags);end;
%if specific symmetric conductance dataset was taken, save it
if isfield(p,'condConc');g.condConc = p.condConc; g.numCond=length(p.condConc); end
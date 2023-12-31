function [fitresults] = fitGHKcurrent(Vs,Is,p,i)

%g = fittype('P_K*(Vs-Vc)*A*96485*(cT-cC*exp(-Vs*A))./(1-exp(-(Vs-Vc)*A)+eps) + P_Cl*(Vs+Vc)*A*96485*(cT-cC*exp(Vs*A))./(1-exp((Vs+Vc)*A)+eps)',...
g = fittype('P_K*(Vs-Vc)*A*96485*(cT-cC*exp(-Vs*A))./(1-exp(-(Vs-Vc)*A)+eps)  + P_Cl*(Vs-Vc)*A*96485*(cT-cC*exp(Vs*A))./(1-exp((Vs-Vc)*A)+eps)',...
    'dependent','Is',...     
    'problem',{'A','cC','cT'},...
    'independent','Vs',...
    'coefficients',{'P_K','P_Cl','Vc'});

%check if p has lower and upper Vc fudge bounds
if ~isfield(p,'Vc_l')
    p.Vc_l=-0.5;
    p.Vc_h= 0.5;
end
  

options = fitoptions(...
    'Method','NonlinearLeastSquares',...
    'Startpoint',[1e-6, 1e-6, 0],...
    'Upper',[1e-3, 1e-3, p.Vc_h],...
    'Lower',[0, 0, p.Vc_l]);

A=p.c.e/p.c.kT;
fitresults = fit(Vs,Is,g,'problem',{A,p.concCis(i),p.concTrans},options);
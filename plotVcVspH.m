function []=plotVcVspH(g,z,concNum)
%[]=plotIvsVforAllpH(g,z,pHnum,concNum)
%pHnum is optional, if you just one one ph, concNum optional too
%g is the struct that contains the data while which zap is a a number for
%which zap number. concNum is the index of the concentration you want to
%plot
if z<10; zap = ['zap0' num2str(z)'];else zap = ['zap'  num2str(z)'];end

for i=1:g.numpH
    for j=1:g.numConc
        m(i,j)=g.(zap).fitresults{i,j}.Vc;
    end
end


%make a line for each concentration
hold on
for j=1:g.numConc
    % a cluge to only condNum if it is entered
    if nargin>2 && j~=concNum;continue;end;
    plot(g.pH,m(:,j)*1000,'-o')
end


%Annotate the graph and make it pretty
legend('.1 M','.07 M','.03 M','.01 M','.001 M')
    xlabel('pH')
    ylabel('Vc (mV)')
    grid on

title(['Pore name: ', strrep(g.porename{1},'_','\_'),' ', zap])


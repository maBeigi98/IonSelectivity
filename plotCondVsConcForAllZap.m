function [] = plotCondVsConcForAllZap(g)
%plots conductance vs salt concentration for all zaps for the conductance
%sweep data.



%run once for each zap
for z=1:g.numZap
    if z<10; zap = ['zap0' num2str(z)'];else zap = ['zap' num2str(z)'];end
    %open a subplot
    subplot(2,ceil(g.numZap/2),z)
    hold on
    %plot it!
    plot(g.condConc,g.cond(:,:,z),'-o')
    %set axis
    ax=gca;
    ax.XScale='log';
    ax.YScale='log';
    %make it pretty
    ylabel('Conductance (nS)')
    xlabel('Salt Concentration (M)')
    grid on
    title(['Pore name: ', strrep(g.porename{1},'_','\_')])
    
    %make legend
    for i=1:g.numpH
        leg{i} = ['pH ', num2str(g.pH(i)), ' G_{1M} = ', num2str(g.cond(i,1,z))];
    end
    legend(leg)
end



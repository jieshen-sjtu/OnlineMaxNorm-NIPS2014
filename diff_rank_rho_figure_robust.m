% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% plot EV w.r.t. rho, under different rank
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = diff_rank_rho_config();

methods = {'mrmd', 'orpca', 'pcp'};
num_mth = length(methods);

rank_ratio = config.rank_ratio;
all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;

%% load data
load(sprintf(config.stat_file_format, 'robust'));

%% figure

x = all_rho;

len = 6;
paper_pos = [0 0 len len] ;
paper_sz = [len len] ;

colors = config.colors;
shapes = config.shapes;
lines = config.lines;

line_w = 4;

for j=1:length(all_d)
    
    d = all_d(j);
    ratio = rank_ratio(j);
    
    all_EV = robust_EV{j};
    
    figure;
    
    hold on;
    grid on;
    box on;
    
    for m=1:num_mth
        plot(-0.05, -0.05, [colors{m} lines{m} shapes{m}], 'linewidth', line_w);
    end
    
    % mark
    for m=1:num_mth
        if strcmp(shapes{m}, '')
            continue;
        end
        plot(x, all_EV(m, :), [colors{m} shapes{m}], 'linewidth', line_w);
    end
    
    % line
    for m=1:num_mth
        plot(x, all_EV(m, :), [colors{m}, lines{m}], 'linewidth', line_w);
    end
    
    
    ftsize = 20;
    xlabel('fraction of corruption','FontSize', ftsize);
    ylabel('EV','FontSize', ftsize);
    
    title_name = sprintf('rank = %d', d);
    title(title_name, 'FontSize', ftsize + 2);
    set(gca,'FontSize',ftsize, 'xtick', 0.02:0.12:0.5);
    %     set(gca,'FontSize',ftsize, 'xtickLabel', [0.02:0.12:0.5]);
    
    %     set(gca,'FontSize',ftsize, 'ytick', [1:4:17]);
    %     set(gca,'FontSize',ftsize, 'ytickLabel', [0.5:-0.12:0.02]);
    xlim([0.02, 0.5]);
    
    %y_min = ceil(100 * max(min(mrmd_ev(end), orpca_ev(end)) - 0.1, 0) / 5) * 5 / 100;
    y_max = max(max(all_EV));
    if y_max < 0.95
        y_max = 1;
    else
        y_max = 1.05;
    end
    y_min = 0.3;
    ylim([y_min, y_max]);
    
    set(gca,'FontSize',ftsize);
    leg = legend('OMRMD', 'OR-PCA', 'PCP', 'Location','SouthWest');
    %set(leg, 'FontSize', ftsize);
    
    hold off;
    fig_name = sprintf(config.robust_fig_file_format, d);
    %     saveas(gcf, fig_name, 'fig' );
    
    eps_name = sprintf(config.robust_eps_file_format, d);
    %     saveas(gcf, eps_name, 'psc2');
    
end


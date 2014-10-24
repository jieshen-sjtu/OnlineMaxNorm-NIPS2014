% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% plot EV w.r.t. #samples
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = large_config();

load(config.stat_file_format);

methods = config.methods;
num_mth = length(methods) - 1;
all_p = config.p;
all_d = config.d;
all_n = config.n;
rho = config.rho;


len = 6;
paper_pos = [0 0 len len] ;
paper_sz = [len len] ;

colors = config.colors;
shapes = config.shapes;
lines = config.lines;

line_w = 3;

for i=1:length(all_p)
    
    mean_EV = all_EV{i};
    mean_EV = mean_EV(1:num_mth, :);
    mean_T = all_T{i} / 60; % in minutes
    for m=1:num_mth
        mean_T(m, :) = cumsum(mean_T(m, :));
    end
    
    p = all_p(i);
    d = all_d(i);
    n = length(mean_T);
    
    pt = n/20;
    
    ind = cell(1, num_mth);
    
    ind{1} = 1:pt:n;
    ind{2} = 1:(3*pt):n;
    
    figure;
    
    hold on;
    grid on;
    box on;
    
    for m=1:num_mth
        plot(-0.05, -0.05, [colors{m} lines{m} shapes{m}], 'linewidth', line_w);
    end
    
    for m=1:num_mth
        if strcmp(shapes{m}, '')
            continue;
        end
        plot(mean_T(m, ind{m}), mean_EV(m, ind{m}), [colors{m} shapes{m}], 'linewidth', line_w);
    end
    
    
    for m=1:num_mth
        plot(mean_T(m, :), mean_EV(m, :), [colors{m}, lines{m}], 'linewidth', line_w);
    end
    
    ftsize = 22;
    set(gca, 'FontSize', ftsize);
    xlabel('Time (minutes)','FontSize',ftsize);
    ylabel('EV','FontSize',ftsize);
    %     set(gca,'FontSize',ftsize, 'xtick', [(n/5):(n/5):n]);
    %     xlim([1, n]);
    
    y_max = max(max(mean_EV));
    if y_max < 0.95
        y_max = 1;
    else
        y_max = 1.05;
    end
    ylim([0, y_max]);
    
    hlg = legend('OMRMD', 'OR-PCA', 'Location','SouthEast');
    set(hlg, 'FontSize', 22);
    
    %     set(gcf, 'PaperPosition', paper_pos);
    %     set(gcf, 'PaperSize', paper_sz);
    
    fig_name = sprintf(config.time_fig_file_format, p, d, rho, n);
    %     saveas(gcf, fig_name, 'fig' );
    
    eps_name = sprintf(config.time_eps_file_format, p, d, rho, n);
    %     saveas(gcf, eps_name, 'psc2' );
    hold off;
    
end
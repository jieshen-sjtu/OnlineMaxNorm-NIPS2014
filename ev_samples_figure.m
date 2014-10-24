% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% plot EV w.r.t. #samples
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = ev_samples_config();

methods = config.methods;

all_rho = config.rho;
n = config.n;

num_mth = length(methods);

%% load data
load(config.stat_file_format);

%% save setting
len = 6;
paper_pos = [0 0 len len] ;
paper_sz = [len len] ;

%% figure setting
colors = config.colors;
shapes = config.shapes;
lines = config.lines;

pointSpace = n / 20;
ind = cell(1, num_mth);
for m=1:num_mth
    ind{m} = 1:pointSpace:n;
end
ind{1} = [1:(pointSpace/2):pointSpace (pointSpace + 1):pointSpace:n];
ind{2} = [1:(pointSpace/2):pointSpace (pointSpace + 1):pointSpace:n];

x = 1:n;

line_w = 3;

for i=1:length(all_rho)
    rho = all_rho(i);
    
    figure;
    
    mean_y = zeros(num_mth, n);
    for m=1:num_mth
        mean_y(m, :) = all_EV{m}(i, :);
    end
    
    hold on;
    grid on;
    
    for m=1:num_mth
        plot(-0.05, -0.05, [colors{m} lines{m} shapes{m}], 'linewidth', line_w);
    end
    
    % mark
    for m=1:num_mth
        if strcmp(shapes{m}, '')
            continue;
        end
        plot(x(ind{m}), mean_y(m, ind{m}), [colors{m} shapes{m}], 'linewidth', line_w);
    end
    
    % line
    for m=1:num_mth
        plot(x, mean_y(m, :), [colors{m}, lines{m}], 'linewidth', line_w);
    end
    
    
    ftsize = 20;
    xlabel('Number of Samples','FontSize',ftsize);
    ylabel('EV','FontSize',ftsize);
    set(gca,'FontSize',ftsize, 'xtick', [1 (n/5):(n/5):n]);
    xlim([1, n]);
    
    y_max = max(max(mean_y));
    if y_max < 0.95
        y_max = 1;
    else
        y_max = 1.05;
    end
    ylim([0, y_max]);
    
    box on;
    grid on;
    
    hlg = legend('OMRMD', 'OR-PCA', 'PCP', 'Online PCA', 'Location','SouthEast');
    set(hlg, 'FontSize', 18);
    
    %     set(gcf, 'PaperPosition', paper_pos);
    %     set(gcf, 'PaperSize', paper_sz);
    
    fig_name = sprintf(config.fig_file_format, rho);
    %     saveas(gcf, fig_name, 'fig' );
    
    eps_name = sprintf(config.eps_file_format, rho);
    %     saveas(gcf, eps_name, 'psc2' );
    
    hold off;
end

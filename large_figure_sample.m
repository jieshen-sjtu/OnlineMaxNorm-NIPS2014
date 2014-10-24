% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% plot EV w.r.t. #samples
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = large_config();

load(config.stat_file_format);

methods = config.methods;
num_mth = length(methods);
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
    
    x = all_x{i};
    mean_EV = all_EV{i};
    
    p = all_p(i);
    d = all_d(i);
    n = length(x);
    
    pt = n/20;
    
    ind = cell(1, num_mth);
    for m=1:num_mth
        ind{m} = 1:pt:n;
    end
    
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
        plot(x(ind{m}), mean_EV(m, ind{m}), [colors{m} shapes{m}], 'linewidth', line_w);
    end
    
    
    for m=1:num_mth
        plot(x, mean_EV(m, :), [colors{m}, lines{m}], 'linewidth', line_w);
    end
    
    ftsize = 22;
    xlabel('Number of Samples','FontSize',ftsize);
    ylabel('EV','FontSize',ftsize);
    set(gca,'FontSize',ftsize, 'xtick', [(n/5):(n/5):n]);
    xlim([1, n]);
    
    y_max = max(max(mean_EV));
    if y_max < 0.95
        y_max = 1;
    else
        y_max = 1.05;
    end
    ylim([0, y_max]);
    
    hlg = legend('OMRMD', 'OR-PCA', 'PCP', 'Location','SouthEast');
    set(hlg, 'FontSize', 22);
    
    %     set(gcf, 'PaperPosition', paper_pos);
    %     set(gcf, 'PaperSize', paper_sz);
    
    fig_name = sprintf(config.fig_file_format, p, d, rho, n);
    %         saveas(gcf, fig_name, 'fig' );
    
    eps_name = sprintf(config.eps_file_format, p, d, rho, n);
    %         saveas(gcf, eps_name, 'psc2' );
    hold off;
    
end
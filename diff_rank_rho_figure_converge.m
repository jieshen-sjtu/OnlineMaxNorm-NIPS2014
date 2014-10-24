% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% plot EV w.r.t. #samples, under different rank and rho
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = diff_rank_rho_config();

methods = {'mrmd', 'orpca'};
num_mth = length(methods);

rank_ratio = config.rank_ratio;
all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;
n = config.n;

%% load data
load(sprintf(config.stat_file_format, 'converge'));

%% figure

x = 1:n;

ind = 1:(n/20):n;

len = 6;
paper_pos = [0 0 len len] ;
paper_sz = [len len] ;

colors = config.colors;
shapes = config.shapes;
lines = config.lines;

line_w = 4;

for j=1:2:length(all_d)
    d = all_d(j);
    ratio = rank_ratio(j);
    for i=1:4:length(all_rho)
        rho = all_rho(i);
        
        all_EV = converge_EV{j, i};
        
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
            plot(x(ind), all_EV(m, ind), [colors{m} shapes{m}], 'linewidth', line_w);
        end
        
        % line
        for m=1:num_mth
            plot(x, all_EV(m, :), [colors{m}, lines{m}], 'linewidth', line_w);
        end
        
        
        ftsize = 20;
        xlabel('Number of Samples','FontSize', ftsize);
        ylabel('EV','FontSize', ftsize);
        
        title_name = sprintf('rank = %d, %s = %g', d, '\rho', rho);
        title(title_name, 'FontSize', ftsize + 2);
        set(gca,'FontSize',ftsize, 'xtick', [1, (n/5):(n/5):n]);
        
        xlim([1, n]);
        
        %y_min = ceil(100 * max(min(mrmd_ev(end), orpca_ev(end)) - 0.1, 0) / 5) * 5 / 100;
        y_max = max(max(all_EV));
        if y_max < 0.95
            y_max = 1;
        else
            y_max = 1.05;
        end
        y_min = 0;
        ylim([y_min, y_max]);
        
        set(gca,'FontSize',ftsize);
        leg = legend('OMRMD', 'OR-PCA', 'Location','SouthEast');
        %set(leg, 'FontSize', ftsize);
        
        hold off;
        fig_name = sprintf(config.converge_fig_file_format, d, rho);
        %         saveas(gcf, fig_name, 'fig' );
        
        eps_name = sprintf(config.converge_eps_file_format, d, rho);
        %         saveas(gcf, eps_name, 'psc2');
        
    end
end
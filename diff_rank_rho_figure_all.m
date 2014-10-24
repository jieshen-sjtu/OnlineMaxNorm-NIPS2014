% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% plot EV under different rank and rho
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = diff_rank_rho_config();

methods = config.methods;

rank_ratio = config.rank_ratio;
all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;

%% load data
load(sprintf(config.stat_file_format, 'all'));

%% processing due to the annoying property of imagesc
% we compute the EV map by hand and use image() function
max_val = -1;
min_val = 1;

for m=1:length(methods)
    max_val = max(max_val, max(max(all_EV{m})));
    min_val = min(min_val, min(min(all_EV{m})));
end

max_all = 70;
min_all = 0;

p = (max_all - min_all) / (max_val - min_val);
q = (max_val * min_all - min_val * max_all) / (max_val - min_val);

for m=1:length(methods)
%     cur_max = max(max(all_EV{m}));
%     cur_min = min(min(all_EV{m}));
%     if cur_max == cur_min
%         cur_max = cur_max + 1e-10;
%     end
%     
%     p = (max_val - min_val) / (cur_max - cur_min);
%     q = (cur_max * min_val - cur_min * max_val) / (cur_max - cur_min);
    
    all_EV{m} = p * all_EV{m} + q;
end
        


%% figure
len = 6;
paper_pos = [0 0 len len] ;
paper_sz = [len len] ;

for mth=1:length(methods)
    figure;
    
    y = all_EV{mth};
    
    image(y);
    colormap gray;
    
    
    ftsize = 20;
    xlabel('rank / ambient dimension','FontSize',ftsize);
    ylabel('fraction of corruption','FontSize',ftsize);
    set(gca,'FontSize',ftsize, 'xtick', [1:3:13]);
    set(gca,'FontSize',ftsize, 'xtickLabel', [0.02:0.12:0.5]);
    set(gca,'FontSize',ftsize, 'ytick', [1:3:13]);
    set(gca,'FontSize',ftsize, 'ytickLabel', [0.5:-0.12:0.02]);
%     set(gca,'FontSize',ftsize, 'xtickLabel', [0.05:0.06:0.47]);
%     set(gca,'FontSize',ftsize, 'ytickLabel', [0.05:0.06:0.47]);
%     xlim([0.02, 0.5]);
%     ylim([0.02, 0.5]);
    
%     set(gcf, 'PaperPosition', paper_pos);
%     set(gcf, 'PaperSize', paper_sz);
    
    fig_name = sprintf(config.fig_file_format, methods{mth});
%     saveas(gcf, fig_name, 'fig' );
    
    eps_name = sprintf(config.eps_file_format, methods{mth});
%     saveas(gcf, eps_name, 'psc2' );
    
    hold off;
end

% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% Generate data
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = diff_rank_rho_config();

p = config.p;
n = config.n;
rank_ratio = config.rank_ratio;
all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;

addpath('js/');

for k=1:length(all_rep)
    for i=1:length(all_rho)
        for j=1:length(all_d)
            
            d = all_d(j);
            ratio = rank_ratio(j);
            rho = all_rho(i);
            rep = all_rep(k);
            
            [U, V, E] = js_gen_data(p, d, n, rho);
            
            data_file = sprintf(config.data_file_format, ratio, rho, rep);
            save(data_file, 'U', 'V', 'E', '-v7.3');
            fprintf('write data to %s\n', data_file);
        end
    end
end
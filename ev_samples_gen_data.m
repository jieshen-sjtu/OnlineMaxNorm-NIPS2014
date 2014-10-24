% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% Generate data
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = ev_samples_config();

all_rho = config.rho;
all_rep = config.repetitions;

addpath('js/');

for k=1:length(all_rep)
    rep = all_rep(k);
    
    for i=1:length(all_rho)
        rho = all_rho(i);
        
        [U, V, E] = js_gen_data(config.p, config.d, config.n, rho);
        
        data_file = sprintf(config.data_file_format, rho, rep);
        save(data_file, 'U', 'V', 'E', '-v7.3');
    end
end
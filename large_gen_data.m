% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% Generate data
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = large_config();

all_rho = config.rho;
all_p = config.p;
all_n = config.n;
all_d = config.d;
all_rep = config.repetitions;

addpath('js/');

for k=1:length(all_rep)
    rep = all_rep(k);
    
    for i=1:length(all_rho)
        rho = all_rho(i);
        
        for j=1:length(all_p)
            p = all_p(j);
            d = all_d(j);
            n = all_n(j);
            
            fprintf('Large Gen Data: rep = %d, rho = %g, p = %d, d = %d, n = %d\n', rep, rho, p, d, n);
            
            [U, V, E] = js_gen_data(p, d, n, rho);
            
            data_file = sprintf(config.data_file_format, p, d, rho, n, rep);
            save(data_file, 'U', 'V', 'E', '-v7.3');
        end
    end
end
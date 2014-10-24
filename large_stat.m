% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% collect results
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = large_config();

methods = {'mrmd', 'orpca', 'pcp'};

rank_ratio = config.rank_ratio;
rho = config.rho;
all_rep = config.repetitions;
all_p = config.p;
all_n = config.n;
all_d = config.d;

%% data: rep * n * method * p

all_EV = cell(1, length(all_p));
all_T = cell(1, length(all_p));

all_x = cell(1, length(all_p));

for i=1:length(all_p)
    p = all_p(i);
    n = all_n(i);
    d = all_d(i);
    
    all_EV{i} = zeros(length(methods), n);
    all_T{i} = zeros(length(methods), n);
    
    for mth = 1:length(methods)
        method = methods{mth};
        
        ev = zeros(1, n);
        t = zeros(1, n);
        
        for k=1:length(all_rep)
            rep = all_rep(k);
            
            result_file = sprintf(config.result_file_format, method, method, p, d, rho, n, rep);
            load(result_file);
            
            ev = ev + EV;
            t = t + T;
        end
        
        ev = ev / length(all_rep);
        t = t / length(all_rep);
        
        all_EV{i}(mth, :) = ev;
        all_T{i}(mth, :) = t;
    end
    
    all_x{i} = 1:n;
end

save(config.stat_file_format, 'all_x', 'all_EV', 'all_T');

fprintf('save to %s\n', config.stat_file_format);

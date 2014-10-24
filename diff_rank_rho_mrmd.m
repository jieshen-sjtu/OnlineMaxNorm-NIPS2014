% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% run the experiments with OMRMD
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;
%% config the project

method = 'mrmd';

config = diff_rank_rho_config();

p = config.p;
n = config.n;
rank_ratio = config.rank_ratio;
all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;

lambda1 = 1/sqrt(config.p);
lambda2 = 1/sqrt(config.p);

%% add path
addpath('js');

%% compute EV for OMRMD
for k=1:length(all_rep)
    rep = all_rep(k);
    
    for i=1:length(all_rho)
        rho = all_rho(i);
        
        for j=1:length(all_d)
            
            d = all_d(j);
            ratio = rank_ratio(j);
            
            fprintf('OMRMD: rep = %d, d = %d, rho = %.2f\n', rep, d, rho);
            
            result_file = sprintf(config.result_file_format, method, method, ratio, rho, rep);
            
            % if we have got the result file, skip
            % comment the if statement if we need to re-launch the completed exp
            if exist(result_file, 'file')
                continue;
            end
            
            data_file = sprintf(config.data_file_format, ratio, rho, rep);
            load(data_file);
            
            Z = U * V' + E;
            
            [L_est, ~, ~] = js_solve_mrmd(Z, d, lambda1, lambda2);
            
            EV = zeros(1, n);
            UUt = U * U';
            traceUUt = trace(UUt);
            for t=1:n
                EV(t) = js_compute_EV(L_est{t+1}, UUt, traceUUt);
            end
            
            save(result_file, 'EV');
            fprintf('save to %s\n', result_file);
        end
    end
end

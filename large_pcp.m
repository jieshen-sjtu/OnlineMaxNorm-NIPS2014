% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% run exp with PCP, code provided by Zhouchen Lin

clear;
%% config the project

config = large_config();

method = 'pcp';

all_p = config.p;
all_d = config.d;
all_n = config.n;
all_rho = config.rho;
all_rep = config.repetitions;

%% add path
addpath('PROPACK/');
addpath('inexact_alm_rpca/');

%% compute EV

for k=1:length(all_rep)
    rep = all_rep(k);
    for i=1:length(all_rho)
        rho = all_rho(i);
        
        for j=1:length(all_p)
            p = all_p(j);
            d = all_d(j);
            n = all_n(j);
            
            fprintf('PCP: rep = %d, rho = %g, p = %d, d = %d, n = %d\n', rep, rho, p, d, n);
            
            result_file = sprintf(config.result_file_format, method, method, p, d, rho, n, rep);
            
            % if we have got the result file, skip
            % comment the if statement if we need to re-launch the completed exp
            if exist(result_file, 'file')
                continue;
            end
            
            data_file = sprintf(config.data_file_format, p, d, rho, n, rep);
            load(data_file);
            
            Z = U * V' + E;
            
            UUt = U * U';
            traceUUt = trace(UUt);
            
            tic;
            [A, ~, ~] = inexact_alm_rpca(Z);
            
            [L_est, ~, ~] = lansvd(A, d);
            tt = toc;
            
            ev_PCP = js_compute_EV(L_est, UUt, traceUUt);
            
            EV = ev_PCP * ones(1, n);
            T = tt * ones(1, n);
            
            save(result_file, 'EV', 'T', 'L_est', '-v7.3');
            fprintf('save to %s\n', result_file);
        end
    end
end
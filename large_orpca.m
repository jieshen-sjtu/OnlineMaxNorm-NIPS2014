% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% run exp with OR-PCA, code provided by Jiashi Feng

clear;
%% config the project

config = large_config();

method = 'orpca';

all_p = config.p;
all_d = config.d;
all_n = config.n;
all_rho = config.rho;
all_rep = config.repetitions;

%% add path
addpath('jiashi/');

%% compute EV

for k=1:length(all_rep)
    rep = all_rep(k);
    for i=1:length(all_rho)
        rho = all_rho(i);
        
        for j=1:length(all_p)
            p = all_p(j);
            d = all_d(j);
            n = all_n(j);
            
            fprintf('OR-PCA: rep = %d, rho = %g, p = %d, d = %d, n = %d\n', rep, rho, p, d, n);
            
            result_file = sprintf(config.result_file_format, method, method, p, d, rho, n, rep);
            
            % if we have got the result file, skip
            % comment the if statement if we need to re-launch the completed exp
            if exist(result_file, 'file')
                continue;
            end
            
            data_file = sprintf(config.data_file_format, p, d, rho, n, rep);
            load(data_file);
            
            Z = U * V' + E;
            
            lambda1 = 1/sqrt(p);
            lambda2 = 1/sqrt(p);
            
            
            UUt = U * U';
            traceUUt = trace(UUt);
            
            start_sample = 1;
            last_ = 0;
            
            % resume from the tmp results
            if config.resume
                interval = config.save_interval;
                for t=1:(n/interval)
                    tmp_file = sprintf(config.tmp_result_file_format, method, p, d, rho, n, rep, t * interval);
                    if exist(tmp_file, 'file')
                        last_ = t;
                    end
                end
                
                if last_ ~= 0
                    tmp_file = sprintf(config.tmp_result_file_format, method, p, d, rho, n, rep, last_ * interval);
                    load(tmp_file);
                    start_sample = last_ * interval + 1;
                    fprintf('resume from %s\n', tmp_file);
                else
                    fprintf('No file can be used for resumption\n');
                end
            end
            
            if ~config.resume || last_ == 0
                
                L_est = orth(randn(p, d));
                
                A = zeros(d, d);
                B = zeros(p, d);
                
                EV = zeros(1, n);
                T = zeros(1, n);
            end
            
            for t=start_sample:n
                if (mod(t, 100) == 0)
                    fprintf('Large OR-PCA: rep = %d, p = %d, d = %d, rho = %g, n = %d: Access Sample %d\n', rep, p, d, rho, n, t);
                end
                
                z = Z(:, t);
                tic;
                
                [r, e] = solve_proj2(z, L_est, lambda1, lambda2);
                A = A + r * r';
                B = B + (z-e) * r';
                
                L_est = update_col_orpca(L_est, A, B, lambda1);
                T(t) = toc;
                
                EV(t) = js_compute_EV(L_est, UUt, traceUUt);
                
                if mod(t, config.save_interval) == 0
                    tmp_save_file = sprintf(config.tmp_result_file_format, method, p, d, rho, n, rep, t);
                    save(tmp_save_file, 'A', 'B', 'L_est', 'EV', 'T', '-v7.3');
                end
            end
            
            save(result_file, 'EV', 'T', 'L_est', 'A', 'B', '-v7.3');
            fprintf('save to %s\n', result_file);
        end
    end
end
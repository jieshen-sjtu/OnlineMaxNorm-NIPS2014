% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% run the experiments with PCP, code provided by Zhouchen Lin

clear;
%% config the project

config = ev_samples_config();

method = 'pcp';

all_rho = config.rho;
all_rep = config.repetitions;

p = config.p;
d = config.d;
n = config.n;

%% add path
addpath('inexact_alm_rpca/');
addpath('PROPACK/');

%% compute EV

for k=1:length(all_rep)
    rep = all_rep(k);
    
    for i=1:length(all_rho)
        rho = all_rho(i);
        
        fprintf('PCP: rep = %d, rho = %.2f\n', rep, rho);
        
        result_file = sprintf(config.result_file_format, method, method, rho, rep);
        
        % if we have got the result file, skip
        % comment the if statement if we need to re-launch the completed exp
        if exist(result_file, 'file')
            continue;
        end
        
        data_file = sprintf(config.data_file_format, rho, rep);
        load(data_file);
        
        Z = U * V' + E;
        UUt = U*U';
        traceUUt = trace(UUt);
        
        [A, ~, ~] = inexact_alm_rpca(Z);
        
        %[Us, ~, ~] = svds(A, d);
        [Us, ~, ~] = lansvd(A, d);
        ev_PCP = js_compute_EV(Us, UUt, traceUUt);
        
        EV = ev_PCP * ones(1, config.n);
        
        save(result_file, 'EV');
        fprintf('save to %s\n', result_file);
    end
    
end
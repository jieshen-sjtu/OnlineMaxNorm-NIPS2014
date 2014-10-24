% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% run the experiments with Online PCA, implemented by Jiashi Feng

clear;

%% config the project

config = ev_samples_config();

method = 'opca';

all_rho = config.rho;
all_rep = config.repetitions;

%% add path
addpath('jiashi/');

for k=1:length(all_rep)
    rep = all_rep(k);
    for i=1:length(all_rho)
        rho = all_rho(i);
        
        fprintf('OPCA: rep = %d, rho = %.2f\n', rep, rho);
        
        result_file = sprintf(config.result_file_format, method, method, rho, rep);
        
        % if we have got the result file, skip
        % comment the if statement if we need to re-launch the completed exp
        if exist(result_file, 'file')
            continue;
        end
        
        data_file = sprintf(config.data_file_format, rho, rep);
        load(data_file);
        
        Z = U * V' + E;
        
        [ndim,ndata] = size(Z);
        Sigma = zeros(ndim,ndim);
        EV = zeros(1, ndata);
        
        UUt = U * U';
        traceUUt = trace(UUt);
        
        for t = 1:ndata
            if mode(t, 100) == 0
                fprintf('EV OPCA: rep: %d, access sample %d\n', rep, t);
            end
            
            x = Z(:,t);
            Sigma = Sigma + x*x';
            [Uon,tempD] = eigs(Sigma, config.d);
            EV(t) = js_compute_EV(Uon, UUt, traceUUt);
        end
        
        save(result_file, 'EV');
        fprintf('save to %s\n', result_file);
    end
end
% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% collect the results
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = ev_samples_config();

methods = config.methods;

all_rho = config.rho;
all_rep = config.repetitions;

%% data: method * rho * n

all_EV = cell(1, length(methods));

for mth = 1:length(methods)
    all_EV{mth} = zeros(length(all_rho), config.n);
    
    for i=1:length(all_rho)
        rho = all_rho(i);
        
        mean_EV = zeros(1, config.n);
        
        for k=1:length(all_rep)
            rep = all_rep(k);
            
            result_file = sprintf(config.result_file_format, methods{mth}, methods{mth}, rho, rep);
            load(result_file);
            
            mean_EV = mean_EV + EV;
        end
        
        mean_EV = mean_EV / length(all_rep);
        
        all_EV{mth}(i, :) = mean_EV;
    end
end

save(config.stat_file_format, 'all_EV');
fprintf('save to %s\n', config.stat_file_format);

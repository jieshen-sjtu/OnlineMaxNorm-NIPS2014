% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% collect the results
%
% Copyright by Jie Shen, js2007@rutgers.edu

clear;

config = diff_rank_rho_config();

methods = config.methods;

rank_ratio = config.rank_ratio;
all_d = config.d;
all_rho = config.rho;
all_rep = config.repetitions;
n = config.n;

%% collect all averaged data
all_data = zeros(length(methods), length(all_d), length(all_rho), n);

for mth = 1:length(methods)
    fprintf('loading data for %s\n', methods{mth});
    
    for j=1:length(all_d)
        d = all_d(j);
        ratio = rank_ratio(j);
        
        for i=1:length(all_rho)
            rho = all_rho(i);
            
            ev = zeros(1, n);
            for k=1:length(all_rep)
                rep = all_rep(k);
                
                result_file = sprintf(config.result_file_format, methods{mth}, methods{mth}, ratio, rho, rep);
                load(result_file);
                
                ev = ev + EV;
            end
            
            ev = ev / length(all_rep);
            
            all_data(mth, j, i, :) = ev;
        end
    end
end

%% final EV w.r.t. rho and rank
%{rho * rank}
all_EV = cell(1, length(methods));

for mth = 1:length(methods)
    all_EV{mth} = zeros(length(all_rho), length(all_d));
    
    for j=1:length(all_d)
        for i=1:length(all_rho)
            
            EV = all_data(mth, j, i, :);
            
            ev = EV(end);
            
            all_EV{mth}(length(all_rho) + 1 - i, j) = ev;
        end
    end
end

stat_file = sprintf(config.stat_file_format, 'all');
save(stat_file, 'all_EV');
fprintf('save to %s\n', stat_file);

%% examine the convergence: EV w.r.t. #samples, under different rank and rho
% {EV * n}
converge_EV = cell(length(all_d), length(all_rho));
for j=1:length(all_d)
    for i=1:length(all_rho)
        converge_EV{j, i} = zeros(length(methods), n);
        for mth=1:length(methods)
            converge_EV{j, i}(mth, :) = all_data(mth, j, i, :);
        end
    end
end

stat_file = sprintf(config.stat_file_format, 'converge');
save(stat_file, 'converge_EV');
fprintf('save to %s\n', stat_file);

%% examine the robustness to corruption: EV w.r.t. rho, under different rank
% {EV * rho}
robust_EV = cell(1, length(all_d));
for j=1:length(all_d)
    robust_EV{j} = zeros(length(methods), length(all_rho));
    for mth=1:length(methods)
        for i=1:length(all_rho)
            robust_EV{j}(mth, i) = all_data(mth, j, i, end);
        end
    end
end

stat_file = sprintf(config.stat_file_format, 'robust');
save(stat_file, 'robust_EV');
fprintf('save to %s\n', stat_file);

% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% configure file to examine the EV values under different rank and rho
%
% Copyright by Jie Shen, js2007@rutgers.edu

function [ config ] = diff_rank_rho_config()

test_mode = false;

task = 'diff';

config.methods = {'mrmd', 'orpca', 'pcp'};

root_dir = ['ExpData/' task '/'];
if ~exist(root_dir, 'dir')
    mkdir(root_dir)
end

config.data_dir = [root_dir 'data/'];
if ~exist(config.data_dir, 'dir')
    mkdir(config.data_dir);
end

config.result_dir = [root_dir 'result/'];
if ~exist(config.result_dir, 'dir')
    mkdir(config.result_dir);
end

config.sub_result_dirs = cell(1, length(config.methods));
for i=1:length(config.methods)
    config.sub_result_dirs{i} = [config.result_dir config.methods{i} '/'];
    if ~exist(config.sub_result_dirs{i}, 'dir')
        mkdir(config.sub_result_dirs{i});
    end
end

config.stat_dir = [root_dir 'stat/'];
if ~exist(config.stat_dir, 'dir')
    mkdir(config.stat_dir);
end

config.figure_dir = [root_dir 'figure/'];
if ~exist(config.figure_dir, 'dir')
    mkdir(config.figure_dir);
end

% format: rank_ratio rho repetition
config.data_file_format = [config.data_dir task '_data_rank_%.2f_rho_%.2f_rep_%d.mat'];
% format: method method rank_ratio rho repetition
config.result_file_format = [config.result_dir '%s/' task '_result_%s_rank_%.2f_rho_%.2f_rep_%d.mat'];
% format: task
config.stat_file_format = [config.stat_dir task '_stat_%s.mat'];

%% figure
config.colors = {'r', 'b', 'k', 'g', 'm', 'c', 'y'};
% config.shapes = {'>', 's', 'd', 'x', 'o', '.', '^'};
config.shapes = {'', '', '>', '', 'o', '.', '^'};
config.lines = {'-', '--', '-', '-', '-', '-', '-'};

% this plots a matrix for different methods, with x/y axis = rank_ratio/rho
% format: method
config.fig_file_format = [config.figure_dir task '_rank_rho_%s.fig'];
config.eps_file_format = [config.figure_dir task '_rank_rho_%s.eps'];

% EV w.r.t. rho, under different rank, examine the robustness
% format: rank
config.robust_fig_file_format = [config.figure_dir task '_robust_rank_%d.fig'];
config.robust_eps_file_format = [config.figure_dir task '_robust_rank_%d.eps'];

% EV w.r.t. number of samples, examine the convergence speed
% format: rank rho
config.converge_fig_file_format = [config.figure_dir task '_converge_rank_%d_rho_%.2f.fig'];
config.converge_eps_file_format = [config.figure_dir task '_converge_rank_%d_rho_%.2f.eps'];

config.p = 400;
config.n = 5000;

config.rank_ratio = 0.02:0.04:0.5;
config.rho = 0.02:0.04:0.5;

config.d = round(config.p * config.rank_ratio);

config.repetitions = 1:10;

if test_mode
    config.p = 20;
    config.n = 100;
    config.rho = [0.01, 0.1];
    config.d = [5, 10];
    config.repetitions = 1:2;
    
    task = ['test_' task];
    
    config.data_file_format = [config.data_dir task '_data_rank_%.2f_rho_%.2f_rep_%d.mat'];
    config.result_file_format = [config.result_dir '%s/' task '_result_%s_rank_%.2f_rho_%.2f_rep_%d.mat'];
    config.stat_file_format = [config.stat_dir task '_stat_%s.mat'];
    
    config.fig_file_format = [config.figure_dir task '_rank_rho_%s.fig'];
    config.eps_file_format = [config.figure_dir task '_rank_rho_%s.eps'];
    
    config.robust_fig_file_format = [config.figure_dir task '_robust_rank_%d.fig'];
    config.robust_eps_file_format = [config.figure_dir task '_robust_rank_%d.eps'];
    
    config.converge_fig_file_format = [config.figure_dir task '_converge_rank_%d_rho_%.2f.fig'];
    config.converge_eps_file_format = [config.figure_dir task '_converge_rank_%d_rho_%.2f.eps'];
end

end

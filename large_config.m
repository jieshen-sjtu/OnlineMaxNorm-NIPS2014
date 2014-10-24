% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% configure file to examine the EV values w.r.t. #samples under different ambient dimension
%
% Copyright by Jie Shen, js2007@rutgers.edu

function [ config ] = large_config()

test_mode = false;

task = 'large';

config.resume = 1;

config.methods = {'mrmd', 'orpca', 'pcp'};

%% dirs
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

config.tmp_result_dir = [root_dir 'tmp_result/'];
if ~exist(config.tmp_result_dir, 'dir')
    mkdir(config.tmp_result_dir);
end

config.stat_dir = [root_dir 'stat/'];
if ~exist(config.stat_dir, 'dir')
    mkdir(config.stat_dir);
end

config.figure_dir = [root_dir 'figure/'];
if ~exist(config.figure_dir, 'dir')
    mkdir(config.figure_dir);
end

%% data
config.rank_ratio = 0.1;
config.p = [400, 1000, 3000];
config.n = [1e5, 1e5, 1e5];
config.d = round(config.rank_ratio * config.p);

config.rho = 0.3;

config.repetitions = 1:10;

config.save_interval = 2e4;

%% files
% format: p d rho n rep
config.data_file_format = [config.data_dir task '_data_p_%d_d_%d_rho_%g_n_%d_rep_%d.mat'];
% format: method p d rho n rep iteration
config.tmp_result_file_format = [config.tmp_result_dir task '_result_%s_p_%d_d_%d_rho_%g_n_%d_rep_%d_iter_%d.mat'];
% format: method method p d rho n rep
config.result_file_format = [config.result_dir '%s/' task '_result_%s_p_%d_d_%d_rho_%g_n_%d_rep_%d.mat'];
config.stat_file_format = [config.stat_dir task '_stat.mat'];
config.fig_file_format = [config.figure_dir task '_p_%d_d_%d_rho_%g_n_%d.fig'];
config.eps_file_format = [config.figure_dir task '_p_%d_d_%d_rho_%g_n_%d.eps'];

config.time_fig_file_format = [config.figure_dir task '_p_%d_d_%d_rho_%g_n_%d_time.fig'];
config.time_eps_file_format = [config.figure_dir task '_p_%d_d_%d_rho_%g_n_%d_time.eps'];

%% figure setting
config.colors = {'r', 'b', 'k', 'g', 'm', 'c', 'y'};
% config.shapes = {'>', 's', 'd', 'x', 'o', '.', '^'};
config.shapes = {'', '', '>', '', 'o', '.', '^'};
config.lines = {'-', '--', '-', '-', '-', '-', '-'};

if test_mode
    config.p = 100;
    config.n = 1000;
    config.rho = 0.3;
    config.d = 10;
    config.repetitions = 1;
    config.save_interval = 200;
    
    task = ['test_' task];
    
    config.data_file_format = [config.data_dir task '_data_p_%d_d_%d_rho_%g_n_%d_rep_%d.mat'];
    config.tmp_result_file_format = [config.tmp_result_dir task '_result_%s_p_%d_d_%d_rho_%g_n_%d_rep_%d_iter_%d.mat'];
    config.result_file_format = [config.result_dir '%s/' task '_result_%s_p_%d_d_%d_rho_%g_n_%d_rep_%d.mat'];
    config.stat_file_format = [config.stat_dir task '_stat.mat'];
    config.fig_file_format = [config.figure_dir task '_p_%d_d_%d_rho_%g_n_%d.fig'];
    config.eps_file_format = [config.figure_dir task '_p_%d_d_%d_rho_%g_n_%d.eps'];
    
    config.time_fig_file_format = [config.figure_dir task '_p_%d_d_%d_rho_%g_n_%d_time.fig'];
    config.time_eps_file_format = [config.figure_dir task '_p_%d_d_%d_rho_%g_n_%d_time.eps'];
end

end


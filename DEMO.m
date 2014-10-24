% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% demo to show how to use the code
%
% Copyright by Jie Shen, js2007@rutgers.edu

%% generate data, this should only be called once to generate the same data for all competing methods
ev_samples_gen_data;

%% run all methods
ev_samples_mrmd;
ev_samples_orpca;
ev_samples_pcp;
ev_samples_opca;

%% collect the results
ev_samples_stat;

%% plot results
ev_samples_figure;
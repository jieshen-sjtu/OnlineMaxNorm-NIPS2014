% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% Generate a data matrix Z = U * V' + E, with each column being a sample
% U: p * d, i.i.d. N(0, 1)
% V: n * d, i.i.d. N(0, 1)
% E: p * n, uniform over [-1000, 1000]
% p: ambient dimension
% d: intrinsic dimension
% n: #samples
% rho: corruption fraction
%
% Copyright by Jie Shen, js2007@rutgers.edu

function [U, V, E] = js_gen_data(p, d, n, rho)

mu = 0;
sigma = sqrt(1);

U = mu + sigma * randn(p, d);
U = orth(U);
V = mu + sigma * randn(n, d);

num_elements = p * n;
temp = randperm(num_elements) ;
numCorruptedEntries = round(rho * num_elements) ;
corruptedPositions = temp(1:numCorruptedEntries) ;
E = zeros(p, n);
E(corruptedPositions) = 2000*(rand(numCorruptedEntries, 1) - 0.5) ;

end
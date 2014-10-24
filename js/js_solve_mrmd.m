% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% Main entry point for solving online max-norm regularized matrix decomposition prbolem (OMRMD)
%   min_{L, R, E} \sum_{i=1}^n (0.5 * || z_i - L*r_i - e_i ||_2^2 + \lambda_2 || e_i ||_1) + \frac{\lambda_1}{2} || L ||_{2, \infty}^2
%   s.t.          || r_i ||_2 <= 1, i=1,2,...,n
%
% L: p * d, optimal basis
% R: n * d, coefficients
% E: p * n, sparse error
% Z: p * n, data matrix
% d: assumed rank of Z
% lambda1, lambda2: two tunable parameters
%
% Copyright by Jie Shen, js2007@rutgers.edu

% warning: Don't use this function for large-scale testing, as L_est is the collection of all past basis!!!
% For large-scale testing, see large_mrmd.m for reference.

function [L_est, R_est, E_est] = js_solve_mrmd( Z, d, lambda1, lambda2 )

%% initialization
[p, n] = size(Z);
L_est = cell(1, n+1);
L_est{1} = rand(p, d);
R_est = zeros(n, d);
E_est = zeros(p, n);

A = zeros(d, d);
B = zeros(p, d);

%% online optimization
for t = 1:n
    
    if mod(t, 200) == 0
        display(sprintf('OMRMD: Access sample %d', t));
    end
    
    z = Z(:,t);
    
    [r, e] = js_solve_re(z, L_est{t}, lambda2);
    
    R_est(t, :) = r';
    E_est(:, t) = e;
    
    A = A + r * r';
    B = B + (z-e) * r';
    
    %         display(sprintf('rank(A) = %f, det(A) = %f', rank(A), det(A) / t));
    
    L_est{t+1} = js_solve_L(L_est{t}, A, B, lambda1);
    
    %display(sprintf('norm of L = %f', norm(L_est{t+1}, 'fro')));
end

end


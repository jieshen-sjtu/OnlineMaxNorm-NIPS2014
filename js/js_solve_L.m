% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% Main entry point for solving online max-norm regularized matrix decomposition prbolem (OMRMD)
%   min_{L, R, E} \sum_{i=1}^n (0.5 * || z_i - L*r_i - e_i ||_2^2 + \lambda_2 || e_i ||_1) + \frac{\lambda_1}{2} || L ||_{2, \infty}^2
%   s.t.          || r_i ||_2 <= 1, i=1,2,...,n
%
% L_est: p * d, optimal basis (updated)
% L: p * d, previous optimal basis
% A: d * d, equals to \sum_{i=1}^t r * r'
% B: p * d, equals to \sum_{i=1}^t (z-e)*r'
% lambda1: parameter
%
% Copyright by Jie Shen, js2007@rutgers.edu

function [L_est] = js_solve_L(L, A, B, lambda1)

L_est = update_col(L, A, B, lambda1);

end

%% block coodinate
function L = update_col(L,A,B,lambda1)
[junk,ncol] = size(L);
U = subgrad_2_inf(L);

for j = 1:ncol
    bj = B(:,j);
    lj = L(:,j);
    aj = A(:,j);
    uj = U(:,j);
    temp = lj - (L*aj - bj + lambda1 * uj) / (A(j,j) + 0.001);
    L(:,j) = temp/max(norm(temp),1);
end
end

%% find subgradient of 0.5 * \| L \|_{2, inf}^2

function [U] = subgrad_2_inf(L)

[p, d] = size(L);
norm2 = zeros(p, 1);

for i=1:p
    norm2(i) = norm(L(i, :));
end

k = max(norm2);

Q = find(norm2 == k);

mu = zeros(p, 1);

mu(Q) = 1 / length(Q);

mu = repmat(mu, 1, d);

U = mu .* L;

end


%% gradient decent, slow convergence rate
function [ L_est ] = js_solve_L_gd( L, A, B, lambda1 )

max_iter = 100;

base_eta = 0.1;

[p, d] = size(L);

for iter = 1:max_iter
    U = subgrad_2_inf(L);
    Lorg = L;
    
    grad = Lorg * A - B + lambda1 * U;
    
    eta = base_eta / iter;
    L = Lorg - eta * grad;
    
    %     display(sprintf('L = %f, gradient = %f', norm(L, 'fro'), norm(grad, 'fro')));
    
    %     for j=1:d
    %         aj = A(:, j);
    %         bj = B(:, j);
    %         uj = U(:, j);
    %         L(:,j) = Lorg(:, j) - (Lorg * aj - bj + lambda1 * uj) ./ A(j,j);
    
    %         normj = norm(L(:,j));
    %         if normj > 1
    %             L(:,j) = L(:,j) ./ normj;
    %         end
    %     end
end

L_est = L;

end

%% gradient = L * A - B + lambda1 * U should be zero, applicable when A is invertable
% L_{k+1} = (B - lambda1 * U_k) * inv(A)
function [L_est] = js_solve_L_iter( L, A, B, lambda1 )

Ainv = inv(A);

I = eye(size(A));

converge = false;

L_est = L;

num_converge = 1;

max_num_conv = 1e4;

while ~converge
    U = subgrad_2_inf(L_est);
    
    grad = L_est * A - B + lambda1 * U;
    
    stopc = norm(grad, 'fro');% / norm(L_est, 'fro');
    
    %display(sprintf('grad = %f\n', stopc));
    
    if stopc < 0.01 || num_converge > max_num_conv
        converge = true;
    else
        
        %L_est = L * (A + I) - B + lambda1 * U;
        L_est = (B - lambda1 * U) * Ainv;
        
        num_converge = num_converge + 1;
    end
end

display(sprintf('num converge = %d', num_converge));
if num_converge > max_num_conv
    display(sprintf('reach max iter, grad = %f', stopc));
end

end

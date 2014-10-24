% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% solve the problem: 
%   min_{r, e} 0.5 * || z - L*r - e ||_2^2 + \lambda_2 || e ||_1, s.t. || r ||_2 <= 1
%
% r: d * 1, optimal basis
% e: p * 1, optimal sparse error
% z: p * 1, observed data
% L: basis computed in the previous iteration
% lambda2: parameter
%
% Copyright by Jie Shen, js2007@rutgers.edu

function [r, e] = js_solve_re(z, L, lambda2)

% initialization
[p, d] = size(L);

r = zeros(d, 1);
e = zeros(p, 1);

converged = false;
maxIter = 100;
iter = 0;

I = eye(d, d);

% alternatively update
LLtinv = (L'* L + 0.01 * I) \ L';
% LLtinv = pinv(L' * L) * L';

% LtL_pad = [L' * L; zeros(1, d)];

while ~converged
    iter = iter + 1;
    rorg = r;
    
    diff_ze = z - e;
    
%     r0 = (L' * L + 0.0001 * I) \ (L' * diff_ze);
    r0 = LLtinv * diff_ze;
%     r0 = LtL_pad \ [L' * diff_ze; 0];
    norm_r0 = norm(r0);
    
    if norm_r0 <= 1
        r = r0;
    else
        [r, eta] = js_solve_r( L, diff_ze);
    end
    
    eorg = e;
    
    % soft-thresholding
    e = wthresh(z - L * r, 's', lambda2);
    
    stopc = max(norm(e - eorg), norm(r - rorg))/ p;
    
    if stopc < 1e-6 || iter > maxIter
        converged = true;
    end
end

end



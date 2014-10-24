% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% Use the Lagrange multipliers methods to compute the optimal basis r:
%   max_{\eta} min_{r} 0.5 * || z - L*r - e ||_2^2 + \frac{\eta}{2}(|| r ||_2^2 - 1), 
%   s.t.               \eta > 0, || r ||_2 <= 1
%
% r: d * 1, optimal basis
% eta: Lagrange dual variable
% L: basis computed in the previous iteration
% diff_ze: z - e
%
% Copyright by Jie Shen, js2007@rutgers.edu

function [r, eta] = js_solve_r(L, diff_ze)
aux_data = L' * diff_ze;
LtL = L' * L;

d = size(L, 2);
I = eye(d, d);

start_pt = 0;
end_pt = 10;
eta = end_pt;
converged = false;

% find a correct region
while ~converged
    r = (LtL + eta * I) \ aux_data;
    nrm = norm(r);
    
    if nrm < 1
        converged = true;
    else
        eta = eta * 2;
    end
end

end_pt = eta;
converged = false;
eta = (start_pt + end_pt) /2;

while ~converged
    r = (LtL + eta * I) \ aux_data;
    nrm = norm(r);
    
    mid_pt = (start_pt + end_pt ) /2;
    
    if abs(1 - nrm) < 1e-3
        converged = true;
    else
        if nrm > 1
            start_pt = mid_pt;
        else
            end_pt = mid_pt;
        end
        eta = (start_pt + end_pt) / 2;
    end
end

end

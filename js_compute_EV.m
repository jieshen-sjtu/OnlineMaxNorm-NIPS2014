% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% comopute the EV values, larger EV means better recovery
%
% assume the true basis is U, and the estimated basis is Lorg
% UUt: U * U'
% traceUUt: trace(UUt)
%
% Copyright by Jie Shen, js2007@rutgers.edu

function [ EV ] = js_compute_EV( Lorg, UUt, traceUUt )

L = orth(Lorg);

EV = trace(L' * UUt * L) / traceUUt;

end


function [A,E,iter] = inexact_alm_rpcai(X,~,M,p)
%% inexact_alm_rpcai.m
% Informed Robust Principal Component Analysis (RPCAi)
%   solve min |A|_*+lambda|E|_1+gamma|E-M|_F^2 s.t. X = A+E
%   using the inexact augmented Lagrangian method (IALM)
% ----------------------------------
% Tak-Shing Chan 27-Sep-2015
% takshingchan@gmail.com
% Copyright: Music and Audio Computing Lab, Academia Sinica, Taiwan
%%

[m,n] = size(X);
XF = norm(X,'fro');

% initialization
E = zeros(m,n);
Y1 = zeros(m,n);
Y2 = zeros(m,n);

for iter = 1:p.maxiter
    %% update A
    [U,S,V] = svd(X-E+Y1/p.mu,'econ');
    S = diag(S)-1/p.mu;
    r = length(find(S>0));
    A = U(:,1:r)*diag(S(1:r))*V(:,1:r)';

    %% update B
    B = E+Y2/p.mu;
    B = max(1-(p.lambda/p.mu)./abs(B),0).*B;

    %% update E
    E = (p.gamma*M+Y1-Y2+p.mu*(X-A+B))/(p.gamma+2*p.mu);

    R1 = X-A-E;
    R2 = E-B;

    Y1 = Y1+p.mu*R1;
    Y2 = Y2+p.mu*R2;
    p.mu = p.rho*p.mu;

    %% check for convergence
    if norm(R1,'fro')/XF<p.tol && norm(R2(:),Inf)<p.tol
        return
    end
end
disp('Maximum iterations exceeded');

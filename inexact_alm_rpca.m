function [A,E,iter] = inexact_alm_rpca(X,~,~,p)
%% inexact_alm_rpca.m
% Robust Principal Component Analysis
%   solve min |A|_*+lambda|E|_1 s.t. X = A+E
%   using the inexact augmented Lagrangian method (IALM)
% ----------------------------------
% Tak-Shing Chan 26-May-2015
% takshingchan@gmail.com
% Copyright: Music and Audio Computing Lab, Academia Sinica, Taiwan
%%

[m,n] = size(X);
XF = norm(X,'fro');

% initialization
E = zeros(m,n);
Y = zeros(m,n);

for iter = 1:p.maxiter
    %% update A
    [U,S,V] = svd(X-E+Y/p.mu,'econ');
    S = diag(S)-1/p.mu;
    r = length(find(S>0));
    A = U(:,1:r)*diag(S(1:r))*V(:,1:r)';

    %% update E
    E = X-A+Y/p.mu;
    E = max(1-(p.lambda/p.mu)./abs(E),0).*E;

    R = X-A-E;

    Y = Y+p.mu*R;
    p.mu = p.rho*p.mu;

    %% check for convergence
    if norm(R,'fro')/XF<p.tol
        return
    end
end
disp('Maximum iterations exceeded');

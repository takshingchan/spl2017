function [DZ,E,iter] = inexact_alm_gsr(X,D,~,p)
%% inexact_alm_gsr.m
% Group Sparse Representation
%   solve min |Z|_1,2+lambda|E|_1 s.t. X = DZ+E
%   using the inexact augmented Lagrangian method (IALM)
% ----------------------------------
% Tak-Shing Chan 26-Sep-2015
% takshingchan@gmail.com
% Copyright: Music and Audio Computing Lab, Academia Sinica, Taiwan
%%

[m,n] = size(X);
k = size(D,2);

% initialization
Z = zeros(k,n);
E = zeros(m,n);
Y1 = zeros(m,n);
Y2 = zeros(k,n);
IDD = inv(eye(k)+D'*D);

for iter = 1:p.maxiter
    %% update J
    J = Z+Y2/p.mu;
    for i = 1:k
        J(i,:) = max(1-(1/p.mu)/norm(J(i,:)),0)*J(i,:);
    end

    %% update Z
    Z = IDD*(D'*(X-E)+J+(D'*Y1-Y2)/p.mu);
    DZ = D*Z;

    %% update E
    E = X-DZ+Y1/p.mu;
    E = max(1-(p.lambda/p.mu)./abs(E),0).*E;

    R1 = X-DZ-E;
    R2 = Z-J;

    Y1 = Y1+p.mu*R1;
    Y2 = Y2+p.mu*R2;
    p.mu = p.rho*p.mu;

    %% check for convergence
    if norm(R1(:),Inf)<p.tol && norm(R2(:),Inf)<p.tol
        return
    end
end
disp('Maximum iterations exceeded');

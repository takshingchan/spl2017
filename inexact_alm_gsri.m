function [DZ,E,iter] = inexact_alm_gsri(X,D,M,p)
%% inexact_alm_gsri.m
% Informed Group Sparse Representation (GSRi)
%   solve min |Z|_1,2+lambda|E|_1+gamma|E-M|_F^2 s.t. X = DZ+E
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
Y3 = zeros(m,n);
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

    %% update B
    B = E+Y3/p.mu;
    B = max(1-(p.lambda/p.mu)./abs(B),0).*B;

    %% update E
    E = (p.gamma*M+Y1-Y3+p.mu*(X-DZ+B))/(p.gamma+2*p.mu);

    R1 = X-DZ-E;
    R2 = Z-J;
    R3 = E-B;

    Y1 = Y1+p.mu*R1;
    Y2 = Y2+p.mu*R2;
    Y3 = Y3+p.mu*R3;
    p.mu = p.rho*p.mu;

    %% check for convergence
    if norm(R1(:),Inf)<p.tol && norm(R2(:),Inf)<p.tol && norm(R3(:),Inf)<p.tol
        return
    end
end
disp('Maximum iterations exceeded');

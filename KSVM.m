function [Alpha, w_0] = KSVM(X, y, param, gamma)
%This function computes the coeffients of the kernals basi and the sclar used in KSVM
%       Z: a dxn data matrix
%       Y = a 1xn label vector of 1 and -1s
%       param: 
%             param.ktype_x : kernel type of the explanatory variable
%             param.kparam_x : kernel parameter of the explanatory variable
%       gamma: the soft margin penalization coefficient

[d n]=size(X);

%construct the matrix used in the QP algo
Y = diag(y);

%see kernal.m for the full list of available Kernals
K = repmat(0,n,n);
for i = 1:n
    for j = 1:n
        K(i,j) = kernel(param.ktype_x,X(:,i),X(:,j),param.kparam_xSVM,[]);
    end
end


S = (Y*K')*K*Y;
f = ones(n,1);
z = zeros(n,1);
g = gamma*ones(n,1);

%
% x = quadprog(H,f) returns a vector x that minimizes 1/2*x'*H*x + f'*x. H must be positive definite for the problem to have a finite minimum.
% 
% x = quadprog(H,f,A,b) minimizes 1/2*x'*H*x + f'*x subject to the restrictions A*x ? b. A is a matrix of doubles, and b is a vector of doubles.
% 
% x = quadprog(H,f,A,b,Aeq,beq) solves the preceding problem subject to the additional restrictions Aeq*x = beq. Aeq is a matrix of doubles, and beq is a vector of doubles.
%

% My QP problem is 
%  max over alpha ( sum_i^n alpha_i - 0.5*( sum_i sum_j alpha_i alpha_j y_i y_j x_i^T x_j ) s.t.  
%   sum_i alpha_i * y_i = 0
%   0 <= alpha_i <= gamma   for all i
% 
options = optimset('Algorithm', 'interior-point-convex', 'MaxIter', 300);

[Alpha, v, exit] = quadprog(S,-f,[],[], y,0, z, g, [], options);


%to compute b0, we need to find an gamma>alpha_i >0,
for i=1:n
    if gamma>Alpha(i)>.0001  %to protect against roundering errors escaping 0.
        w_0 = 1/y(i)*( K(i,:)*(y'.*Alpha) ); 
        break
    end
end

end

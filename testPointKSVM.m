function [label] = testPointKSVM(x, X, Y, Alpha, w_0, param)
%This function classifies a data point x, using the results of a KSVM run


[d n] = size(X);

sum = w_0;
for i = 1:n
    sum = sum + Alpha(i)*Y(i)*kernel(param.ktype_x,X(:,i),x,param.kparam_xSVM,[]);
end
label = sign(sum);


end
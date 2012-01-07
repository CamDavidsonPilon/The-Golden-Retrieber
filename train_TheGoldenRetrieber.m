function [Z, Beta, Alpha, w_0] = train_TheGoldenRetrieber(BieberDir,NonBieberDir)
%This function trains the data to produces parameters for the Golden
%Retrieber.
%   BieberDir: a directory with only Twitter images of Canadian Pop-icon,
%   Justin Bieber.
%   NonBieberDir: a directory with only non-Bieber Twitter display pictures
%   (that are still human though).
%output: The parameters for the Golden Retrieber.

%create the data matrices
s=30;
data = constructDataMatrix( s, BieberDir, 1, 0, 1);
ybieber = ones(1,size(data,2));
n1 = size(data,2);

dataNJB = constructDataMatrix( s, NonBieberDir, 1, 0, 1);
ynjb = -ones(1, size(dataNJB,2)); %changed this
n2 = size(dataNJB,2);

X = [data, dataNJB];
Y = [ybieber, ynjb];

%set parameters for the algorithms
param.ktype_y = 'delta';
param.kparam_y = 0;  
param.ktype_x = 'rbf';
param.kparam_x = 11
param.kparam_xSVM = 0.15;
d=21
gamma = 0.5;

%perform KSPCA on the data.
[Z Beta] = KSPCA(X, Y, d, param);

%so we take the reduced dimension data Z and perform KSVM on it
[Alpha, w_0] = KSVM(Z,Y, param, gamma);

end
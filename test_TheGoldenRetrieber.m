function [label] = test_TheGoldenRetrieber(I, X, Y, Z, Beta, Alpha, w_0)
%Test the Golden Retrieber algorithm!
%   I: a handle to an image you would like to test. Preferably a Twitter
%   dsplay image.
%   X: the training data outputed by train_TheGoldenRetrieber
%   Y: the labels of the training data (should be -1 if not JB, 1 if JB)
%   Z: output from train_TheGoldenRetrieber
%   Z, Beta, Alpha, w_0: output from train_TheGoldenRetrieber
% 
% output: 
%   label: -1 if the classifier says it's not JB, 1 if it is JB.

 
info = imfinfo(I);
%perform preprocessing on the image.      
I = face_cropper(I, info.ColorType); %this not only crops it, but makes it grayscale
I = im2double(I);
I = imresize(I', [s, s]);
x = reshape(I, s*s, 1);




param.ktype_x = 'rbf';
param.kparam_x = 11; %this needs to be tuned using cross-validation. If this parameter too small, the model overfits, too large: underfits

%encode test data:

%constuct K(X,x)
K = zeros(n_train,1);
for j=1:n_train
    K(j) = kernel(param.ktype_x,X(:,j),x ,param.kparam_x,[]);
end

z = Beta'*K;

param.kparam_xSVM = 0.15;

label = testPointKSVM(z, Z, Y, Alpha, w_0, param)



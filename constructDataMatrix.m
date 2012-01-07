function [data] = constructDataMatrix(s, directory, doubleIt, histoEqIt, cropIt)
%This function gets and constructs the matrix of justin bieber pics
%   s: the size to rescale the images to
%   directory: the directory that contains the images, i.e. BDP, NBDP or
%   NotHuman, must be a string!
%   doubleIt: do you want to make the numbers double? 0 if no or 1 if yes
%   histoEqIt: do you want to histogram equalize the image? 0 if no, 1 is
%   yes
%   cropIt: again, do you want to crop it? yes:1 or no:0

%construct data matrix.
%get BDPS 
path = pwd;
path2JB = strcat(path, '/DPs/', directory);
BDPs = dir(path2JB);
BDPs = BDPs(3:end); %to remove the two initial directories
[n m] = size(BDPs);

%scramble the BDPs to help for more accurate cross-validation
%preallocate for speed boost
data = zeros(s*s, n); %as the first two structures are directories
for i=1:n 
    I = imread(strcat(path2JB,'/', BDPs(i).name));
    %we would apply a filter somewhere in here, and we will have to change
    %the amount we preallocated for the data matrix. 
    
    %if the folder we are drawing images from is BDP or NBDP, then we
    %should crop to just the face the photo. We need the img to be rgb.
    info = imfinfo(strcat(path2JB,'/', BDPs(i).name));
    if cropIt      
        if ~strcmp(directory,'NotHuman')
                I = face_cropper(I, info.ColorType); %this not only crops it, but makes it grayscale
        end
    else
        if ~strcmp(info.ColorType,'grayscale')
            I = rgb2gray(I);
        end
    end
    if histoEqIt
        I = histeq(I,64);
    end
    imwrite(I, strcat('images/',BDPs(i).name), 'png');
    if doubleIt
        I = im2double(I);
    end
    I = imresize(I', [s, s]);
    data(:,i) = reshape(I, s*s, 1);
end
function [ outputImage ] = MyCannyEdgeDetector( image, threshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Applying Gaussian Blur
input = rgb2gray(image);
input = uint8(255 * mat2gray(input));
G = fspecial('gaussian',[5 5], 1.4);
blurImage = imfilter(input,G,'same');

%finding gradient
[gradient, direction] = imgradient(blurImage, 'sobel');
gradient = uint8(255 * mat2gray(gradient));

%non-maximum suppression
suppressedImage = NonMaximumSuppression(gradient, direction);

%thresholding and hysterisys
finalOutput = Hysterisys(suppressedImage, threshold);
outputImage = finalOutput;
imshow(finalOutput);

%figure;
%imshow(edge(input,'canny'));
end


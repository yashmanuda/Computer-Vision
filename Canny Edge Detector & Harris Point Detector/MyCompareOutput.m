function [mseValue , psnrValue, matlabOutput, algoOutput] = MyCompareOutput(image, threshold )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

input = rgb2gray(image);
thresholdCanny = threshold/255;
input = uint8(255 * mat2gray(input));

[rows, cols] = size(input);
matlabOutput = edge(input,'canny', thresholdCanny);
algoOutput =  MyCannyEdgeDetector( image, threshold);


figure;
imshowpair(matlabOutput,algoOutput,'montage');
title('Matlab Canny Edge Detection                                                                                                                                   MyCannyEdgeDetector');


psnrValue = zeros( int16(rows/3), int16(cols/3) );
mseValue = zeros(  int16(rows/3), int16(cols/3) );

%psnr value
for  i = 2  : 3 : rows - 1
    for j = 2 : 3 : cols - 1
        subAlgo = uint8(algoOutput( i - 1 : i + 1, j - 1: j + 1) );
        subMat = uint8(matlabOutput( i - 1 : i + 1, j - 1: j + 1) );
        psnrValue( int16(i + 1)/3 ,int16((j + 1)/3) ) =  psnr(subAlgo , subMat);
    end
end

%mean squared error
for  i = 2  : 3 : rows - 1
    for j = 2 : 3 : cols - 1
        subAlgo = uint8(algoOutput( i - 1 : i + 1, j - 1: j + 1) );
        subMat = uint8(matlabOutput( i - 1 : i + 1, j - 1: j + 1) );
        mseValue( int16(i + 1)/3 ,int16((j + 1)/3) ) =  mse(subAlgo , subMat);
    end
end

psnrValue = uint8(psnrValue);
mseValue = uint8(mseValue);

end


function [ outputHarris ] = MyDetectInterest( image , threshold)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

k = 0.04;
thres =10000;

cannyOut = MyCannyEdgeDetector(image, threshold);
[rows,cols] = size(cannyOut);
Fx = [-1, 0, 1];
Fy = [-1 ; 0 ; 1];

Ix = imfilter(cannyOut, Fx, 'same');
Iy = imfilter(cannyOut, Fy,'same');
g = fspecial('gaussian', [5 5 ], 1.5);
Ix = imfilter(Ix, g);
Iy = imfilter(Iy, g);

Ix2 = Ix.^Ix;
Iy2 = Iy.^Iy;
Ixy = Ix.*Iy;
Wxy = 1;
outputHarris = zeros(rows,cols);

for i = 1 : rows
    for j = 1 : cols
        patch = [Ix2(i,j) , Ixy(i,j); Ixy(i,j), Iy2(i,j)];
        M = Wxy*patch;
        R = det(double(M)) - k * (trace(M) ^ 2);
        R = -R;
        if (R > thres)
          outputHarris(i, j) = R; 
        end
    end
end

flag = 0;
while (1)
for i = 2 : rows - 1
    for j = 2 : cols - 1
        flag = 0;
        val = outputHarris(i,j);
        if( val > outputHarris(i-1,j-1) && val > outputHarris(i-1,j) && val > outputHarris(i-1,j+1) && val > outputHarris(i,j+1) && val > outputHarris(i+1,j+1) && val > outputHarris(i+1,j) && val > outputHarris(i+1,j-1) && val > outputHarris(i,j-1))
            outputHarris(i,j) = val;
            flag = 1;
        else
            outputHarris(i,j) = 0;
        end
    end
end
if flag == 0
    break
end
end

outputHarris = uint8(outputHarris);
imshow(outputHarris);

end


function [ hysImage ] = Hysterisys( inputImage, threshold )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[rows, cols] = size(inputImage);
gradient = inputImage;
upperThreshhold = threshold(2);
lowerThreshold = threshold(1);

%removing lower than lower threshold and keeping higher than upper threshold
for r = 2 : rows - 1
    for c = 2 : cols - 1
        if (gradient(r,c)  > upperThreshhold)
            gradient(r,c) = 255;
        elseif (gradient(r,c) < lowerThreshold)
            gradient(r,c) = 0;
        end
    end
end

%for middle range compare the neighboring pixels
flag = 0;
while(1)
    flag = 0;
for r = 2 : rows - 1
    for c = 2 : cols - 1
        if (gradient(r,c)  <= upperThreshhold && gradient(r,c) >= lowerThreshold)
            if( gradient(r-1,c-1) == 255 || gradient(r-1,c) == 255 || gradient(r-1,c+1) == 255 || gradient(r,c +1) == 255  || gradient(r+1,c+1) == 255 || gradient(r+1,c) == 255 || gradient(r+1,c-1) == 255 || gradient(r,c-1) == 255)  
                gradient(r,c) = 255;
                flag = 1;
            end
        end
    end
end
if(flag == 0)
    break;
end
end

for r = 2 : rows - 1
    for c = 2 : cols - 1
        if (gradient(r,c)  <= upperThreshhold && gradient(r,c) >= lowerThreshold)
            gradient(r,c) = 0;
        end
    end
end


hysImage = gradient;



end


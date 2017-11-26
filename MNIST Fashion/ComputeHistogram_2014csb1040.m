function [  ] = ComputeHistogram_2014csb1040( image, C)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


tempHarris = detectHarrisFeatures(image);

[features,validPoints] = extractHOGFeatures(image,tempHarris, 'CellSize',[3 3]);

numMeans = 250;
[r c] = size(features);

tempVar  = 1;
tempFeature = zeros(1,36);

[rc cc] = size(C);

distanceOf = zeros(r, rc);

for i = 1 : r
   tempFeature = features(i,:);
   minDis = norm(tempFeature - C(1,:));
   for j = 1 : rc
       tempDis = norm(tempFeature - C(j,:));
       distanceOf(i,j) = tempDis; 
   end
   
end

plot(distanceOf);

end


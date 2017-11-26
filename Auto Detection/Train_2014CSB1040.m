function [res] = Train_2014CSB1040( path )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



%Loading Images
%**************************************************************************
% path = 'E:\Academics\7th Semester\Computer Vision\Lab 4\auto_det_chal_train_7oct\';
imageFiles = dir(strcat(path, 'images\*.jpg'));
numFiles = length(imageFiles);

numTrain = 600;
numTest = 200;

countTrain = 1;
countTest = 1;
for i = 1 : numFiles
    name = imageFiles(i).name;
    tempImage = imread(strcat(path,'images\', num2str(i - 1),'.jpg'));
    if i <= numTrain 
        trainImages{countTrain} = tempImage;
        countTrain = countTrain + 1;
    else
        testImages{countTest} = tempImage;
        countTest= countTest+ 1;
    end
end
%**************************************************************************

%Loading the bounding boxes from json file
%**************************************************************************

fname = strcat(path,'bbs\bbs.json');
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
boxes = JSON.parse(str);

totalImages = size(boxes(1,:));
totalImages = totalImages(1,2);
boxesEachImage = zeros(1,1);
boundingBoxes = zeros(1,4);
tempBBox = zeros(1,4);

for i = 1 : totalImages
    tempSize = size(boxes{1,i});
    temp = tempSize(1,2);
    boxesEachImage = [boxesEachImage ; temp];
    for j = 1 : temp
        minX = 9999;
        minY = 9999;
        maxX = 0;
        maxY = 0;
        for k = 1 : 4
            x = boxes{1,i}{1,j}{1,k}{1,1};
            y = boxes{1,i}{1,j}{1,k}{1,2};
            if x <= minX
                minX = x;
            end
            if x >= maxX
                maxX = x;
            end
            
            if y <= minY
                minY = y;
            end
            if y >= maxY
                maxY = y;
            end
        end
        tempBBox(1,1) = minX;
        tempBBox(1,2) = minY;
        tempBBox(1,3) = maxX - minX;
        tempBBox(1,4) = maxY - minY;
        boundingBoxes = [boundingBoxes ; tempBBox];
    end
end

[r c] = size(boundingBoxes);
boundingBoxes = boundingBoxes(2:r , :);

[r c] = size(boxesEachImage);
boxesEachImage = boxesEachImage(2:r , :);
%**************************************************************************



%Cropping the images and extracting features
%**************************************************************************
value = 121;
trainingFeatures = zeros(1,value);
labelVector = zeros(1,2);
count = 0;
numPositive = 0;
numNegative = 0;

for i = 1 : numTrain
    I = rgb2gray(trainImages{1,i});
    points = detectSURFFeatures(I);
    [tempFeatures validPoints] = extractFeatures(I, points.selectStrongest(200), 'Method','Block', 'BlockSize',11);
%     validPoints = validPoints.Location;
    [m n] = size(validPoints);
    for j = 1 : m
        x = validPoints(j,1);
        y = validPoints(j,2);
        trainingFeatures = [trainingFeatures ; tempFeatures(j,:)];
        for k = 1 : boxesEachImage(i,1)
            minX =  boundingBoxes(count + k,1);
            minY =  boundingBoxes(count + k,2);
            maxX =  boundingBoxes(count + k,1) + boundingBoxes(count + k,3);
            maxY =  boundingBoxes(count + k,2) + boundingBoxes(count + k,4);
            flag = 0;
            
            if x >= minX && x <= maxX && y >= minY && y <= maxY
                flag = 1;
                break;
            end
            
        end
        if flag == 1
            numPositive = numPositive + 1;
            tempLabel = zeros(1,2);
            tempLabel(1,1) = 1;
            tempLabel(1,2) = 0;
            labelVector = [labelVector ; tempLabel];
        else
            numNegative = numNegative + 1;
            tempLabel = zeros(1,2);
            tempLabel(1,1) = 0;
            tempLabel(1,2) = 1;
            labelVector = [labelVector ; tempLabel];
        end
        
    end
    fprintf('Current training image: %d\n',i);
    count = count + boxesEachImage(i,1);
end

[r c] = size(trainingFeatures);
trainingFeatures = trainingFeatures(2:r , :);
trainingFeatures = double(trainingFeatures);


[r c] = size(labelVector);
labelVector = labelVector(2:r , :);

%**************************************************************************

%Training the model
%**************************************************************************


x = trainingFeatures';
t = labelVector';
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% Create a Fitting Network
hiddenLayerSize = 60;
myNet = fitnet(hiddenLayerSize,trainFcn);

% Setup Division of Data for Training, Validation, Testing
myNet.divideParam.trainRatio = 80/100;
myNet.divideParam.valRatio = 10/100;
myNet.divideParam.testRatio = 10/100;

% Train the Network
[res,tr] = train(myNet,x,t);

% View the Network
view(myNet);

%**************************************************************************
end


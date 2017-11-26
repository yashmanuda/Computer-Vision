function [idx C sumd D] = CreateDictionary_2014csb1040( inputPath )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%example input path
%inputPath = 'E:\Academics\7th Semester\Computer Vision\Lab 3\';

%loading CSV files and reading it
fileTrain = strcat(inputPath, 'fashion-mnist_train.csv');
fileTest = strcat(inputPath, 'fashion-mnist_test.csv');

trainFiles = csvread(fileTrain,1,0);
testFiles = csvread(fileTest,1,0);

%size of training and test data

[trR, trC] = size(trainFiles);
[teR, teC]= size(testFiles);

%test and training labels
labelTrain = trainFiles(:,1);
labelTest = testFiles(:,1);

save(strcat(inputPath, 'labelTrain.mat'),'labelTrain');
save(strcat(inputPath, 'labelTest.mat'),'labelTest');
fprintf('Saved labels.\n');

trainFiles = trainFiles(:,2:trC);
testFiles = testFiles(:,2:teC);

%number of features in the images, size of the square sized image
numFeature = sqrt(trC - 1);

%storing training and testing images
trainImages = zeros(trR, numFeature, numFeature);
trainImages = uint8(trainImages);

testImages = zeros(teR, numFeature, numFeature);
testImages = uint8(testImages);

%training images 
temp  = 1;
for k = 1 : trR
    temp = 1;
    for i = 1 : numFeature
        for j = 1 : numFeature
            trainImages(k,i,j) = trainFiles(k,temp);
            temp = temp + 1;
        end
    end
end

fprintf('Loading training images done.\n');
%test images
temp  = 1;
for k = 1 : teR
    temp = 1;
    for i = 1 : numFeature
        for j = 1 : numFeature
            testImages(k,i,j) = testFiles(k,temp);
            temp = temp + 1;
        end
    end
end
fprintf('Loading test images done.\n');


%Harris Point detection for training images and calculating HOG features
%HOG features with 3x3 mask has 36 feature vector size
trainFeatures = zeros(1,36);
trainVector = zeros(1,1);

for i = 1 : trR
    tempImage = trainImages(i,:,:);
    tempImage = squeeze(tempImage);
    tempHarris = detectHarrisFeatures(tempImage);
    [features,validPoints] = extractHOGFeatures(tempImage,tempHarris, 'CellSize',[3 3]);
    [r c] = size(features);
    trainVector = [trainVector ; r];
    trainFeatures = [trainFeatures ; features];
end


[r c] = size(trainFeatures);
trainFeatures = trainFeatures(2:r,:);

[r c] = size(trainVector);
trainVector = trainVector(2:r,:);

fprintf('Harris point detection and HOG features complete for training.\n');

%Harris Point detection for testing images and calculating HOG features
testFeatures = zeros(1,36);
testVector = zeros(1,1);

for i = 1 : teR
    tempImage = testImages(i,:,:);
    tempImage = squeeze(tempImage);
    tempHarris = detectHarrisFeatures(tempImage);
    [features,validPoints] = extractHOGFeatures(tempImage,tempHarris, 'CellSize',[3 3]);
    [r c] = size(features);
    testVector = [testVector ; r];
    testFeatures = [testFeatures ; features];
end

[r c] = size(testFeatures);
testFeatures = testFeatures(2:r,:);

[r c] = size(testVector);
testVector = testVector(2:r,:);

fprintf('Harris point detection and HOG features complete for test.\n');

%saving training and testing features
save(strcat(inputPath, 'trainFeatures.mat'),'trainFeatures');
save(strcat(inputPath, 'testFeatures.mat'),'testFeatures');
save(strcat(inputPath, 'trainVector.mat'),'trainVector');
save(strcat(inputPath, 'testVector.mat'),'testVector');

fprintf('All feature saved.\n');


%lodaing training features matrix
load(strcat(inputPath, 'trainFeatures.mat'));
%storing output of kmeans
path = strcat(inputPath, 'kmeans\');

%for convenience the value has been set to 250 which is used for kmeans
%you can change the for loop conditions from any value to any value
%it will store the values of all kmeans folder wise
%to calculate the graph of different values of kmeans you will run this
%     for k = 250 : 2 : 250
%         [idx,C,sumd,D] = kmeans(trainFeatures, k, 'MaxIter', 1000); 
%         totalPath = strcat(path,int2str(k));
%         mkdir(totalPath);
%         totalPath = strcat(totalPath, '\');
%         save(strcat(totalPath, 'idx.mat'),'idx');
%         save(strcat(totalPath, 'C.mat'),'C');
%         save(strcat(totalPath, 'sumd.mat'),'sumd');
%         save(strcat(totalPath, 'D.mat'),'D');
%     end


[idx,C,sumd,D] = kmeans(trainFeatures, 250, 'MaxIter', 1000); 
totalPath = strcat(path,int2str(250));
mkdir(totalPath);
totalPath = strcat(totalPath, '\');
save(strcat(totalPath, 'idx.mat'),'idx');
save(strcat(totalPath, 'C.mat'),'C');
save(strcat(totalPath, 'sumd.mat'),'sumd');
save(strcat(totalPath, 'D.mat'),'D');

fprintf('K-means complete and files saved.\n');

end


function [ accuracy confusion] = RunAll_2014csb1040( inputPath )


%example input path
% inputPath = 'E:\Academics\7th Semester\Computer Vision\Lab 3\';

[idx C sumd D] = CreateDictionary_2014csb1040( inputPath );

load( strcat(inputPath , 'testFeatures.mat'));
load( strcat(inputPath , 'trainFeatures.mat'));
load( strcat(inputPath , 'trainVector.mat'));
load( strcat(inputPath , 'testVector.mat'));
load( strcat(inputPath , 'labelTrain.mat'));
load( strcat(inputPath , 'labelTest.mat'));

numMeans = 250;

load( strcat(inputPath , 'kmeans\250\D.mat'));
load( strcat(inputPath , 'kmeans\250\C.mat'));

%training images matrix for comparison, histogram of every training image
tempVar  = 1;
trainInverseSums = zeros(1,numMeans);

trR = 60000;
teR = 10000;

for i = 1 : trR
    tempInverseSum = zeros(1,numMeans);
    for j = 1 : trainVector(i,1)
        for m = 1 : numMeans
            D(tempVar,m) = 1/D(tempVar,m);
        end
        tempInverseSum = tempInverseSum + D(tempVar,:);
        tempVar = tempVar + 1;
    end
    fprintf('Done training image matrix finding %d\n', i);
    trainInverseSums = [trainInverseSums ; tempInverseSum];
    clear tempInverseSum;
end

trainInverseSums = trainInverseSums(2:trR + 1, :);


%test images matrix for comparison, histogram of every test image

testInverseSums = zeros(1,numMeans);
tempVar = 1;
for i = 1 : teR
    tempInverseSum = zeros(1,numMeans);
    for j = 1 : testVector(i,1)
        tempInverseIndi = zeros(1,numMeans);
        for m = 1 : numMeans
            tempNorm = C(m,:) - testFeatures(tempVar,:);
            tempNorm = tempNorm * tempNorm';
            tempNorm = 1/tempNorm;
            tempInverseIndi(1,m) = tempNorm;
        end
        tempInverseSum = tempInverseSum + tempInverseIndi;
        tempVar = tempVar + 1;
    end
    testInverseSums = [testInverseSums ; tempInverseSum];
    fprintf('Done test image matrix finding %d\n', i);
end

testInverseSums = testInverseSums(2:teR + 1, :);



%Calculation of accuracy

countCorrect = 0;
totalTest = teR;
confusion = zeros(10);

for i = 1 : totalTest
    min = 1;
    minSum = norm(trainInverseSums(1,:) - testInverseSums(i,:));
    for j = 1 : trR 
        tempMinSum = norm(trainInverseSums(j,:) - testInverseSums(i,:));
        if tempMinSum < minSum
            min = j;
            minSum = tempMinSum;
        end
    end
    rt  = labelTrain(min) + 1;
    ct = labelTest(i,1) + 1;
    confusion(rt, ct) = confusion(rt, ct)+ 1;
    if labelTrain(min) == labelTest(i,1)
        countCorrect = countCorrect + 1;
    end
    fprintf('Done %d Correct %d\n',i, countCorrect);
end

accuracy = countCorrect*100.0/totalTest;
confusion = confusion';


end


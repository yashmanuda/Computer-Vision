function [ ] = Test_2014CSB1040( path, res  )

%Loading Images
%**************************************************************************
%path = 'E:\Academics\7th Semester\Computer Vision\Lab 4\auto_det_chal_train_7oct\';
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
testingFeatures = zeros(1,value);
testLabelVector = zeros(1,2);
numFeaturesEachImage = zeros(1,1);
allValidPoints = zeros(1,2);
count = 0;


for i = 1 : numTrain
    count = count + boxesEachImage(i,1);
end

for i = 1 : numTest
   I = rgb2gray(trainImages{1,i});
    points = detectSURFFeatures(I);
    [tempFeatures validPoints] = extractFeatures(I, points.selectStrongest(200), 'Method','Block', 'BlockSize',11);
%     validPoints = validPoints.Location;
    [m n] = size(validPoints);
    allValidPoints = [allValidPoints ; validPoints];
    numFeaturesEachImage = [numFeaturesEachImage ; m];
    for j = 1 : m
        x = validPoints(j,1);
        y = validPoints(j,2);
        testingFeatures = [testingFeatures; tempFeatures(j,:)];
        for k = 1 : boxesEachImage(numTrain + i,1)
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
            tempLabel = zeros(1,2);
            tempLabel(1,1) = 1;
            tempLabel(1,2) = 0;
            testLabelVector = [testLabelVector ; tempLabel];
        else
            tempLabel = zeros(1,2);
            tempLabel(1,1) = 0;
            tempLabel(1,2) = 1;
            testLabelVector = [testLabelVector ; tempLabel];
        end
        
    end
    fprintf('Current test image: %d\n',i);
    count = count + boxesEachImage(numTrain + i,1);
end

[r c] = size(testingFeatures);
testingFeatures = testingFeatures(2:r , :);
testingFeatures = double(testingFeatures);

[r c] = size(numFeaturesEachImage);
numFeaturesEachImage = numFeaturesEachImage(2:r , :);

[r c] = size(allValidPoints);
allValidPoints = allValidPoints(2:r,:);

[r c] = size(testLabelVector);
testLabelVector = testLabelVector(2:r , :);

%**************************************************************************

% 
total = size(testLabelVector);
total = total(1,1);
correct = 0;
for i = 1 : total
    prediction = res(testingFeatures(i,:)');
    
    if prediction(1,1) > prediction(2,1)
        tr = 1;
    else
        tr = 0;
    end
    
    if testLabelVector(i,1) == 1
        actualLabel = 1;
    else
        actualLabel = 0;
    end
    
    if tr == actualLabel
        correct = correct + 1;
    end
    fprintf('Current %d , correct %d\n',i,correct);
end

accuracy = correct*100.0/total;
fprintf('Accuracy is %d\n',accuracy);

%Showing the images
%**************************************************************************

mkdir(strcat(path,'results'));
for b = 1 : numTest
    toShow = b;
    count = 0;
    bx = zeros(1,1);
    by = zeros(1,1);

    for i = 1 : toShow - 1
        count = count + numFeaturesEachImage(i,1);
    end

    countB = 0;
    for k = 1 : numTrain + toShow - 1
       countB = countB + boxesEachImage(k,1);
    end

    fprintf('%d',count);
    testSample = testImages(1,toShow);
    testSample = testSample{1,1};
    figure;
    imshow(testSample);
    hold on;
    for j = 1 : boxesEachImage(numTrain + toShow, 1)
        rectangle('Position', boundingBoxes(countB + j,:), 'EdgeColor','r', 'LineWidth', 3);
    end


    for j = 1 : numFeaturesEachImage(toShow)
        x = allValidPoints(count + j , 1);
        y = allValidPoints(count + j , 2);

        prediction = res(testingFeatures(count + j,:)');

        if prediction(1 , 1) > prediction(2, 1)
            bx = [bx;x];
            by = [by;y];
            plot(x, y, 'r*' ,'Color','green', 'LineWidth', 1, 'MarkerSize', 10);
        else
            plot(x, y, 'r*','Color','red', 'LineWidth', 1, 'MarkerSize', 10);
        end
    end
    [r c] = size(bx);
    bx = bx(2:r,:);
    [r c] = size(by);
    by = by(2:r,:);
    bx=double(bx);
    by=double(by);
    
    vc = boundary(bx,by);
    plot(bx(vc),by(vc),'r-','Color','yellow', 'LineWidth',1,'MarkerSize', 10);
    h = getframe;
    im = h.cdata;
    close all;
    imwrite(im,strcat(path,'results\',num2str(numTrain - 1 + b),'.jpg'));
end

%**************************************************************************
end
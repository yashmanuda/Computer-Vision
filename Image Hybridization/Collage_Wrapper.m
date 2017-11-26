function [ collage ] = Collage_Wrapper( path )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
file_list = [dir(fullfile(path,'/*.jpg')); dir(fullfile(path,'/*.bmp') ); dir(fullfile(path,'/*.png') ) ];
full_name = fullfile(path, {file_list(:).name});
num_files = length(file_list);
all_images = zeros(500,500,3,num_files);
all_images = uint8(all_images);

for i = 1 : num_files
    temp = imread(char(full_name(i)));
    temp = imresize(temp,  [500,500]);
    all_images(:,:,:,i) = temp;
end

if num_files==2
    %horizaontal
    collage = CreateHybridImage( all_images(:,:,:,1), [451 1 500 500], all_images(:,:,:,2), [1 1 50 500]);
else
    collage = CreateHybridImage( all_images(:,:,:,1), [451 1 500 500], all_images(:,:,:,2), [1 1 50 500]);
    flag = 1;
    xrand = random('Normal',0,1,1,num_files - 2);
    for m = 3 : num_files
        if xrand(m - 2) > 0
            flag = 0;
            collage = CreateHybridImage(collage , [1 451 500 500], all_images(:,:,:,m), [1 1 500 50]);
        else
            flag = 1;
            collage = CreateHybridImage(all_images(:,:,:,m) , [451 1 500 500], collage, [1 1 50 500]);
        end
    end
end
end
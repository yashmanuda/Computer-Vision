function [ H ] = ComputeHomography_2014csb1040( imageOne, imageTwo )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

figure 
imshow(imageOne)
[xa, ya] = getpts

figure 
imshow(imageTwo)
[xb, yb] = getpts

x11 = xa(1,1);
x12 = xa(2,1);
x13 = xa(3,1);
x14 = xa(4,1);

y11 = ya(1,1);
y12 = ya(2,1);
y13 = ya(3,1);
y14 = ya(4,1);


x21 = xb(1,1);
x22 = xb(2,1);
x23 = xb(3,1);
x24 = xb(4,1);

y21 = yb(1,1);
y22 = yb(2,1);
y23 = yb(3,1);
y24 = yb(4,1);

r1 = [-x11 -y11 -1 0 0 0 x11*x21 y11*x21 x21];
r2 = [0 0 0 -x11 -y11 -1 x11*y21 y11*y21 y21];
r3 = [-x12 -y12 -1 0 0 0 x12*x22 y12*x22 x22];
r4 = [0 0 0 -x12 -y12 -1 x12*y22 y12*y22 y22];
r5 = [-x13 -y13 -1 0 0 0 x13*x23 y13*x23 x23];
r6 = [0 0 0 -x13 -y13 -1 x13*y23 y13*y23 y23];
r7 = [-x14 -y14 -1 0 0 0 x14*x24 y14*x24 x24];
r8 = [0 0 0 -x14 -y14 -1 x14*y24 y14*y24 y24];

matrix = [r1;r2;r3;r4;r5;r6;r7;r8];
[U,S,V] = svd(matrix);

[r c] = size(V);

cv = V(:,c);

hr1 = [cv(1,1) cv(2,1) cv(3,1)];
hr2 = [cv(4,1) cv(5,1) cv(6,1)];
hr3 = [cv(7,1) cv(8,1) cv(9,1)];

H = [hr1;hr2;hr3];
tform = projective2d(H);
R = imref2d(size(imageOne));
[B,RB] = imwarp(imageOne,R,tform);
imshow(B);



end


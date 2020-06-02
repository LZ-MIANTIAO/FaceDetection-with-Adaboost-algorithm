clc;
clear;
close all;
img = imread('..\BiShe_Matlab\newtest_img\7.jpg');
img1 = imread('..\BiShe_Matlab\newtest_img\42.jpg');
[output, Detection_time, ~] = FaceDetection(img);
[output1, Detection_time1, ~] = FaceDetection(img1);
figure;
subplot(1,2,1);
imshow(output);
subplot(1,2,2);
imshow(output1);
Detection_time
% Detection_time1



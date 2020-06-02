clc,clear,close all;
% vid = videoinput('winvideo', 1, 'YUY2_640x480');
% set(vid,'ReturnedColorSpace','grayscale');
% vidRes=get(vid,'VideoResolution'); % 得到视频分辨率 640*480
% width=vidRes(1);  % 640
% height=vidRes(2); % 480
% nBands=get(vid,'NumberOfBands');% 色彩数目
% hImage=image(zeros(vidRes(2),vidRes(1),nBands));
% preview(vid);
% % 
vid = videoinput('winvideo',1 ,'YUY2_640x480');
% preview(vid);
% h2=figure; %新建显示图像figure,同时获取句柄
triggerconfig(vid,'manual'); % 设置触发为人为模式
start(vid); % 触发要求
tic;
try
    while i<20
        frame = getsnapshot(vid); % 捕获图像
        frame = ycbcr2rgb(frame); % 色彩空间转换为彩色图
        %frame=rgb2gray(frame);
        %tt=graythresh(frame);
        %image1=im2bw(frame);
        imshow(frame);  % 显示图像
        drawnow;        % 实时更新图像
        i=i+1;
    end
catch
    warning('runing has error');
    delete(vid); 
end
delete(vid); 
toc;



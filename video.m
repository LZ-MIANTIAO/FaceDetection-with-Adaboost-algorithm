clc,clear,close all;
% vid = videoinput('winvideo', 1, 'YUY2_640x480');
% set(vid,'ReturnedColorSpace','grayscale');
% vidRes=get(vid,'VideoResolution'); % �õ���Ƶ�ֱ��� 640*480
% width=vidRes(1);  % 640
% height=vidRes(2); % 480
% nBands=get(vid,'NumberOfBands');% ɫ����Ŀ
% hImage=image(zeros(vidRes(2),vidRes(1),nBands));
% preview(vid);
% % 
vid = videoinput('winvideo',1 ,'YUY2_640x480');
% preview(vid);
% h2=figure; %�½���ʾͼ��figure,ͬʱ��ȡ���
triggerconfig(vid,'manual'); % ���ô���Ϊ��Ϊģʽ
start(vid); % ����Ҫ��
tic;
try
    while i<20
        frame = getsnapshot(vid); % ����ͼ��
        frame = ycbcr2rgb(frame); % ɫ�ʿռ�ת��Ϊ��ɫͼ
        %frame=rgb2gray(frame);
        %tt=graythresh(frame);
        %image1=im2bw(frame);
        imshow(frame);  % ��ʾͼ��
        drawnow;        % ʵʱ����ͼ��
        i=i+1;
    end
catch
    warning('runing has error');
    delete(vid); 
end
delete(vid); 
toc;



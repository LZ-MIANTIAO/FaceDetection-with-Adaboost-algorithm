clc,clear,close all;
global value flag;
value = 2;
flag = 0;
imgdata = imread('..\BiShe_Matlab\newtest_img\28.jpg');
figure;
% subplot(3,3,1),imshow(imgdata);title('ԭͼ');
tic;
fy = rgb2ycbcr(imgdata);
cr = fy(:,:,3);
cb = fy(:,:,2);
bw = (cb>=80)&(cb<=130)&(cr>=135)&(cr<=170);
% cr(cr<135|cr>170) = 0;
% cr(cr~=0) = 255;
% bw = imbinarize(cr);
% subplot(3,3,2),imshow(bw);title('��ֵ��');
bw = medfilt2(bw);
% subplot(3,3,3),imshow(bw);title('��ֵ�˲�');
bw = imerode(bw,strel('square',1));
% subplot(3,3,4),imshow(bw);title('��ʴ');
bw = imdilate(bw,strel('square',1));
% subplot(3,3,5),imshow(bw);title('����');
bw = imfill(bw,'holes'); % ��ֵͼ���еĿն�����
% subplot(3,3,6),imshow(bw);title('���');
bwao = bwareaopen(bw,500);
% subplot(3,3,7),imshow(bwao);title('�и�');
[L,n] = bwlabel(bwao); % L�Ǻ�ͼƬ�����ش�С��ͬ��double�;���
img = imgdata;
for i=1:n
    [r,c] = find(L==i);% ����L�е���i��Ԫ��λ��
    result = img(min(r):max(r),min(c):max(c),:);
    x = min(r);
    y = min(c);
%     wide = max(r)-min(r)+1;
%     hight = max(c)-min(c)+1;
    [imgoutput, ~, ~] = FaceDetection(result);
%     img(x:x+wide-1,y:y+hight-1,:) = imgdata(x:x+wide-1,y:y+hight-1,:);
    for k = 1:size(result,1)
        for j = 1:size(result,2)
            img(x+k-1,y+j-1,:) = imgoutput(k,j,:);     
        end
    end
end
toc;
% subplot(3,3,8),imshow(img);title('���');
imshow(img);title('���');


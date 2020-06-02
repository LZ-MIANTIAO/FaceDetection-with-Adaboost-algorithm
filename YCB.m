function [old_img, Detection_time, face_num] = YCB(imgdata)
tic;
fy = rgb2ycbcr(imgdata);
cr = fy(:,:,3);
cb = fy(:,:,2);
bw = (cb>=80)&(cb<=130)&(cr>=135)&(cr<=170);

bw = medfilt2(bw);
bw = imerode(bw,strel('square',1));
bw = imdilate(bw,strel('square',1));
bw = imfill(bw,'holes'); % 二值图像中的空洞区域
bwao = bwareaopen(bw,500);
[L,n] = bwlabel(bwao); % L是和图片的像素大小相同的double型矩阵
img = imgdata;
temp = 0;
for i=1:n
    [r,c] = find(L==i);% 返回L中等于i的元素位置
    result = img(min(r):max(r),min(c):max(c),:);
    x = min(r);
    y = min(c);
    [imgoutput, ~,face_num1] = FaceDetection(result);
    for k = 1:size(result,1)
        for j = 1:size(result,2)
            img(x+k-1,y+j-1,:) = imgoutput(k,j,:);     
        end
    end
    temp = temp + face_num1;
end
time = num2str(toc);
old_img = img;
Detection_time = ['检测结束，耗时：',time, '秒'];
face_num = temp;
end
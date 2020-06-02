%计算积分图
function [im, ii_im] = CalcIntegralImage(im)        

if size(im,3)>1         %维数大于1说明是彩色图像，需要转化成灰度图像
    im = rgb2gray(im);%将rgb的三维矩阵变换为灰度矩阵
end
im = double(im);
imv = im(:);        %把im矩阵赋值给imv矩阵  %把矩阵的元素按列的顺序变为一列
s = std(imv);       %求出imv矩阵各列的标准偏差 %求出imv的标准偏差
if(s==0)
    s=1;
end
im = (im-mean(imv))/s;      %为什么要进行这一步的处理？？？？看不懂
ii_im = cumsum(cumsum(im),2);       %计算矩阵im的积分图，存储于返回矩阵ii_m中（注意，这一步还有更简单的快速算法，可以改进）
%如果A是一个矩阵， cumsum(A) 返回一个和A同行同列的矩阵，矩阵中第m行第n列元素是A中第1行到第m行的所有第n列元素的累加和
%cumsum(A,2)返回的是沿着第二维（各行）的累加和   打开"cumsum"

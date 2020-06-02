%利用积分图
%计算某个区域box的像素值的和

function A = ComputeBoxSum(ii_im, x, y, w, h)

A = ii_im(y+h-1, x+w-1);

if x>1
    A = A - ii_im(y+h-1, x-1);
end

if y>1
    A = A - ii_im(y-1, x+w-1);
end

if x>1 && y>1
    A = A + ii_im(y-1, x-1);
end

%A = ii_im(y-1, x-1) + ii_im(y+h-1, x+w-1) - ii_im(y+h-1, x-1) - ii_im(y-1, x+w-1);

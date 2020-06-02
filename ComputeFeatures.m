%计算样本的矩形特征
function features = ComputeFeatures(data, all_ftypes)
disp('开始计算样本的矩形特征')
W = size(data,2);       %得到数据的列数，即宽度 
H = size(data,1);       %得到数据的行数，即高度
ni = size(data,3);      %得到数据的维数

ii_ims = zeros(ni, W*H);        %创建一个和原数据规模一样的矩阵

for i=1:ni
    [im, ii_im] = CalcIntegralImage(data(:,:,i));       %计算data矩阵的积分图，存储在返回矩阵ii_im中
    ii_ims(i,:) = ii_im(:)';        %把ii_im(二维积分图矩阵)转换成行向量，赋给ii_ims,
    if mod(i,50) == 0
        fprintf('已经计算积分图%d\n',i)
    end
end

fmat = VecAllFeatures(all_ftypes, W, H);
fs = ii_ims * fmat;         %fs是每种矩形特征的特征值

%matlab 可以直接创键结构体，不需要事先申明
features.fs = fs;           %features是一个结构体，其中包含两个元素，一个是特征值矩阵（2维），一个是图像的积分图
features.ii_ims = ii_ims;

end

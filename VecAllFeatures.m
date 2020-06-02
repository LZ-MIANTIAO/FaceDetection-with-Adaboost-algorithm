function fmat = VecAllFeatures(all_ftypes, W, H)

nf = size(all_ftypes, 1);       %nf存储了矩形特征的个数  size(X,1),返回矩阵X的行数；
fmat = sparse(W*H, nf);         %创建一个W*H行，nf列的零矩阵 sparse 创建稀疏矩阵

for i=1:nf          %  计算每种矩形特征在各个像素点的值            
    fmat(:,i) = VecFeature(all_ftypes(i,:), W, H);
    if mod(i,100) == 0
        fprintf('计算每种矩形特征在各个像素点的值进度%d\n',i);
    end
end
fprintf('计算每种矩形特征在各个像素点结束%d\n',i);
end

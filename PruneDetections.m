function fdets = PruneDetections(dets)

nd = size(dets, 1);

D = sparse(nd, nd);  % 产生稀疏矩阵，稀疏距阵就是零元素个数远多于非零元素个数的距阵

area = rectint(dets, dets); % 返回由位置向量A和B指定的矩形的相交区域。
D(area>0) = 1;

[S, C] = graphconncomp(D);

fdets = zeros(S, 4);
m = zeros(S, 1);

for i=1:nd
    fdets(C(i),:) = fdets(C(i),:) + dets(i,:);
    m(C(i)) = m(C(i))+1;
end
fdets = int32(fdets./(m*ones(1,4)));

function f = VecBoxSum(x, y, w, h, W, H)
%x为横坐标，Y为纵坐标，w为宽，h为高
f = sparse(W*H, 1);%稀疏矩阵

f(y-1+(x-2)*H) = 1;
f(y+h-1+(x+w-2)*H) = 1;
f(y+h-1+(x-2)*H) = -1;
f(y-1+(x+w-2)*H) = -1;

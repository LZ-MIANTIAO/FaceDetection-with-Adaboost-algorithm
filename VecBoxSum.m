function f = VecBoxSum(x, y, w, h, W, H)
%xΪ�����꣬YΪ�����꣬wΪ��hΪ��
f = sparse(W*H, 1);%ϡ�����

f(y-1+(x-2)*H) = 1;
f(y+h-1+(x+w-2)*H) = 1;
f(y+h-1+(x-2)*H) = -1;
f(y-1+(x+w-2)*H) = -1;

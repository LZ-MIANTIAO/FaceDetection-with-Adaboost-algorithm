function fmat = VecAllFeatures(all_ftypes, W, H)

nf = size(all_ftypes, 1);       %nf�洢�˾��������ĸ���  size(X,1),���ؾ���X��������
fmat = sparse(W*H, nf);         %����һ��W*H�У�nf�е������ sparse ����ϡ�����

for i=1:nf          %  ����ÿ�־��������ڸ������ص��ֵ            
    fmat(:,i) = VecFeature(all_ftypes(i,:), W, H);
    if mod(i,100) == 0
        fprintf('����ÿ�־��������ڸ������ص��ֵ����%d\n',i);
    end
end
fprintf('����ÿ�־��������ڸ������ص����%d\n',i);
end

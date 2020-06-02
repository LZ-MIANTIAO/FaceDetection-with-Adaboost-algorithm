%���������ľ�������
function features = ComputeFeatures(data, all_ftypes)
disp('��ʼ���������ľ�������')
W = size(data,2);       %�õ����ݵ������������ 
H = size(data,1);       %�õ����ݵ����������߶�
ni = size(data,3);      %�õ����ݵ�ά��

ii_ims = zeros(ni, W*H);        %����һ����ԭ���ݹ�ģһ���ľ���

for i=1:ni
    [im, ii_im] = CalcIntegralImage(data(:,:,i));       %����data����Ļ���ͼ���洢�ڷ��ؾ���ii_im��
    ii_ims(i,:) = ii_im(:)';        %��ii_im(��ά����ͼ����)ת����������������ii_ims,
    if mod(i,50) == 0
        fprintf('�Ѿ��������ͼ%d\n',i)
    end
end

fmat = VecAllFeatures(all_ftypes, W, H);
fs = ii_ims * fmat;         %fs��ÿ�־�������������ֵ

%matlab ����ֱ�Ӵ����ṹ�壬����Ҫ��������
features.fs = fs;           %features��һ���ṹ�壬���а�������Ԫ�أ�һ��������ֵ����2ά����һ����ͼ��Ļ���ͼ
features.ii_ims = ii_ims;

end

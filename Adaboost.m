%��������������ǿ�������ļ���
function Cparams = Adaboost(PostrainData, NegtrainData, all_ftypes, T)       

W = size(PostrainData,2);
H = size(PostrainData,1);
                                                                    %PositiveFeatures/NegativeFeatures�洢����Ϣ�У���������ÿ��������Ӧ�ľ���
                                                                    %����ֵ������������
disp('��ʼ��������������ľ�������ֵ')
PositiveFeatures = ComputeFeatures(PostrainData, all_ftypes);       %��������������ľ�������ֵ
disp('��ʼ��������������ľ�������ֵ')
NegativeFeatures = ComputeFeatures(NegtrainData, all_ftypes);       %��������������ľ�������ֵ

np = size(PositiveFeatures.fs, 1);      %npΪѵ�������������ĸ�����200��          
nn = size(NegativeFeatures.fs, 1);      %nnΪѵ�������и����ĸ�����400��
nf = size(PositiveFeatures.fs, 2);      %nf�洢��������������������������εĸ�����32746��
%%  ��ʼ������Ȩ��
%ys����������Ӧ�����������1Ϊ��������0λ��������
ys = [ones(np, 1); zeros(nn, 1)];       %ys��һ��np+nn�е���������������np������������1��nn������������0
%wsΪÿ��������Ӧ��Ȩ��
weights = [ones(np, 1)/(2*np); ones(nn, 1)/(2*nn)];      %ws��һ��np+nn�е���������200��0.0025,400��0.0013��
%%
%alphas����ÿ��ѭ��ѵ����������������������ǿ�������еı���
alphas = zeros(T, 1);
Thetas = zeros(T, 3);

for t=1:T              % ѭ��T�Σ�T��ʾǿ�����������������ĸ���
    tic;
    weights = weights / sum(weights);    % Ȩ�ع�һ�� 
    % ����ÿ�����������������ļ�Ȩ������
    fs = [PositiveFeatures.fs(:,1:nf); NegativeFeatures.fs(:,1:nf)]; % ѡȡ�����е����о��������͸��������о�������
    [theta, direction, err] = LearnWeakClassifier(weights, fs, ys);   % p��nf������һ��������ʾ����ʽ�ķ���err��ÿ������������Ӧ�����,theta����÷�����ѵ������������ֵ��ֵ
    
    % �ҵ�err���ֵ��С��ֵ�Ĵ�С��λ�ã�val�洢��Сֵ��j�洢��Сֵ���ڵ���������λ�ã�
    [val, j] = min(err);        
    % ѡ��С�����ʵ�����������Ϊ��t����������
    ErrorRate = err(j);
    beta = ErrorRate/(1-ErrorRate);

    hs = direction(j).*fs(:,j) < direction(j).*theta(j);        %hs�洢���������������
    wsu = (beta.^(1-abs(hs-ys)));  %��������ȷ��ֵΪbeta������Ϊ1
%     wsu = (1-abs(hs-ys));  %��������ȷ��ֵΪ1������Ϊ1
    Thetas(t,:) = [j, theta(j), direction(j)];      %Theats��һ���ṹ�壬�洢��ÿ������������������ֵ�Լ���Ӧ�Ĳ���ʽ����
    alphas(t) = log(1/beta);           % ������t
    % ��һ�ַ��� ѵ���������޷�����
%     for i = 1:length(hs)
%         if hs(i) == ys(i)
%             weights(i) = weights(i)*exp(-alphas(t));
%         else
%             weights(i) = weights(i)*exp(alphas(t));
%         end
%     end
    %����Ȩ��
    weights = weights .* wsu;         %ws��һ��Ȩ�صĸ��»��ƣ�����һ�ε�LearnWeakClassifier������׼ȷ��ִ��������
                             %������ȷ������beta;������󣬲���; ����betaС��1�������൱�ڼӴ��д������ı�ֵ��
    fprintf('��%d����������ѵ������,��ʱ%.2f��\n', t, toc);
    fprintf('alphas(%d) = %f\n',t,alphas(t));
    fprintf('theta(%d) = %f\n',t,Thetas(t,2));
    fprintf('ErrorRate(%d) = %f\n',t,ErrorRate);        
end
%����ѵ�����
Cparams.alphas = alphas;  
Cparams.Thetas = Thetas;   
Cparams.fmat = VecAllFeatures(all_ftypes(Thetas(:,1),:), W, H);
Cparams.all_ftypes = all_ftypes;
Cparams.W = W;
Cparams.H = H;

clear alphas Thetas all_ftypes np nn nf fs weights
end

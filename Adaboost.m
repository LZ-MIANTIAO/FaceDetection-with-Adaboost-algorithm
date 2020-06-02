%进行弱分类器到强分类器的级联
function Cparams = Adaboost(PostrainData, NegtrainData, all_ftypes, T)       

W = size(PostrainData,2);
H = size(PostrainData,1);
                                                                    %PositiveFeatures/NegativeFeatures存储的信息有：样本数、每个样本对应的矩形
                                                                    %特征值，特征矩形数
disp('开始计算出正例样本的矩形特征值')
PositiveFeatures = ComputeFeatures(PostrainData, all_ftypes);       %计算出正例样本的矩形特征值
disp('开始计算出负例样本的矩形特征值')
NegativeFeatures = ComputeFeatures(NegtrainData, all_ftypes);       %计算出负例样本的矩形特征值

np = size(PositiveFeatures.fs, 1);      %np为训练样本中正例的个数（200）          
nn = size(NegativeFeatures.fs, 1);      %nn为训练样本中负例的个数（400）
nf = size(PositiveFeatures.fs, 2);      %nf存储了特征矩阵的列数，即特征矩形的个数（32746）
%%  初始化样本权重
%ys代表样本对应的正负情况（1为正样本，0位负样本）
ys = [ones(np, 1); zeros(nn, 1)];       %ys是一个np+nn行的列向量，其中有np（正列数）个1，nn（负列数）个0
%ws为每个样本对应的权重
weights = [ones(np, 1)/(2*np); ones(nn, 1)/(2*nn)];      %ws是一个np+nn行的列向量（200个0.0025,400个0.0013）
%%
%alphas代表每轮循环训练出来的弱分类器在最终强分类器中的比重
alphas = zeros(T, 1);
Thetas = zeros(T, 3);

for t=1:T              % 循环T次，T表示强分类器中弱分类器的个数
    tic;
    weights = weights / sum(weights);    % 权重归一化 
    % 计算每个特征的弱分类器的加权错误率
    fs = [PositiveFeatures.fs(:,1:nf); NegativeFeatures.fs(:,1:nf)]; % 选取正例中的所有矩形特征和负例中所有矩形特征
    [theta, direction, err] = LearnWeakClassifier(weights, fs, ys);   % p是nf个正负一，用来表示不等式的方向，err是每个弱分类器对应的误差,theta代表该分类器训练出来的特征值阈值
    
    % 找到err误差值最小的值的大小及位置（val存储最小值，j存储最小值所在的列数，即位置）
    [val, j] = min(err);        
    % 选最小错误率的若分来器作为第t个弱分类器
    ErrorRate = err(j);
    beta = ErrorRate/(1-ErrorRate);

    hs = direction(j).*fs(:,j) < direction(j).*theta(j);        %hs存储了弱分类器的输出
    wsu = (beta.^(1-abs(hs-ys)));  %当分类正确，值为beta，否则为1
%     wsu = (1-abs(hs-ys));  %当分类正确，值为1，否则为1
    Thetas(t,:) = [j, theta(j), direction(j)];      %Theats是一个结构体，存储了每个弱分类器的特征阈值以及对应的不等式方向
    alphas(t) = log(1/beta);           % 阿尔法t
    % 另一种方法 训练结束后无法测试
%     for i = 1:length(hs)
%         if hs(i) == ys(i)
%             weights(i) = weights(i)*exp(-alphas(t));
%         else
%             weights(i) = weights(i)*exp(alphas(t));
%         end
%     end
    %调整权重
    weights = weights .* wsu;         %ws是一个权重的更新机制，对下一次的LearnWeakClassifier函数更准确的执行做贡献
                             %分类正确，乘以beta;分类错误，不变; 由于beta小于1，所以相当于加大判错样本的比值。
    fprintf('第%d个弱分类器训练结束,耗时%.2f秒\n', t, toc);
    fprintf('alphas(%d) = %f\n',t,alphas(t));
    fprintf('theta(%d) = %f\n',t,Thetas(t,2));
    fprintf('ErrorRate(%d) = %f\n',t,ErrorRate);        
end
%保存训练结果
Cparams.alphas = alphas;  
Cparams.Thetas = Thetas;   
Cparams.fmat = VecAllFeatures(all_ftypes(Thetas(:,1),:), W, H);
Cparams.all_ftypes = all_ftypes;
Cparams.W = W;
Cparams.H = H;

clear alphas Thetas all_ftypes np nn nf fs weights
end

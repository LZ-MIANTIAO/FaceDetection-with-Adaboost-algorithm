clc,clear,close all;

delete('Cparams.mat','TPR_FPR.mat'); % 每次重新训练时先删除文件

nTrainPosData = 600;
nTrainNegData = 1000;

nTestPosData = 2200;
nTestNegData = 2200;

T = 150;
W = 19;%一幅图像的宽
H = 19;%图像的高

Train_posImageDir = 'G:\毕业设计\BiShe_Matlab\Datasets\Train_FACES\';
Train_negImageDir = 'G:\毕业设计\BiShe_Matlab\Datasets\Train_NFACES\';

Test_posImageDir = 'G:\毕业设计\BiShe_Matlab\Datasets\Test_FACES\';
Test_negImageDir = 'G:\毕业设计\BiShe_Matlab\Datasets\Test_NFACES\';

%negImageDir = '../../adboost face detection/Datasets/NFACES';

pfiles = dir([Train_posImageDir '*.pgm']);
nfiles = dir([Train_negImageDir '*.pgm']);        %以上的操作时打开指定目录下的图像文件

test_pfiles = dir([Test_posImageDir '*.pgm']);
test_nfiles = dir([Test_negImageDir '*.pgm']); 

aa = 1:length(pfiles);
a = randperm(length(aa));% 把1到length(aa)随机打乱得到一个数字序列
trainPosPerm = aa(a(1:nTrainPosData));
aa = 1:length(nfiles);
a = randperm(length(aa)); 
trainNegPerm = aa(a(1:nTrainNegData));          % 以上程序完成了图片的批量打开步骤

aa = 1:length(test_pfiles);
a = randperm(length(aa));% 把1到length(aa)随机打乱得到一个数字序列
testPosPerm = aa(a(1:nTestPosData));
aa = 1:length(test_nfiles);
a = randperm(length(aa)); 
testNegPerm = aa(a(1:nTestNegData));          % 以上程序完成了图片的批量打开步骤


% c = setdiff(A, B) 
% 返回在A中有，而B中没有的值，结果向量将以升序排序返回
% testPosPerm = setdiff(1:length(pfiles), trainPosPerm);  % 在所有图像中取出没有参加训练的图像
% testNegPerm = setdiff(1:length(nfiles), trainNegPerm);

PTrainData = zeros(W, H, nTrainPosData);
NTrainData = zeros(W, H, nTrainNegData);

PTestData = zeros(W, H, nTestPosData);
NTestData = zeros(W, H, nTestNegData);

% read train data
for i=1:size(PTrainData,3)  % 读取200张人脸图片
        PTrainData(:,:,i) = imread([Train_posImageDir pfiles(trainPosPerm(i)).name]); 
%        PTrainData(:,:,i) = imread(pfiles(i).name);
end

%S(:,:,1)表示x、y轴取所有情况，z轴取第一个值时的结果，即为一幅图像
for i=1:size(NTrainData,3)  % 读取400张非人脸图片
    NTrainData(:,:,i) = imread([Train_negImageDir nfiles(trainNegPerm(i)).name]);
end

% read test data 
for i=1:size(PTestData,3)
    PTestData(:,:,i) = imread([Test_posImageDir test_pfiles(testPosPerm(i)).name]);
end
for i=1:size(NTestData,3)
    NTestData(:,:,i) = imread([Test_negImageDir test_nfiles(testNegPerm(i)).name]);
end

% save classifier parameters via train
Cparams = Train(PTrainData, NTrainData, PTestData, NTestData, T);

%save('../data/Cparams.mat', 'Cparams');
save('Cparams.mat', 'Cparams');   

clear Cparams
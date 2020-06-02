clc,clear,close all;

delete('Cparams.mat','TPR_FPR.mat'); % ÿ������ѵ��ʱ��ɾ���ļ�

nTrainPosData = 600;
nTrainNegData = 1000;

nTestPosData = 2200;
nTestNegData = 2200;

T = 150;
W = 19;%һ��ͼ��Ŀ�
H = 19;%ͼ��ĸ�

Train_posImageDir = 'G:\��ҵ���\BiShe_Matlab\Datasets\Train_FACES\';
Train_negImageDir = 'G:\��ҵ���\BiShe_Matlab\Datasets\Train_NFACES\';

Test_posImageDir = 'G:\��ҵ���\BiShe_Matlab\Datasets\Test_FACES\';
Test_negImageDir = 'G:\��ҵ���\BiShe_Matlab\Datasets\Test_NFACES\';

%negImageDir = '../../adboost face detection/Datasets/NFACES';

pfiles = dir([Train_posImageDir '*.pgm']);
nfiles = dir([Train_negImageDir '*.pgm']);        %���ϵĲ���ʱ��ָ��Ŀ¼�µ�ͼ���ļ�

test_pfiles = dir([Test_posImageDir '*.pgm']);
test_nfiles = dir([Test_negImageDir '*.pgm']); 

aa = 1:length(pfiles);
a = randperm(length(aa));% ��1��length(aa)������ҵõ�һ����������
trainPosPerm = aa(a(1:nTrainPosData));
aa = 1:length(nfiles);
a = randperm(length(aa)); 
trainNegPerm = aa(a(1:nTrainNegData));          % ���ϳ��������ͼƬ�������򿪲���

aa = 1:length(test_pfiles);
a = randperm(length(aa));% ��1��length(aa)������ҵõ�һ����������
testPosPerm = aa(a(1:nTestPosData));
aa = 1:length(test_nfiles);
a = randperm(length(aa)); 
testNegPerm = aa(a(1:nTestNegData));          % ���ϳ��������ͼƬ�������򿪲���


% c = setdiff(A, B) 
% ������A���У���B��û�е�ֵ��������������������򷵻�
% testPosPerm = setdiff(1:length(pfiles), trainPosPerm);  % ������ͼ����ȡ��û�вμ�ѵ����ͼ��
% testNegPerm = setdiff(1:length(nfiles), trainNegPerm);

PTrainData = zeros(W, H, nTrainPosData);
NTrainData = zeros(W, H, nTrainNegData);

PTestData = zeros(W, H, nTestPosData);
NTestData = zeros(W, H, nTestNegData);

% read train data
for i=1:size(PTrainData,3)  % ��ȡ200������ͼƬ
        PTrainData(:,:,i) = imread([Train_posImageDir pfiles(trainPosPerm(i)).name]); 
%        PTrainData(:,:,i) = imread(pfiles(i).name);
end

%S(:,:,1)��ʾx��y��ȡ���������z��ȡ��һ��ֵʱ�Ľ������Ϊһ��ͼ��
for i=1:size(NTrainData,3)  % ��ȡ400�ŷ�����ͼƬ
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
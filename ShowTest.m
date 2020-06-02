nTrainPosData = 200;
nTrainNegData = 400;
nLevels = 200;
W = 19;
H = 19; 
PTrainData = zeros(W, H, nTrainPosData);
NTrainData = zeros(W, H, nTrainNegData);
%% read train data
fileFolder = 'C:\Users\dell\Desktop\课程设计\59360732adboost-face-detection\adboost face detection\Datasets\FACES\';
pfiles = dir(fullfile(strcat(fileFolder,'*.pgm')));
fileNames = {pfiles.name}';      %转换成细胞数组

aa = 1:length(pfiles);          %这段程序还没有看懂          
a = randperm(length(aa));
trainPosPerm = aa(a(1:nTrainPosData));

for i=1:size(PTrainData,3)
    PTrainData(:,:,i) =imread(strcat(fileFolder,fileNames{i}));
end
fileFolder = 'C:\Users\dell\Desktop\课程设计\59360732adboost-face-detection\adboost face detection\Datasets\NFACES\';
nfiles = dir(fullfile(strcat(fileFolder,'*.pgm')));
fileNames = {nfiles.name}';      %转换成细胞数组

aa = 1:length(nfiles);          %这段程序还没有看懂 
a = randperm(length(aa)); 
trainNegPerm = aa(a(1:nTrainNegData));

for i=1:size(NTrainData,3)
    NTrainData(:,:,i) =imread(strcat(fileFolder,fileNames{i}));
end
%% read test data
testPosPerm = setdiff(1:length(pfiles), trainPosPerm);
testNegPerm = setdiff(1:length(nfiles), trainNegPerm);

PTestData = zeros(W, H, length(testPosPerm));
NTestData = zeros(W, H, length(testNegPerm));
fileFolder = 'C:\Users\dell\Desktop\课程设计\59360732adboost-face-detection\adboost face detection\Datasets\FACES\';
pfiles = dir(fullfile(strcat(fileFolder,'*.pgm')));
fileNames = {pfiles.name}';      %转换成细胞数组

% for i=1:size(PTestData,3)
for i=1:200
    PTestData(:,:,i) =imread(strcat(fileFolder,fileNames{i}));
end
fileFolder = 'C:\Users\dell\Desktop\课程设计\59360732adboost-face-detection\adboost face detection\Datasets\NFACES\';
nfiles = dir(fullfile(strcat(fileFolder,'*.pgm')));
fileNames = {nfiles.name}';      %转换成细胞数组

% for i=1:size(NTestData,3)
for i=1:400    
   NTestData(:,:,i) =imread(strcat(fileFolder,fileNames{i}));
end
%%
Cparams = Train(PTrainData, NTrainData, PTestData, NTestData, nLevels);

save('C:\Users\dell\Desktop\课程设计\59360732adboost-face-detection\adboost face detection\Cparams.mat', 'Cparams');




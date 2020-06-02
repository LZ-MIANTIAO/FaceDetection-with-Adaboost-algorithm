%训练强分类器以及检测强分类器的性能
function Cparams = Train( PTrainData, NTrainData, PTestData, NTestData, T)         %T默认为10
disp('start train adaboost model')
W = size(PTrainData,2);     %获得正训练样本的列数，即宽度                                     
H = size(PTrainData,1);     %获得正训练样本的行数，即高度

all_ftypes = EnumAllFeatures(W, H);     %得到所有的矩形特征容器

%针对每个特征，循环T轮
Cparams = Adaboost(PTrainData, NTrainData, all_ftypes, T);     %将默认分类器级联成强分类器

Cparams.threshold = ComputeROC(Cparams, PTestData, NTestData);  %这一步是用来检测训练好的分类器的检测性能,threshold应该是能够表征分类器正确率的一个值

end

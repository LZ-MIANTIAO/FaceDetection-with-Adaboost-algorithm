%ѵ��ǿ�������Լ����ǿ������������
function Cparams = Train( PTrainData, NTrainData, PTestData, NTestData, T)         %TĬ��Ϊ10
disp('start train adaboost model')
W = size(PTrainData,2);     %�����ѵ�������������������                                     
H = size(PTrainData,1);     %�����ѵ�����������������߶�

all_ftypes = EnumAllFeatures(W, H);     %�õ����еľ�����������

%���ÿ��������ѭ��T��
Cparams = Adaboost(PTrainData, NTrainData, all_ftypes, T);     %��Ĭ�Ϸ�����������ǿ������

Cparams.threshold = ComputeROC(Cparams, PTestData, NTestData);  %��һ�����������ѵ���õķ������ļ������,thresholdӦ�����ܹ�������������ȷ�ʵ�һ��ֵ

end

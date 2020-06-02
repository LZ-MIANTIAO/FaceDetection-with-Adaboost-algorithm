function thresh = ComputeROC(Cparams, PostestData, NegtestData)

W = size(PostestData,2);
H = size(PostestData,1);

num_face = size(PostestData,3);
num_nface = size(NegtestData,3);

ii_faces = zeros(num_face, W*H);  % 19*19
ii_nfaces = zeros(num_nface, W*H);

for i=1:num_face
    [im, ii_im] = CalcIntegralImage(PostestData(:,:,i));  % ����im�Ļ���ͼ���浽ii_im��
    ii_faces(i,:) = ii_im(:)';
end

for i=1:num_nface
    [im, ii_im] = CalcIntegralImage(NegtestData(:,:,i));
    ii_nfaces(i,:) = ii_im(:)';
end

sc_f = ApplyDetector(Cparams, ii_faces);  % sc_f Ϊ�Ƿ��ж�Ϊ����
sc_nf = ApplyDetector(Cparams, ii_nfaces);% sc_f Ϊ�Ƿ��ж�Ϊ������

num = 500;
curThreshold = min(min(sc_f), min(sc_nf));
maxThreshold = max(max(sc_f), max(sc_nf));
dt = (maxThreshold-curThreshold) / num;
tpr = zeros(1, num);  % �������ֶԵĸ���
fpr = zeros(1, num);  % �������ִ�ĸ���

found = false;
thresh = 0;

for i=1:num
    Num_tp = sum(sc_f >= curThreshold);
    Num_fn = num_face - Num_tp;

    Num_tn = sum(sc_nf < curThreshold);
    Num_fp = num_nface - Num_tn;

    tpr(i) = Num_tp/(Num_tp+Num_fn); 
    fpr(i) = Num_fp/(Num_tn+Num_fp);

    if ~found && (tpr(i)<0.95)
        thresh = curThreshold;
        fprintf('Above 95 percent positive rate threshold: %f num = %d \n', curThreshold,i);
        found = true;
    end
    curThreshold = curThreshold + dt;
end
save('TPR_FPR.mat', 'tpr','fpr');
figure;
plot(fpr, tpr, '-b', 'LineWidth',1);
title('ROC curve for Face-Detection with Adaboost');
xlabel('False positive rate');
ylabel('True positive rate');
saveas(gcf,'G:\��ҵ���\BiShe_Matlab\Result\ROC.jpg');

clear tpr fpr sc_f sc_nf

end

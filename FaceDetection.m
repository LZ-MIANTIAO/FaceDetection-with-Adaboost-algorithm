function [after_img, Detection_time,face_num] = FaceDetection(img)
global value flag;

tic;
if (value == 1)&&(flag == 0 || flag == 1)  % ada+本地或摄像头
    clear Cparams;
    load('G:\毕业设计\BiShe_Matlab\BackUp\Cparams1.mat');
elseif (value == 2)&&(flag == 0)   % ada结合肤色+本地
    clear Cparams;
    load('G:\毕业设计\BiShe_Matlab\BackUp\6x600x1000\Cparams(100).mat');
elseif (value == 2)&&(flag == 1)   % ada结合肤色+摄像头
    clear Cparams;
    load('G:\毕业设计\BiShe_Matlab\BackUp\5x1200x2400\Cparams(10).mat');
end
% load('Cparams.mat');
% load('G:\毕业设计\BiShe_Matlab\BackUp\5x600x1000\Cparams(50).mat');
% load('G:\毕业设计\BiShe_Matlab\BackUp\5x1200x2400\Cparams(10).mat');
% load('G:\毕业设计\BiShe_Matlab\BackUp\6x600x1000\Cparams(150).mat');
% load('G:\毕业设计\BiShe_Matlab\BackUp\6x1200x2400\Cparams(100).mat');
% load('G:\毕业设计\BiShe_Matlab\BackUp\Cparams1.mat');

% face4_5_7 :0.1 0.8 1.1   
% face6_10  :0.1 0.9 1.2
% face1_2_3 :0.1 0.5 1.1
% face9_10  :0.1 0.9 1.35 
dets = FastScanImage(Cparams, img, 0.1, 0.5, 1.1, false);
temp = size(dets,1);

after_img = DrawRect(img, dets);
time = num2str(toc);
Detection_time = ['检测结束，耗时：',time, '秒'];
% face_num = ['检测到人脸数为：',num2str(temp), '个'];
face_num = temp;

end

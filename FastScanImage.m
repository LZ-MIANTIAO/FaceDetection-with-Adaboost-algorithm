%����ɨ��ͼ��
function dets = FastScanImage(Cparams, img, min_s, max_s, step_s, jump) %imns�д洢�˶����ͼ��min_s=0.1,max_s=1,setp_s=1.1,jump=false

oim = img;         %oim�洢�˶����ͼ��
if(size(img,3)>1)      %����ǲ�ɫͼ����ת���ɻҶ�ͼ��
    img = rgb2gray(img);
end
img = double(img);        %��ͼ�����ݱ�Ϊdouble��

if nargin<5             % nargin��ʾ������������ĸ���
    step_s = 0.1;     
end

if nargin < 6 
    jump = false;       
end

if(step_s<=1)
    disp('step_s should be higher than one!');     
    return;
end

W=Cparams.W; H=Cparams.H;       %W��H��Ϊ19
sq = W * H;         %sq=19*19

threshold = Cparams.threshold;  % ������ֵ
fmat = Cparams.fmat';           % ����ֵf
alphas = Cparams.alphas';       % ��������Ȩ��

dets = [];

theta = Cparams.Thetas(:,2);     % ѵ����ֵ
direction = Cparams.Thetas(:,3); % ����ʽ����ֵ
p_m_theta = direction.*theta;    % ���޳��Բ���ʽ�ķ��򣬼�����������ж�
step_slide_w = 1;                % ��ȷ���Ĳ���
step_slide_h = 1;                % �߶ȷ���Ĳ���

s=max_s;                        

while s>=min_s                      
    sim = imresize(img, s);      % ������Ĵ�����ͼ������Ϊԭ����С��s��  imresize(A,m)��ʾ��ͼ��A�Ŵ�m��
    ii_im = cumsum(cumsum(sim),2);     % ���������ͼ��sim�Ļ���ͼ
    ii2_im = cumsum(cumsum(sim.^2),2); % ���������ͼ������ƽ��ֵ�Ļ���ͼ
    sdets = [];    
    w = size(sim,2);        % ���ź�ͼ��Ŀ��
    h = size(sim,1);        % ���ź�ͼ��ĸ߶�
    if jump                 % ���jumpΪ�棬��Բ�����Ҫ�������ܵĵ�����
        step_slide_w = floor(max(1, w/60));  % ��������ȡ��
        step_slide_h = floor(max(1, h/60));
    end
    for i=2:step_slide_w:w-W+1      % ������������֮��Ļ���ͼ
        for j=2:step_slide_h:h-H+1
            mu = (ii_im(j-1, i-1) + ii_im(j+H-1, i+W-1) - ii_im(j+H-1, i-1) - ii_im(j-1, i+W-1))/sq;    
            vr = (ii2_im(j-1, i-1) + ii2_im(j+H-1, i+W-1) - ii2_im(j+H-1, i-1) - ii2_im(j-1, i+W-1)-sq*mu*mu)/(sq-1);
            if(vr>10)
                subim = (sim(j:j+H-1,i:i+W-1) - mu)/sqrt(vr);
                ii_subim = cumsum(cumsum(subim),2);
                fs = fmat * ii_subim(:);
                r = alphas*(direction.*fs<p_m_theta);
                if r > threshold
                    sdets = [sdets; i,j,W,H];
                end
            end
        end
    end
    nd = size(sdets,1);
    if nd > 0
        dets = [dets; sdets/s];
    end
    s = s/step_s;
end
 
if ~isempty(dets)
    dets = PruneDetections(dets);
end
clear fmat alphas theta subim imns ii_subim fs  % ��ձ�����ʡ�ڴ�
end


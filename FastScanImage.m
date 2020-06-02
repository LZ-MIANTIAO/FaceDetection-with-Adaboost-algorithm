%快速扫描图像
function dets = FastScanImage(Cparams, img, min_s, max_s, step_s, jump) %imns中存储了读入的图像，min_s=0.1,max_s=1,setp_s=1.1,jump=false

oim = img;         %oim存储了读入的图像
if(size(img,3)>1)      %如果是彩色图像，则转换成灰度图像
    img = rgb2gray(img);
end
img = double(img);        %把图像数据变为double型

if nargin<5             % nargin表示函数输入参数的个数
    step_s = 0.1;     
end

if nargin < 6 
    jump = false;       
end

if(step_s<=1)
    disp('step_s should be higher than one!');     
    return;
end

W=Cparams.W; H=Cparams.H;       %W，H均为19
sq = W * H;         %sq=19*19

threshold = Cparams.threshold;  % 测试阈值
fmat = Cparams.fmat';           % 特征值f
alphas = Cparams.alphas';       % 弱分类器权重

dets = [];

theta = Cparams.Thetas(:,2);     % 训练阈值
direction = Cparams.Thetas(:,3); % 不等式方向值
p_m_theta = direction.*theta;    % 门限乘以不等式的方向，即将用于输出判定
step_slide_w = 1;                % 宽度方向的步长
step_slide_h = 1;                % 高度方向的步长

s=max_s;                        

while s>=min_s                      
    sim = imresize(img, s);      % 把输入的待检测的图像缩放为原来大小的s倍  imresize(A,m)表示把图像A放大m倍
    ii_im = cumsum(cumsum(sim),2);     % 计算放缩后图像sim的积分图
    ii2_im = cumsum(cumsum(sim.^2),2); % 计算放缩后图像像素平方值的积分图
    sdets = [];    
    w = size(sim,2);        % 缩放后图像的宽度
    h = size(sim,1);        % 缩放后图像的高度
    if jump                 % 如果jump为真，则对步长需要进行智能的调整，
        step_slide_w = floor(max(1, w/60));  % 进行向下取整
        step_slide_h = floor(max(1, h/60));
    end
    for i=2:step_slide_w:w-W+1      % 遍历整个缩放之后的积分图
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
clear fmat alphas theta subim imns ii_subim fs  % 清空变量节省内存
end


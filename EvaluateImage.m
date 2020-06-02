function map = EvaluateImage(Cparams, imns, scale)

oim = imns;
if(size(imns,3)>1)
    imns = rgb2gray(imns);
end
imns = double(imns);

W=Cparams.W; H=Cparams.H;
sq = W * H;

threshold = Cparams.threshold;
fmat = Cparams.fmat';
alphas = Cparams.alphas';
theta = Cparams.Thetas(:,2);
p = Cparams.Thetas(:,3);
p_m_theta = p.*theta;
step_slide_w = 1;
step_slide_h = 1;

sim = imresize(imns, scale);
ii_im = cumsum(cumsum(sim),2);
ii2_im = cumsum(cumsum(sim.^2),2);
w = size(sim,2);
h = size(sim,1);
map = ones(size(sim,1), size(sim,2))*(-inf);

for i=2:step_slide_w:w-W+1
    for j=2:step_slide_h:h-H+1
        mu = (ii_im(j-1, i-1) + ii_im(j+H-1, i+W-1) - ii_im(j+H-1, i-1) - ii_im(j-1, i+W-1))/sq;
        vr = (ii2_im(j-1, i-1) + ii2_im(j+H-1, i+W-1) - ii2_im(j+H-1, i-1) - ii2_im(j-1, i+W-1)-sq*mu*mu)/(sq-1);
        if(vr>20)
            subim = (sim(j:j+H-1,i:i+W-1) - mu)/sqrt(vr);
            ii_subim = cumsum(cumsum(subim),2);
            fs = fmat * ii_subim(:);
            r = alphas*(p.*fs<p_m_theta);
            map(j,i) = r - threshold;
        end
    end
end

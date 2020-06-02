
function sc = ApplyDetector(Cparams, ii_ims)
ni = size(ii_ims, 1);
theta = Cparams.Thetas(:,2);  % 阈值
direction = Cparams.Thetas(:,3);  
fs = ii_ims * Cparams.fmat;  % 某一特征值f
hs = fs.*(ones(ni,1)*direction') <  ones(ni,1)*(direction.*theta)';  % f * p < alpha * p p为±1
sc = hs*Cparams.alphas;  % hs为Nx5 alpha为5x1   sc = h*alpha 为Nx1
end




function sc = ApplyDetector(Cparams, ii_ims)
ni = size(ii_ims, 1);
theta = Cparams.Thetas(:,2);  % ��ֵ
direction = Cparams.Thetas(:,3);  
fs = ii_ims * Cparams.fmat;  % ĳһ����ֵf
hs = fs.*(ones(ni,1)*direction') <  ones(ni,1)*(direction.*theta)';  % f * p < alpha * p pΪ��1
sc = hs*Cparams.alphas;  % hsΪNx5 alphaΪ5x1   sc = h*alpha ΪNx1
end



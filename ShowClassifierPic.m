function ShowClassifierPic(Cparams)

all_ftypes = Cparams.all_ftypes;
chosen_f = Cparams.Thetas(:,1);
alphas = Cparams.alphas;
ps = Cparams.Thetas(:,3);
W = Cparams.W;
H = Cparams.H;

cpic = zeros(H, W); 

for i=1:length(chosen_f)
    fpic = MakeFeaturePic(all_ftypes(chosen_f(i), :), W, H);
    cpic = cpic + (alphas(i) * ps(i)).*fpic;
end

imagesc(cpic);
colormap(gray);
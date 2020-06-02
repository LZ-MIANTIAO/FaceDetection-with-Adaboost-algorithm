function dets = ScanImageFixedSize(Cparams, im)

if(size(im,3)>1)
    im = rgb2gray(im);
end
im = double(im);

W=19; H=19;

threshold = Cparams.threshold;

w = size(im,2);
h = size(im,1);

ii_im = cumsum(cumsum(im),2);
ii2_im = cumsum(cumsum(im.^2),2);

sq = W * H;

k = 0;

dets = [];

for i=1:w-W+1
    for j=1:h-H+1
        subim = im(j:j+H-1,i:i+W-1);
        mu = ComputeBoxSum(ii_im, i, j, W, H)/sq;
        vr = (ComputeBoxSum(ii2_im, i, j, W, H)-sq*mu*mu)/(sq-1);
        subim = (subim - mu)/sqrt(vr);
        ii_subim = cumsum(cumsum(subim),2);
        r = ApplyDetector(Cparams, ii_subim(:)');
        if r>threshold
            k = k+1;
            dets(k,:) = [i,j,W,H];
        end
    end
end

%DisplayDetections(oim, dets);


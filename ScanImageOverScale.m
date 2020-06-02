function dets = ScanImageOverScale(Cparams, im, min_s, max_s, step_s)

oim = im;
if(size(im,3)>1)
    im = rgb2gray(im);
end
im = double(im);

dets = [];

for s=min_s:step_s:max_s
    sim = imresize(im, s);
    sdets = ScanImageFixedSize(Cparams, sim);
    nd = size(sdets,1);
    if nd > 0
        dets = [dets; sdets/s];
    end
end

if ~isempty(dets)
    dets = PruneDetections(dets);
end
DisplayDetections(oim, dets);

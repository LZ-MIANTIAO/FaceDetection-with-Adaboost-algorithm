function after_img = DrawRect(img, dets)

[~, ~, z] = size(img);  
dets_num = length(dets(:));
position = reshape(dets',1,dets_num); 
color = [255 0 0]; % r g b
lineSize = 2;
imgdata = img;
for i = 1:4:dets_num
    pos_x = position(i);
    pos_y = position(i + 1);
    wx    = position(i + 2);
    wy    = position(i + 3);

    %如果是单通道的灰度图，转成3通道的图像
    if z == 1
        dest(:,:,1) = imgdata;
        dest(:,:,2) = imgdata;
        dest(:,:,3) = imgdata;
    else
        dest = imgdata;
    end

    for c = 1 : 3                 %3个通道，r，g，b分别画
        for n = 0:0.5:lineSize   %线的宽度，线条是向外面扩展的       
            dest(pos_y-n,            (pos_x-n):(pos_x+wx+n),c) = color(c); %上方线条
            dest(pos_y+wy+n,         (pos_x-n):(pos_x+wx+n),c) = color(c); %下方线条
            dest((pos_y-n):(pos_y+wy+n), pos_x-n ,          c) = color(c); %左方线条
            dest((pos_y-n):(pos_y+wy+n), pos_x+wx+n ,       c) = color(c); %左方线条
        end
    end
    imgdata = dest;
end
after_img = imgdata;
end

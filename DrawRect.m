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

    %����ǵ�ͨ���ĻҶ�ͼ��ת��3ͨ����ͼ��
    if z == 1
        dest(:,:,1) = imgdata;
        dest(:,:,2) = imgdata;
        dest(:,:,3) = imgdata;
    else
        dest = imgdata;
    end

    for c = 1 : 3                 %3��ͨ����r��g��b�ֱ�
        for n = 0:0.5:lineSize   %�ߵĿ�ȣ���������������չ��       
            dest(pos_y-n,            (pos_x-n):(pos_x+wx+n),c) = color(c); %�Ϸ�����
            dest(pos_y+wy+n,         (pos_x-n):(pos_x+wx+n),c) = color(c); %�·�����
            dest((pos_y-n):(pos_y+wy+n), pos_x-n ,          c) = color(c); %������
            dest((pos_y-n):(pos_y+wy+n), pos_x+wx+n ,       c) = color(c); %������
        end
    end
    imgdata = dest;
end
after_img = imgdata;
end

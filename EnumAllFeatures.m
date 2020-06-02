% 枚举所有的矩形特征，W,H代表检测窗口的尺寸
function all_ftypes = EnumAllFeatures(W, H)
%    I II III IV V
%    ---------
%    |   +   |
%    ---------     I
%    |   -   |
%    ---------
%    ---------
%    | + | - |    II
%    ---------
%    ---------
%    |+ |- |+|    III
%    ---------
%    ---------
%    |   +   |
%    ---------
%    |   -   |
%    ---------     IV
%    |   +   |
%    ---------
%    ---------
%    | + | - |
%    ---------     V
%    | - | + |
%    ---------
disp('开始计算全部haar特征')
i = 1;
% all_ftypes = zeros(1000,2000);
for w = 1:W-1       % I s,t = 1,2
    for h = 1:floor(H/2)-1
        for x = 2:W-w
            for y = 2:H-2*h
                all_ftypes(i,:) = [1 x y w h];      %（x，y）代表矩形特征左上角点的坐标，w和h则代表矩形的宽和高
                i = i + 1;
            end
        end
    end
end
disp('第一类haar特征计算结束')
for w = 1:floor(W/2)-1      % II s,t = 2,1
    for h = 1:H-1
        for x = 2:W-2*w
            for y = 2:H-h
                all_ftypes(i,:) = [2 x y w h];
                i = i + 1;
            end
        end
    end
end
disp('第二类haar特征计算结束')
for w = 1:floor(W/3)-1      % III s,t = 3,1                        
    for h = 1:H-1
        for x = 2:W-3*w
            for y = 2:H-h
                all_ftypes(i,:) = [3 x y w h];
                i = i + 1;
            end
        end
    end
end
disp('第三类haar特征计算结束')
for w = 1:W-1     % IV s,t = 1 3
    for h = 1:floor(H/3)-1
        for x = 2:W-w
            for y = 2:H-3*h
                all_ftypes(i,:) = [4 x y w h];
                i = i + 1;
            end
        end
    end
end

disp('第四类haar特征计算结束')
for w = 1:floor(W/2)-1      % V s,t = 2,2
    for h = 1:floor(H/2)-1
        for x = 2:W-2*w
            for y = 2:H-2*h
                all_ftypes(i,:) = [5 x y w h];
                i = i + 1;
            end
        end
    end
end
disp('第五类haar特征计算结束')
for w = 1:W-1      % VI 中间黑，四周白 s,t = 1,4
    for h = 1:floor(H/4)-1
        for x = 2:W-w
            for y = 2:H-4*h
                all_ftypes(i,:) = [6 x y w h];
                i = i + 1;
            end
        end
    end
end
disp('第六类haar特征计算结束')
end

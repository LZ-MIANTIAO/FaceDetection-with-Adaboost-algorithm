% ö�����еľ���������W,H�����ⴰ�ڵĳߴ�
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
disp('��ʼ����ȫ��haar����')
i = 1;
% all_ftypes = zeros(1000,2000);
for w = 1:W-1       % I s,t = 1,2
    for h = 1:floor(H/2)-1
        for x = 2:W-w
            for y = 2:H-2*h
                all_ftypes(i,:) = [1 x y w h];      %��x��y����������������Ͻǵ�����꣬w��h�������εĿ�͸�
                i = i + 1;
            end
        end
    end
end
disp('��һ��haar�����������')
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
disp('�ڶ���haar�����������')
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
disp('������haar�����������')
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

disp('������haar�����������')
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
disp('������haar�����������')
for w = 1:W-1      % VI �м�ڣ����ܰ� s,t = 1,4
    for h = 1:floor(H/4)-1
        for x = 2:W-w
            for y = 2:H-4*h
                all_ftypes(i,:) = [6 x y w h];
                i = i + 1;
            end
        end
    end
end
disp('������haar�����������')
end

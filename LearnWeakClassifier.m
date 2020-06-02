% 弱分类器的学习算法
function [theta, p, err] = LearnWeakClassifier(ws, fs, ys)          

ni = size(fs, 1);      % 返回fs变量的行数，为600
nf = size(fs, 2);      % 返回fs变量的列数，即特征矩形数（特征值），为200
% 给每个样本赋权值
wsys = (ws.*ys)';      % wsys是一个行向量，前面是0.0025，后面是0
wsiys = (ws.*(1-ys))'; % wsiys和上面基本一致，不过数据的位置相反，前面是0.后面是0.0013

mp = (wsys *fs)/sum(wsys);         %本身这是一种加权的想法，正例加权0.0025，负例子加权0.0013
mn = (wsiys*fs)/sum(wsiys);        %这也是一个加权的思想，只不过正例子不要（加权为零），负例加权0.0013

sp = (wsys*fs-mp).^2/sum(wsys);
sn = (wsiys*fs-mn).^2/sum(wsiys);

a = sp-sn;
b = -2*(sp.*mn-sn.*mp);
c = (sp.*(mn.^2)-sn.*(mp.^2)) - 2*sp.*sn.*log(sqrt(sp./sn));
d = sqrt(b.*b - 4.*a.*c);

x1 = (-b+d)./(2*a);         %x1和x2是一个一元二次方程的两个解
x2 = (-b-d)./(2*a);
xm = (mp+mn)/2;

[p1, err1] = GetClassiferError(ws, ys, fs, x1, ni, nf);
[p2, err2] = GetClassiferError(ws, ys, fs, x2, ni, nf);

idx = err1 < err2;
theta = x1.*idx + x2.*(1-idx);
p = p1.*idx + p2.*(1-idx);
err = err1.*idx + err2.*(1-idx);

    function [p, err] = GetClassiferError(ws, ys, fs, theta, ni, nf)
        ysx = repmat(ys,[1,nf]);
        fsth = (fs < repmat(theta,[ni,1]));

        ep = ws'*abs(ysx-fsth);
        en = ws'*abs(ysx-~fsth);

        ip = (ep <= en);
        in = (ep >  en);

        p = ip - in;
        err = ep.*ip + en.*in;
    end

end

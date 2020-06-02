% ����������ѧϰ�㷨
function [theta, p, err] = LearnWeakClassifier(ws, fs, ys)          

ni = size(fs, 1);      % ����fs������������Ϊ600
nf = size(fs, 2);      % ����fs������������������������������ֵ����Ϊ200
% ��ÿ��������Ȩֵ
wsys = (ws.*ys)';      % wsys��һ����������ǰ����0.0025��������0
wsiys = (ws.*(1-ys))'; % wsiys���������һ�£��������ݵ�λ���෴��ǰ����0.������0.0013

mp = (wsys *fs)/sum(wsys);         %��������һ�ּ�Ȩ���뷨��������Ȩ0.0025�������Ӽ�Ȩ0.0013
mn = (wsiys*fs)/sum(wsiys);        %��Ҳ��һ����Ȩ��˼�룬ֻ���������Ӳ�Ҫ����ȨΪ�㣩��������Ȩ0.0013

sp = (wsys*fs-mp).^2/sum(wsys);
sn = (wsiys*fs-mn).^2/sum(wsiys);

a = sp-sn;
b = -2*(sp.*mn-sn.*mp);
c = (sp.*(mn.^2)-sn.*(mp.^2)) - 2*sp.*sn.*log(sqrt(sp./sn));
d = sqrt(b.*b - 4.*a.*c);

x1 = (-b+d)./(2*a);         %x1��x2��һ��һԪ���η��̵�������
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

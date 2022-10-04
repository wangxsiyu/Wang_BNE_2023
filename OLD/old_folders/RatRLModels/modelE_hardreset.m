function [c, r] = modelE_hardreset(fd, rs, a, beta)
    ng  =  size(fd,1);
    x = 9;
    i = 1;
    v = ones(1,8)*0.5;
    hb = 9;
    while i <= ng
        if ismember(fd(i,1), [4 6])
            chb = 1;
        else
            chb =  5;
        end
        if chb ~= hb
            v = ones(1,8) * 0.5;
        end
        hb = chb;
        x = go(v, fd(i,:), beta);
        if ismember(x, fd(i,:))
            c(i) = x;
            idx = find(x  ==  fd(i,:));
            rnow = rs(i, idx);
            r(i) = rnow;
            v(x) = v(x) + a * (rnow - v(x));
            i = i + 1;
            x = hb;
        end
    end
end
function xnew = go(v, x,  beta)
    for j = 1:8
        if ~ismember(j, x)
            v(j) = -Inf;
        end
    end
    p = exp(v*beta)/sum(exp(v*beta));
    cump = cumsum(p);
    xnew = sum(rand > cump) + 1;
end
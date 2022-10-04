function [c, r] = modelA_nolight(fd, rs, a)
    ng  =  size(fd,1);
    x = 9;
    i = 1;
    v = zeros(1,8);
    while i <= ng
        x = go(v, x);
        
        if ismember(x, fd(i,:))
            c(i) = x;
            idx = find(x  ==  fd(i,:));
            rnow = rs(i, idx);
            r(i) = rnow;
            v(x) = v(x) + a * (rnow - v(x));
            i = i + 1;
            x = 9;
        else
            v(x) = v(x) + a * (0 - v(x));
        end
    end
end
function xnew = go(v, x)
    if ismember(x, 1:8)
        v(x) = -Inf;
    end
    p = exp(v)/sum(exp(v));
    cump = cumsum(p);
    xnew = sum(rand > cump) + 1;
end
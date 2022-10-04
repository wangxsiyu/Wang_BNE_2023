function [c, r] = modelD_plusminusalpha(fd, rs, a,  b)
    ng  =  size(fd,1);
    x = 9;
    i = 1;
    v = zeros(1,8);
    while i <= ng
        x = go(v, fd(i,:));
        if ismember(x, fd(i,:))
            c(i) = x;
            idx = find(x  ==  fd(i,:));
            rnow = rs(i, idx);
            r(i) = rnow;
            if rnow > v(x)
                v(x) = v(x) + a * (rnow - v(x));
            else
                v(x) = v(x) + b * (rnow - v(x));
            end
            i = i + 1;
            x = 9;
        end
    end
end
function xnew = go(v, x)
    for j = 1:8
        if ~ismember(j, x)
            v(j) = -Inf;
        end
    end
    p = exp(v)/sum(exp(v));
    cump = cumsum(p);
    xnew = sum(rand > cump) + 1;
end
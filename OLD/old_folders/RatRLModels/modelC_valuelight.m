function [c, r] = modelC_valuelight(fd, rs, a,  b)
    ng  =  size(fd,1);
    x = 9;
    i = 1;
    v = zeros(1,8);
    while i <= ng
        x = go(v, x, fd(i,:), b);
        if ismember(x, fd(i,:))
            c(i) = x;
            idx = find(x  ==  fd(i,:));
            rnow = rs(i, idx);
            r(i) = rnow;
            v(x) = v(x) + a * (rnow - v(x));
            i = i + 1;
            x = 9;
        end
    end
end
function xnew = go(v, x, fdlight, b)
    if ismember(x, 1:8)
        v(x) = -Inf;
    end
    for j= 1:length(fdlight)
        if ismember(fdlight(j), 1:8)
            v(fdlight(j)) = v(fdlight(j)) + b;
        end
    end
    p = exp(v)/sum(exp(v));
    cump = cumsum(p);
    xnew = sum(rand > cump) + 1;
end
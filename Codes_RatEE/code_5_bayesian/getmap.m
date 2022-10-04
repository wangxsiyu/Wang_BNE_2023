function out = getmap(x, step)
    if ~exist('step')
        step = 0.01;
    end
    x = reshape(x,1,[]);
    rg = [min(x), max(x)];
    step1 = step;
    while length(x)/(diff(rg)/step1) < 5
        step1 = step1 + step;
    end
    bin = [rg(1) - step1:step1:rg(2)+step1];
    te = hist(x,bin);
    te = smooth(te);
    idx = find(max(te) == te);
    if length(idx) >= 1
        outs = arrayfun(@(x)bin(x), idx);
        tdis = (outs - mean(x)).^2;
        out = outs(tdis == min(tdis));
    else
        disp('error, no peak')
        out = mean(x);
    end
end
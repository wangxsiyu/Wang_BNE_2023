function [xfit] = tempMLEfit(c, r)
    x0 = [2 1];
    lb = [0 0 ];
    ub = [5 10];
    xfit = fmincon(@(x)-lik(x(1),x(2), c, r),  x0, [],[],[],[],lb, ub);
end
function lik = lik(thres, noise, c, r)
    p = 1./(1 + exp(-(r - thres)/noise));
    p(c == 0) = 1 - p(c == 0);
    logp = log(p);
    lik = sum(log(p));
end
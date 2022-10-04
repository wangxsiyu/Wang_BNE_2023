function out = simulateMD(d)
    out = [];
    d = d.bayesdata;
    noise = rand * 5 + 5;
    thres = rand * 5;
    a_lg = 1*rand * 0.5;
    a_lr = 1*rand * 0.5;
    bias = 5*(rand - 0.5);
    out.paramtruth = {thres, noise, a_lg, a_lr, bias};
    out.bayesdata = simu(d, thres, noise, a_lg, a_lr, bias);
end
function d = simu(d, thres, noise, a_lg, a_lr, bias)
    c = d.c * NaN;
    for t = 1:d.nG
        tt = thres;
        tvlastgame = W.iif(d.rLastGame(t) == -1, tt, d.rLastGame(t));
        tvlastsession = W.iif(d.rLastSession(t) == -1, tt, d.rLastSession(t));

        tvOlastgame = W.iif(d.rOLastGame(t) == -1, tt, d.rOLastGame(t));
        tvOlastsession = W.iif(d.rOLastSession(t) == -1, tt, d.rOLastSession(t));

        dQ = d.r(t) - tt + a_lg * (tvlastgame - tvOlastgame) + ...
            a_lr * (tvlastsession - tvOlastsession) +  d.sideguided(t) * bias;
        P  = 1 - 1/(1 + exp(-dQ/(noise)));
        if rand < P
            c(t) = 1;
        else
            c(t) = 0;
        end
    end
    d.c = c;
end
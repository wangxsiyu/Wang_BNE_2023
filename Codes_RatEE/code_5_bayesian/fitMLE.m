function LL = fitMLE(d, thres, noise, alg, als, bias)
    r = d.r;
    c = d.c;
    rLG = d.rLastGame;
    rLG(rLG == -1) = thres;
    rLG2 = d.rOLastGame;
    rLG2(rLG2 == -1) = thres;
    rLS = d.rLastSession;
    rLS(rLS == -1) = thres;
    rLS2 = d.rOLastSession;
    rLS2(rLS2 == -1) = thres;
    dQ = r - thres + alg * (rLG - rLG2) + als * (rLS - rLS2) + bias * d.sideguided;
    P = 1 - 1./(1 + exp(-dQ./noise));
    P(c == 0) = 1 - P(c == 0);
    logP = log(P);
    logP = logP(~isnan(logP));
    LL = -sum(logP);
end
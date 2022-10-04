function out = MLE_RatEE(g)
    % assume constant n_guided and n_free
    ng = unique(g.n_guided);
    nf = unique(g.n_free);
    %% deal with free 1st choice
    if ng == 0
        g.is_guided(:,1) = 1;
    end
    %% get idx_free, idx_guided
    idg = mean(g.is_guided == 1) == 1;
    idf = mean(g.is_guided == 0) == 1;
    %% compute 
    g.r_guided = W.funccol('nanmean',g.r(:,idg)')';    % r_guided
    g.c_guided = W.funccol('nanmean',g.c(:,idg)')';    % c_guided
    g.side_guided = ismember(g.c_guided, [6 2]) + 1; % 1-L 2-R
    g.c_other = nansum(g.feeders')' - g.c_guided; % c_other
    g.side_other = ismember(g.c_other, [6 2]) + 1; % 1-L 2-R
    if all(~isnan(g.drop),'all') % r_other
        g.r_other = sum(g.drop')' - g.r_guided;
    else % random
        disp(sprintf('percent NaN in drops: %.2f%%', mean(isnan(g.drop) * 100, 'all')));
        g.r_other = nansum((W.nan_equal(g.c, g.c_other).* g.r)')'./nansum(W.nan_equal(g.c, g.c_other)')';    
    end
    g.c_side = ismember(g.c, [6 2]) + 1;
    %% recode
    g.c_guided = g.c_guided/2;
    g.c_other = g.c_other/2;
    g.c = g.c/2;
    %% compute behavior 
    %      noise    threshold    side bias
    X0  = [10       2.5          0];
    LB  = [0        0           -100];
    UB  = [100      5           100];
    obFunc = @(x)-fit_MLE(x(1), x(2), x(3), g);
    [x, tar] = fmincon(obFunc, X0, [], [], [], [], LB, UB);
    out.MLE1_noise = x(1);
    out.MLE1_threshold = x(2);
    out.MLE1_bias_side = x(3);
    %% compute trial by trial
%     %      noise    v0    learning rate     side bias     info bonus      repeat tendency
%     X0  = [10       2.5     0                0              0               0];
%     LB  = [0        0       -1               -100           -100            -100];
%     UB  = [100      5       1                100            100             100];
%     obFunc2 = @(x)-fit_MLE2(x(1), x(2), x(3),x(4), x(5), x(6), g);
%     [x2, tar] = fmincon(obFunc2, X0, [], [], [], [], LB, UB);
%     out.MLE2_noise = x2(1);
%     out.MLE2_v0 = x2(2);
%     out.MLE2_bias_side = x2(4);
%     out.MLE2_learningrate = x2(3);
%     out.MLE2_bias_info = x2(5);
%     out.MLE2_bias_repeat = x2(6);
    %% by time
    g = sortrows(g, 'date');
    n = size(g,1);
    xat = round(linspace(25, n - 25, 5));
    for xi = 1:length(xat)
        tg = g((xat(xi)-24):(xat(xi)+25),:);
        obFunc = @(x)-fit_MLE(x(1), x(2), x(3), tg);
        [x, tar] = fmincon(obFunc, X0, [], [], [], [], LB, UB);
        out.MLE1_noise_byT(xi) = x(1);
        out.MLE1_threshold_byT(xi) = x(2);
        out.MLE1_bias_side_byT(xi) = x(3);
        
%         X0  = [10       2.5     0                0              0               0];
%         LB  = [0        0       -1               -100           -100            -100];
%         UB  = [100      5       1                100            100             100];
%         obFunc2 = @(x)-fit_MLE2(x(1), x(2), x(3),x(4), x(5), x(6), tg);
%         [x2, tar] = fmincon(obFunc2, X0, [], [], [], [], LB, UB);
%         out.MLE2_noise_byT = x2(1);
%         out.MLE2_v0_byT = x2(2);
%         out.MLE2_bias_side_byT = x2(4);
%         out.MLE2_learningrate_byT = x2(3);
%         out.MLE2_bias_info_byT = x2(5);
%         out.MLE2_bias_repeat_byT = x2(6);
    end
end
function LL = fit_MLE(sigma, thres, SB, g)
    dQ = g.r_guided - thres + SB * sign(g.side_guided - 1.5) ;
    P = 1 ./ ( 1 + exp( -1/sigma/sqrt(2) * dQ ));
    c5 = g.c(:,unique(g.n_guided) + 1);
    c5 = c5 == g.c_guided;
    lP1 = log(P(c5==1));
    lP0 = log(1-P(c5==0));
    lP1 = lP1(~isnan(lP1));%what if there are fewer terms so it's becoming large?
    lP0 = lP0(~isnan(lP0));
    LL = (sum(lP1)+sum(lP0));
end

function LL = fit_MLE2(sigma, v0, alpha, SB, IB, RB, g)
    P = [];
    for gi = 1:size(g,1)
        v = repmat(v0, 1, 4);
        tg = g(gi,:);
        tng = tg.n_guided;
        for ti = 1:(tng)
            if isnan(tg.c(ti))
                continue;
            end
            v(tg.c(ti)) = v(tg.c(ti)) + alpha * (tg.r(ti) - v(tg.c(ti)) );
        end
        tp = [];
        for ti = 1:tg.n_free
            tti = tng + ti;
            
            if isnan(tg.c(tti))
                tp(ti) = NaN;
                continue;
            end
            tdQ = v(tg.c_guided) - v(tg.c_other) + ...
                SB * sign(tg.side_guided - 1.5) + ...
                W.iif(ti == 1, IB, RB);
            tp(ti) = 1 ./ ( 1 + exp( -1/sigma/sqrt(2) * tdQ ));
            if tg.c(tti) ~= tg.c_guided
                tp(ti) = 1 - tp(ti);
            end
            v(tg.c(tti)) = v(tg.c(tti)) + alpha * (tg.r(tti) - v(tg.c(tti)) );
        end
        P = horzcat(P, tp);
    end
    lP1 = log(P);
    lP1 = lP1(~isnan(lP1));%what if there are fewer terms so it's becoming large?
    LL = (sum(lP1));
end
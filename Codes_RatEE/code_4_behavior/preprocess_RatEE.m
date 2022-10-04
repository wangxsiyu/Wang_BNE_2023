function g = preprocess_RatEE(g)
    % OLD assume constant n_guided and n_free
    % new analyze it game by game
    ng = unique(g.n_guided); % single number
    nf = unique(g.n_free);
    if length(nf) > 1 || length(ng) > 1
        error('check');
    end
    %% deal with free 1st choice
    if ng == 0
        g.is_guided(:,1) = 1;
        g.is_free1stchoice(:,1) = 1;
    else
        g.is_free1stchoice(:,1) = 0;
    end
    if (ng == 0 && nf == 2)
        nf = 1;
    end
    if (ng == 0 && nf == 7)
        nf = 6;
    end
    if nf >= 15
        nf = 15;
    end
    g.cond_horizon(:,1) = nf;
    if  nf == 1 || (ng == 0 && nf == 2)
        g.bayes_horizon(:,1) = 1; % short
    elseif nf == 2
        g.bayes_horizon(:,1) = 2;
    elseif nf == 5 % human
        g.bayes_horizon(:,1) = 3;
    elseif nf <= 7 && nf >=6
        g.bayes_horizon(:,1) = 3; % long
    elseif nf == 10 % human (or old rat)
        g.bayes_horizon(:,1) = 4;
    elseif nf >= 15
        g.bayes_horizon(:,1) = 4; % extra long
    elseif ng == 0 && nf == 8
        g.bayes_horizon(:,1) = 3;
        g.cond_horizon(:,1) = 6;    
        g.c(:,8:end) = NaN;    
        g.r(:,8:end) = NaN;
        g.is_guided(:,8:end) = NaN;
    elseif ng == 0 && nf == 3
        g.bayes_horizon(:,1) = 1;
        g.cond_horizon(:,1) = 1;   
        g.c(:,3:end) = NaN;    
        g.r(:,3:end) = NaN;
        g.is_guided(:,3:end) = NaN;
    else
        warning(sprintf('cond %d', nf));
%         error('check')
    end


    g.cond_guided(:,1) = ng;
    %% get idx_free, idx_guided
    idg = mean(g.is_guided == 1) > 0;
    idf = mean(g.is_guided < 1) > 0;
    %% compute 
    g.r_guided = W.funccol('nanmean',g.r(:,idg)')';    % r_guided
    g.c_guided = W.funccol('nanmean',g.c(:,idg)')';    % c_guided
    g.side_guided = ismember(g.c_guided, [6 2]) + 1; % 1-L 2-R
    g.c_other = nansum(g.feeders')' - g.c_guided; % c_other
    g.side_other = ismember(g.c_other, [6 2]) + 1; % 1-L 2-R
    if all(~isnan(g.drop),'all') % r_other
        g.r_other = sum(g.drop')' - g.r_guided;
        g.cond_random(:,1) = 0;
    else % random
        disp(sprintf('percent NaN in drops: %.2f%%', mean(isnan(g.drop) * 100, 'all')));
        g.r_other = nansum((W.nan_equal(g.c, g.c_other).* g.r)')'./nansum(W.nan_equal(g.c, g.c_other)')';   
        g.r_guided_all = nansum((W.nan_equal(g.c, g.c_guided).* g.r)')'./nansum(W.nan_equal(g.c, g.c_guided)')'; 
        g.cond_random(:,1) = 1; 
    end
    g.c_side = ismember(g.c, [6 2]) + 1;
    %% compute behavior    
    g.fd_best = (g.r_guided > g.r_other) .* g.c_guided + (g.r_guided < g.r_other) .* g.c_other;
    g.fd_best(g.fd_best == 0) = NaN;
    if all(g.cond_random == 1)
        g.fd_best = (g.r_guided_all > g.r_other) .* g.c_guided + (g.r_guided_all < g.r_other) .* g.c_other;
        g.fd_best(g.fd_best == 0) = NaN;
    end
    
    g.cc_best = W.nan_equal(g.c(:, idf), g.fd_best);
    g.cc_explore = g.c(:, idf) ~= g.c_guided;
    g.cc_switch = g.c(:, find(idf)) ~= g.c(:, find(idf)-1);
    g.cc_sw_guided = g.cc_switch & g.c_guided == g.c(:,find(idf)); 
    g.cc_sw_unguided = g.cc_switch & g.c_guided ~= g.c(:,find(idf)); 
    g.cc_left = g.c_side(:, idf) == 1; 
    
    g.c1_cc_best = g.cc_best(:,1);
    g.c1_cc_explore = g.cc_explore(:,1);
    g.c1_cc_switch = g.cc_switch(:,1);
    g.c1_cc_left = g.cc_left(:,1);
    
    g.ce_cc_best = g.cc_best(:,end);
    g.ce_cc_explore = g.cc_explore(:,end);
    g.ce_cc_switch = g.cc_switch(:,end);
    g.ce_cc_left = g.cc_left(:,end);
    
    g.ac_guided = W.funccol('mean', W.nan_equal(g.c(:, idg), g.fd_best)')'; % 1/0
end
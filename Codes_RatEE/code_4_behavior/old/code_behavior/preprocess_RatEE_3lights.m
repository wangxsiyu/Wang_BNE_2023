function g = preprocess_RatEE_3lights(g)
    % assume constant n_guided and n_free
    ng = unique(g.n_guided);
    nf = unique(g.n_free);
    c1 = g.c(:, ng+1);
    g.c_novel = ~ismember(c1, [2 4 6 8]);
    if ng == 0
        g.c_explore(:,1) = NaN;
    else
        c_guided = g.c(:,1);    % c_guided
        g.c_explore = (c1 ~= c_guided) + 0;
    end
%     %% deal with free 1st choice
%     if ng == 0
%         g.is_guided(:,1) = 1;
%         g.is_free1stchoice(:,1) = 1;
%     else
%         g.is_free1stchoice(:,1) = 0;
%     end
% %     if nf <= 2 && nf >= 1
% %         g.cond_horizon(:,1) = 1; % short
% %     elseif nf <= 7 && nf >=6
% %         g.cond_horizon(:,1) = 2; % long
% %     else
% %         g.cond_horizon(:,1) = 3; % extra long
% %     end
%     %% get idx_free, idx_guided
%     idg = mean(g.is_guided == 1) == 1;
%     idf = mean(g.is_guided == 0) == 1;
%     %% compute 
%     g.r_guided = W.funccol('nanmean',g.r(:,idg)')';    % r_guided
%     g.r_guided2 = W.funccol('nanmean',g.r(:,:)')';    % r_guided
%     g.c_guided = W.funccol('nanmean',g.c(:,idg)')';    % c_guided
%     g.side_guided = ismember(g.c_guided, [6 2]) + 1; % 1-L 2-R
%     g.c_other = nansum(g.feeders')' - g.c_guided; % c_other
%     g.side_other = ismember(g.c_other, [6 2]) + 1; % 1-L 2-R
%     if all(~isnan(g.drop),'all') % r_other
%         g.r_other = sum(g.drop')' - g.r_guided;
%         g.cond_random(:,1) = 0;
%         g.cond_horizon(:,1) = 0;
%     else % random
%         disp(sprintf('percent NaN in drops: %.2f%%', mean(isnan(g.drop) * 100, 'all')));
%         g.r_other = nansum((W.nan_equal(g.c, g.c_other).* g.r)')'./nansum(W.nan_equal(g.c, g.c_other)')';   
%         g.cond_random(:,1) = 1; 
%         g.cond_horizon(:,1) = 1;
%     end
%     g.c_side = ismember(g.c, [6 2]) + 1;
%     %% compute behavior    
%     g.fd_best = (g.r_guided2 > g.r_other) .* g.c_guided + (g.r_guided2 < g.r_other) .* g.c_other;
%     g.fd_best(g.fd_best == 0) = NaN;
%     
%     g.cc_best = W.nan_equal(g.c(:, idf), g.fd_best);
%     g.cc_explore = g.c(:, idf) ~= g.c_guided;
%     g.cc_switch = g.c(:, find(idf)) ~= g.c(:, find(idf)-1); 
%     g.cc_left = g.c_side(:, idf) == 1; 
%     
%     g.c1_cc_best = g.cc_best(:,1);
%     g.c1_cc_explore = g.cc_explore(:,1);
%     g.c1_cc_switch = g.cc_switch(:,1);
%     g.c1_cc_left = g.cc_left(:,1);
%     g.ac_guided = W.funccol('mean', W.nan_equal(g.c(:, idg), g.fd_best)')'; % 1/0
end
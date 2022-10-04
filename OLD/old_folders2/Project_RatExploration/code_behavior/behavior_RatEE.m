function out = behavior_RatEE(g)
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
    %% compute behavior    
    g.fd_best = (g.r_guided > g.r_other) .* g.c_guided + (g.r_guided < g.r_other) .* g.c_other;
    g.fd_best(g.fd_best == 0) = NaN;
    
    g.cc_best = W.nan_equal(g.c(:, idf), g.fd_best);
    g.cc_explore = g.c(:, idf) ~= g.c_guided;
    g.cc_switch = g.c(:, find(idf)) ~= g.c(:, find(idf)-1); 
    g.cc_left = g.c_side(:, idf) == 1; 
    
    g.c1_cc_best = g.cc_best(:,1);
    g.c1_cc_explore = g.cc_explore(:,1);
    g.c1_cc_switch = g.cc_switch(:,1);
    g.c1_cc_left = g.cc_left(:,1);
    g.ac_guided = W.funccol('mean', W.nan_equal(g.c(:, idg), g.fd_best)')'; % 1/0
    %% r curve
    behsets = {'cc_best','cc_explore','cc_switch','cc_left','ac_guided'};
    behsets1 = {'c1_cc_best','c1_cc_explore','c1_cc_switch','c1_cc_left'};
    out = W.analysis_av(g, behsets);
    out2 = W.analysis_bincurve(g, behsets, 'r_guided', -0.5:1:5.5, 'all');
    out = catstruct(out,out2);
    out3 = W.analysis_bincurve_bygroup(g, behsets, 'ac_guided',[], 'r_guided', -0.5:1:5.5, 'all');
    out = catstruct(out,out3);
    out4 = W.analysis_av_bygroup(g, behsets, 'ac_guided',[]);
    out = catstruct(out,out4); 
    out5 = W.analysis_bincurve(g, behsets1, 'gameID', -0.5:5:35.5, 'all');
    out = catstruct(out,W.struct_rename_prefix(out5, 'gameID_'));
    out6 = W.analysis_bincurve(g, behsets1, 'gameID_perc', -0.1:0.2:1.1, 'all');
    out = catstruct(out,W.struct_rename_prefix(out6, 'gameIDperc_'));
end
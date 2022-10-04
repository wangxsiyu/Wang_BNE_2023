function out = accuracy_RatEE(g)
    %% r curve
    out.accuracy = nanmean(g.cc_best,'all');
    out.n_trials = nanmean(g.n_games);
    out.vv = string(out.vv);
end
function g = performance_RatEE(g)
    g = sortrows(g, {'rat', 'datetime', 'gameID'});
    ac = nanmean(g.cc_best,2);
    ac_smoothed = W.slidingwindow(ac, [], [], [-5, 5]);
    g.cc_best_smoothed(:,1) = ac_smoothed;
end
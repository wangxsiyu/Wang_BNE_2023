function out = behavior_RatEE_3lights(g)
    out.p_novel = nanmean(g.c_novel);
    out.p_explore = nanmean(g.c_explore);
end
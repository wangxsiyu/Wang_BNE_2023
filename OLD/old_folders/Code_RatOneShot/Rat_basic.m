function out = Rat_basic(data)
    if  size(data,1) == 1
        out.c_ac = data.c_ac;
        out.c_explore = data.c_explore;
        out.c_repeat = data.c_repeat;
    else
        out.c_ac = nanmean(data.c_ac);
        out.c_explore = nanmean(data.c_explore);
        out.c_repeat = nanmean(data.c_repeat);
    end

end
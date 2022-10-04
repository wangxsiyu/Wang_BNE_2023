function [av, se] = tool_avse(d)
    av = nanmean(d);
    se = nanstd(d)/sqrt(size(d,1));
end
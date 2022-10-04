function p = ratlinetstat_h16(x, h, c)
    cs = unique(c);
    for ci = 1:length(cs)
        x1 = x(c == cs(ci) & h == 1,:);
        x2 = x(c == cs(ci) & h == 6,:);
        [~,p(ci,:)] = ttest(x1-x2);
    end
end
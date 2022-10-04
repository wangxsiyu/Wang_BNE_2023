function p = ratlinetstat(x, h)
    hs = unique(h);
    for hi = 1:length(hs)
        te = x(h == hs(hi));
        x1 = W.cellfun(@(x)x(1,:), te);
        x1 = vertcat(x1{:});
        x2 = W.cellfun(@(x)x(2,:), te);
        x2 = vertcat(x2{:});
        [~,p(hi,:)] = ttest(x1-x2);
    end
end
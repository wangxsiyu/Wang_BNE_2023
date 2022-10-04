function out = excludeearlydate(rat, dates, ndate)
    rats = unique(rat);
    out = zeros(length(dates),1);
    for ri = 1:length(rats)
        tid = find(strcmp(rats{ri}, rat));
        [tt] = min(dates(tid));
        tt = dates(tid) == tt;
        out(tid(tt)) = 1;
    end
    out = out == 1;
end
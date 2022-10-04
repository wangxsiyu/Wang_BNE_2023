function out = gethistory(d)
    for i = 1:size(d,1)
        if i == 1
            out.value_lastvisit(i,:) = NaN * d.feeders(i,:);
            out.value_lastgame(i,:) = NaN * d.feeders(i,:);
        else
            tr = d.r_experienced(1:(i-1),:);
            out.value_lastvisit(i,:) = arrayfun(@(x)findlastnonNaN(tr, x), d.feeders(i,:));
            tfd = d.feeders(1:(i-1),:);
            out.value_lastgame(i,:) = arrayfun(@(x)findlastgame(tr, tfd, x), d.feeders(i,:));
        end
        out.value_avgame(i,:) = nanmean(d.r_experienced);
    end
end
function out = findlastnonNaN(tr, x)
    if isnan(x)
        out = NaN;
    else
        tr = tr(:,x); 
        tr = tr(~isnan(tr));
        if isempty(tr)
            out = NaN;
        else
            out = tr(end);
        end
    end
end
function out = findlastgame(tr, tfd, x)
    if isnan(x)
        out = NaN;
    else
        tid = any(tfd == x, 2);
        tr = tr(tid, x);
        if isempty(tr)
            out = NaN;
        else
            out = tr(end);
        end
    end
end
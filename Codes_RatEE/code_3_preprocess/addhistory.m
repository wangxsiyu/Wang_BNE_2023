function data = addhistory(data)
%% game-level calculation
data = sortrows(data, {'date','time','gameID'});
data.r_experienced = NaN(size(data,1), 8);
for i = 1:8
    idx =data.c == i;
    tr = nansum(data.r.*idx,2);
    tc = sum(idx, 2);
    data.r_experienced(:,i) = tr./tc;
end
%% session-level calculation (previous value)
idx = W_sub.selectsubject(data, {'foldername'});
data = W_sub.preprocess_subxgame(data, idx, 'gethistory');
%% find value for the previous session
ratids = cellfun(@(x)unique(string(data.rat(x))), idx);
%%
for i = 1:length(idx)
    idlast = [];
    if (i == 1)
    else
        ratnow = ratids{i};
        idlast = max(find(strcmp(ratids(1:i-1), ratnow)));
    end
    if ~isempty(idlast)
        tv = W.unique(data.value_avgame(idx{idlast},:),'rows');
        tfd = data.feeders(idx{i},:);
        data.value_lastsession(idx{i},:) = arrayfun(@(x)W.nan_select(tv,x), tfd);
    else
        data.value_lastsession(idx{i},:) = NaN(length(idx{i}),size(data.feeders,2));
    end
end
end
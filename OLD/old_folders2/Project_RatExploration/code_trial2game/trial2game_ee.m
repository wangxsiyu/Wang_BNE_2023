function tab = trial2game_ee(g)
    tab = table;
    if isempty(g)
        return;
    end
%     if g.choice(1) == g.choice(end) && ismember(g.choice(1), [1 5])
%         g = g(1:end-1,:);
%     end
    idhb = any(ismember(g.feeders, [1 5])')';
    id_cue = sum(~isnan(g.feeders)')' == 1 & ~idhb;
    id_free = sum(~isnan(g.feeders)')' == 2;
    idall = id_cue * 1 + id_free * 0;
    if all(id_free == 0)
        return; % ignore games with no free choices
    end
    tab.n_guided = sum(id_cue);
    tab.n_free = sum(id_free);
    tab.feeders = W.horz(W.unique(g.feeders(id_free,:)));
    tdrop = W.arrayfun(@(x)W.horz(W.unique(g.drops(g.feeders == x))), tab.feeders);
    if ~iscell(tdrop)
        tab.drop = tdrop;
    else % this should be the control condition (random drops)
        tab.drop = NaN(size(tab.feeders));
    end
    tab.is_guided = W.horz(idall(id_cue | id_free));
    tab.c = W.horz(g.choice(id_cue | id_free));
    tdp = nansum((g.choice == g.feeders).*g.drops, 2);
    tab.r = W.horz(tdp(id_cue|id_free));
    % this doesn't work for earlier versions (assume a constant release
    % time)
    tab.releasetime = W.unique(g.releasetime(id_free,:),  'rows');
end
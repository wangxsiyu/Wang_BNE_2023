function tab = trial2game_ee_3lights(d)
    tab = table;
    id15 = any(ismember(d.feeders, [1 5])')';
    idx = find(id15(1:end-1) & id15(2:end));
    if ~isempty(idx)
        d(idx,:) = [];
        id15 = any(ismember(d.feeders, [1 5])')';
    end
    
    idhb = any(ismember(d.feeders, [1 5])')';
    if ~any(idhb == 0)
        return;
    end
    hb = d.homebase15;
    idx_hb0 = find(hb == 0);
    if ~isempty(idx_hb0)
        warning('find rows that''s in neither homebase');
    end
    for i = 1:length(idx_hb0) % assume homebase will not switch in 1 pair of feeder/homebase run
        ii = idx_hb0(i);
        if ii > 1 && ii < length(hb) && ...
                d.n_lights(ii) >= 2 && ...
                hb(ii-1) == hb(ii+1) 
            hb(ii) = hb(ii+1);
        end
    end
    lb = W.get_consecutives(hb);
    
    for ii = 1:height(lb)
        tg = d(lb.start(ii):lb.end(ii),:);
        while ~isempty(tg) && ~ismember(tg.choice(end),[2 4 6 8])
            tg = tg(1:end-1,:);
        end
        ttab = trial2game_ee3(tg);
        tab = W.tab_vertcat(tab, ttab);
    end
    
end

function game = formatRat_game(game, maze)
    nfdmax = max(cellfun(@(x)length(x), game.feeders));
    fds = cellfun(@(x)W.extend_nan_fast(arrayfun(@(t)letter2num(t, maze), x), nfdmax), game.feeders, 'UniformOutput', false);
    fds = vertcat(fds{:});
	isfeeder = W.nan_selects(maze.isfeeder, fds);
    game.feeders_all = fds;
    game.isfeeder_all = isfeeder;
    releasetime = game.releasetime;
    drops = game.drops;
    dps = cellfun(@(x) W.extend_nan_fast(arrayfun(@(t)str2num(t), x), nfdmax), drops, 'UniformOutput', false);
    dps = vertcat(dps{:});
    if all(releasetime < 50) % consider this the early format, 20 * dp = releasetime
        disp('--- early format: release time in 0-9 drops');
        releasetime = releasetime .*dps;
        dps(~isnan(dps)) = 1;
    else
        releasetime = repmat(releasetime, 1,size(fds,2));
    end
    game.drop_all = dps;
    game.releasetime_all = releasetime;
    
    % ignore sound (sound will be registered in TrackBehavior)
    game.feeders = getfd(game.feeders_all, isfeeder);
    game.drops = getfd(game.drop_all, isfeeder);
    game.releasetime = getfd(game.releasetime_all, isfeeder);
    
    
    game.soundzone = getfd(game.feeders_all, 1-isfeeder);
end
function out = getfd(x, id)
    x = x + (1:size(x,2))/10;
    x0 = max(x,[],'all') + 1;
    x = changem(x, x0);
    x = x .* id;
    x(x == 0) = NaN;
    x = W.col_unique(x', 0,'stable');
    x = W.cellfun(@(t)t', x);
    x = W.cell_extend_fast(x);
    x = vertcat(x{:});
    x(x == x0) = 0;
    out = floor(x);
end
function t = letter2num(t, maze)
    id = find(strcmp(maze.letter, t));
    if ~isempty(id)
        t = maze.number(id); % use number (zone) instead of locationID
    else
        t = NaN;
        cprintf('Red', 'location does not match any letters/numbers in the maze file: %s\n', t);
    end
end
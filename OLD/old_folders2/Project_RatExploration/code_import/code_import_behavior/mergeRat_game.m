function out = mergeRat_game(game, behavior)
    if size(game,1) < size(behavior, 1)
        cprintf('systemcommand', 'game length < behavior length\n');
        while size(game,1) < size(behavior, 1)
            game = vertcat(game, game);
        end
    end
    game = game(1:size(behavior,1),:);
    behavior.filename = [];
    out = W_basic.tab_horzmerge(behavior, game);
end
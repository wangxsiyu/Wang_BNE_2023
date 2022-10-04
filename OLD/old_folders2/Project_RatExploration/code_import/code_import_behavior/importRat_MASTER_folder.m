function [data] = importRat_MASTER_folder(folder, maze)
    %% select Game/Behavior.txt
    files = dir(fullfile(folder, ['*.txt']));
    files = {files.name};
    idx_file = contains(files, {'Game','Behavior'});
    if all(idx_file == 0)
        cprintf([1,0.5,0], 'Game.txt or Behavior.txt do NOT exist in folder: %s\n', folder);
        data = table;
        dir(folder);
        return;
    else
        filesbeh = files(idx_file);
    end
    filenums = unique(cellfun(@(x)W.str_select(x), filesbeh));
    %% import Load_SoundMap.txt
    raw_soundmap = importRat_soundmap(fullfile(folder, 'Load_SoundMap.txt'));
    %% merge sound with maze
    maze = mergeRat_sound(maze, raw_soundmap);
    %% process for each game/behavior pair
    data = table;
    for pi = 1:length(filenums)
        tdata = import_gamebehaviorpair(folder, filenums(pi), maze);
        data = W.tab_vertcat(data, tdata);
    end
end
function data = import_gamebehaviorpair(folder, pi, maze)
    %% import Game.txt
    raw_game = importRat_game(fullfile(folder, sprintf('Game%d.txt', pi)));
    %% format game.txt
    game = formatRat_game(raw_game, maze);
    %% import Behavior.txt
    raw_behavior = importRat_trackerBehavior(fullfile(folder, sprintf('Behavior%d.txt', pi)));
    %% format behavior.txt
    behavior = formatRat_trackerBehavior(raw_behavior, {'now','Now','StopTraining','KBWrong'}, maze);
    %% format game.txt
    game_merged = mergeRat_game(game, behavior);
    %% format merged game - separate sound location and feeder
    data = formatRat_gamebehavior(game_merged, maze);
end
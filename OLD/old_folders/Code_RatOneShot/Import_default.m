function game = Import_default(tdir, option)
    game = [];
    ng = length(dir(fullfile(tdir, 'Behavior*.txt')));
    for gi = 1:ng
        tfile = sprintf('Behavior%d.txt', gi);
        Filename = fullfile(tdir, tfile);
        if ~exist(Filename)
            warning(sprintf('missing response file: %s', tfile));
            continue;
        else
            beh = Import_TrackerBehavior(Filename);
        end
        tfile = sprintf('Game%d.txt', gi);
        Filename = fullfile(tdir, tfile);
        if ~exist(Filename)
            warning(sprintf('missing game file: %s', tfile));
            continue;
        else
            tsk = Import_taskset(Filename);
        end
        tgame = preprocess_Behavior(beh, tsk, option);
        tgame.FileNumber = repmat(gi,size(tgame,1),1);
        game = vertcat(game, tgame);
    end
end
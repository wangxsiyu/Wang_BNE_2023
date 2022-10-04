function out = formatRat_gamebehavior(game, maze)
%     behavior data structure    
%     1. blink start time
%     2. blink end time
%     3. sound time and sound name
%     4. feeder name
%     5. time feed/no feed
    out = game(:,{'filename','date','time', 'trialID', 'releasetime', 'probability', 'delaytime','feeders','drops'});
    ng = height(out); % number of games
%     fd_loc = maze.locationID(maze.isfeeder); % 1-8
    n_fd = size(game.feeders, 2); % max number of simultaneous feeders + sound locations
    fd_list = game.feeder_lists;
    tm_list = game.timestamp_lists;
    lb_list = game.label_lists;
    sd_list = game.sound_lists;
    fds = game.feeders;
    sds = game.soundzone;
    
    % set all timestamps to NaN
    lb_all = unique(W.cell_squeeze({lb_list{:}}));
    for li = 1:length(lb_all)
        out = W.tab_fill(out, ['timestamp_' lb_all{li}], NaN);
    end
    
    for gi = 1:ng
        tfd_list = fd_list(gi,:);
        tlb_list = lb_list(gi,:);
        ttm_list = tm_list(gi,:);
        tsd_list = sd_list(gi,:);
        % get the timestamps, including BlinkStart, BlinkEnd
        for fi = 1:length(tlb_list)
            if ~isempty(tlb_list{fi})
                out.(['timestamp_' tlb_list{fi}])(gi) = ttm_list(fi);
            end
        end        
        % determine the visited feeder
        tefd = tfd_list(~contains(tlb_list, {'BlinkStart','BlinkEnd'}));
%         tefd = cellfun(@(x)x(ismember(x, fd_loc)), tefd, 'UniformOutput', false);
        tfd_visit = unique(horzcat(tefd{:}));
        if length(tfd_visit) > 1
            cprintf('Red', 'visited multiple feeders in a single trial, check\n');
            pause;
        end
        out.choice(gi) = W.extend_nan_fast(tfd_visit,1);
        % determine the associated sound
        tefd = tsd_list(~contains(tlb_list, {'BlinkStart','BlinkEnd'}));
%         tefd = cellfun(@(x)x(~ismember(x, fd_loc)), tefd, 'UniformOutput', false);
        tzone_visit = unique(horzcat(tefd{:}));
        if length(tfd_visit) > 1
            cprintf('Red', 'visited multiple zones in a single trial, check\n');
            pause;
        end
        out.zone(gi) = W.extend_nan_fast(tzone_visit,1);
    end
    tz = out.zone;
    out.sound(tz ~=0) = W.nan_selects(maze.sound, tz(tz ~=0));
    out.sound(tz ==0) = repmat("ignore", sum(tz == 0), 1);
    out = W.tab_squeeze(out);
end
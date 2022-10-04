function game = preprocess_Behavior(beh, tsk, option)
    nmaxG = 12;
    if ~exist('option')
        error('please specify the version first');
    end
    while size(tsk,1) < size(beh, 1)
        tsk = [tsk;tsk];
    end
    switch option
        case {'0135_h1', '0135_h6'}
            idx = tsk.feeders == 7 | tsk.feeders == 9;
            tsk = tsk(~idx,:);
            idx = beh.feeder_blink == 7 | beh.feeder_blink == 9;
            beh = beh(~idx,:);
    end
    game = [];
    hbs = [1 5];
    for hi = 1:length(hbs)
        tfd = mod([hbs(hi) + 3, hbs(hi) - 3], 8);
        tfd(tfd == 0) = 8;
        feeders(hi,:) = [hbs(hi) tfd];
    end
    [fd_hb, fd_target] = parsetrials(tsk.feeders, hbs);
    switch option
        case {'0135_h1','0135_h6'}
            nGplus = min(find(diff(fd_hb) ~= 0));
            nG = nGplus - 1;
            nGuided = sum(fd_target(1:nG) < 10);
            nFree = sum(fd_target(1:nG) >= 10);
%         case {'1235','135old','1234'}
%             nG = min(find(diff(fd_hb) ~= 0));
%             nGuided = sum(fd_target(1:nG) < 10);
%             nFree = sum(fd_target(1:nG) >= 10);
    end
    [fd_hb, fd_target, idx_hb, idx_tar] = parsetrials(beh.feeder_blink, hbs);
    fd_chosen = beh.feeder_feed(idx_tar);
    dp = tsk.drop(find(idx_tar));
    nT = length(fd_chosen);
    nThb = length(fd_hb);
    switch option
        case {'0135_h1','0135_h6'}
            gi = 0;
            while gi * nG < nT
                gi = gi + 1;
                game.date(gi,1) = unique(beh.date);
                game.time(gi,1) = unique(beh.time);
                game.gameID(gi,1) = gi;
                game.releasetime(gi,1) = unique(tsk.rewards);
                game.nGuided(gi,1) = nGuided;
                game.nFree(gi,1) = nFree;
                tidx_hb = ((gi-1)*nGplus + 1): min(((gi-1)*nGplus + nG), nThb);
                tidx = ((gi-1)*nG + 1): min(((gi-1)*nG + nG), nT);
                game.hb(gi,1) = unique(fd_hb(tidx_hb));
                idx_hb_row = find(game.hb(gi) == hbs);
                game.feederID(gi,:) = feeders(idx_hb_row,2:3);
                game.fd(gi,:) = nan_extend(fd_chosen(tidx)', nmaxG);
                game.fd_side(gi,:) = getside(game.fd(gi,:), feeders);
                game.r_side(gi,:) = getdrop(fd_target(tidx(end)), dp(tidx(end)), game.feederID(gi,:));
                game.r(gi,:) = arrayfun(@(x)nan_getarray(game.r_side, [gi, x]), game.fd_side(gi,:));
            end
%         case {'1235','135old','1234'}
%             gi = 0;
%             while gi * nG < nT
%                 gi = gi + 1;
%                 game.date(gi,1) = unique(beh.date);
%                 game.time(gi,1) = unique(beh.time);
%                 game.gameID(gi,1) = gi;
%                 game.releasetime(gi,1) = unique(tsk.rewards);
%                 game.nGuided(gi,1) = nGuided;
%                 game.nFree(gi,1) = nFree;
%                 tidx_hb = ((gi-1)*nG + 1): min(((gi-1)*nG + nG), nThb);
%                 tidx = ((gi-1)*nG + 1): min(((gi-1)*nG + nG), nT);
%                 game.hb(gi,1) = unique(fd_hb(tidx_hb));
%                 idx_hb_row = find(game.hb(gi) == hbs);
%                 game.fds(gi,:) = feeders(idx_hb_row,2:3);
%                 game.fd(gi,:) = tool_extendnan(fd_chosen(tidx)', nG);
%                 game.fd_side(gi,:) = getside(game.fd(gi,:), feeders);
%                 game.r_side(gi,:) = getdrop(fd_target(tidx(end)), dp(tidx(end)), game.fds(gi,:));
%                 game.r(gi,:) = arrayfun(@(x)tool_getarraynan(game.r_side, [gi, x]), game.fd_side(gi,:));
%             end
    end
    if ~isempty(game)
        game = struct2table(game);
        game.version = repmat(string(option), size(game,1),1);
    else
        game = table;
    end
%     game.ishb = ismember(data.feeders, hbs) + 0;
%     game.whichhb = arrayfun(@(y)find(cellfun(@(x)any(ismember(x, y)), feeders)), mod(data.feeders, 10));
%     guided = (~game.ishb & game.feeders < 10) + 0;
%     guided(game.ishb == 1) = NaN;
%     game.guided = guided;
%     for ni = 1:nG
%         gameid((ni-1)*nTperG+1: min(ni*nTperG, ngame)) = ni; 
%     end
%     game.gameID = gameid';
%     game.nlight = (game.feeders > 10) + 1;
%     % drop received
%     reward(game.nlight == 1) = game.drop(game.nlight == 1);
%     reward(game.nlight ~= 1) = arrayfun(@(x)getcorrespondingdrop(game.feeder_blink(x), ...
%         game.drop(x), game.feeder_feed(x)), find(game.nlight ~= 1));
%     reward(game.nofeedlowprob == 1) = 0;
%     game.reward = reward';
%     % side, will only work for 2 lights
%     for gi = 1:nG
%         idxg = game.gameID == gi;
%         tgame = game(idxg,:);
%         hbi = unique(tgame.whichhb);
%         tfders = unique(tgame(tgame.feeders > 10,:).feeders);
%         dpers = unique(tgame(tgame.feeders > 10,:).drop);
%         if length(tfders) > 0
%             tfds = feeders{hbi}(1:2);
%             if mod(diff(tfds),8) > 4
%                 tfds = tfds(end:-1:1);
%             end
%             feeder_L(find(idxg)) = tfds(1);
%             feeder_R(find(idxg)) = tfds(2);
%             drop_L(find(idxg)) = getcorrespondingdrop(tfders, dpers, tfds(1));
%             drop_R(find(idxg)) = getcorrespondingdrop(tfders, dpers, tfds(2));
%         else
%             feeder_L(find(idxg)) = NaN;
%             feeder_R(find(idxg)) = NaN;
%             drop_L(find(idxg)) = NaN;
%             drop_R(find(idxg)) = NaN;
%         end
%     end
%     game.feeder_L = feeder_L';
%     game.feeder_R = feeder_R';
%     game.drop_L = drop_L';
%     game.drop_R = drop_R';
%     cs(game.ishb == 1) = NaN;
%     cs(game.ishb ~= 1) = arrayfun(@(x)func([game.feeder_L(x), game.feeder_R(x)], ...
%         game.feeder_feed(x)), find(game.ishb ~= 1));
%     game.c_side = cs';
%     game.c_big = game.c_side * 0 + (max([game.drop_L game.drop_R]')' == game.reward) - ...
%         (game.drop_L == game.drop_R) * 1.5;
%     game.c_big(game.guided == 1) = NaN;
% end
end
function dp = getdrop(fds, dps, fd0)
    for fi = 1:length(fd0)
        fd = fd0(fi);
        if isnan(fd)
            dp = NaN;
            continue;
        end
        c = strfind(num2str(fds), num2str(fd));
        if isempty(c)
            dp = NaN;
            continue;
        end
        strdps = num2str(dps);
        dp(fi) = str2num(strdps(c));
    end
end
function out =  getside(fd, feeders)
    out = arrayfun(@(x)nan_extend(find(any(feeders == x)),1)  - 1, fd);
end
function [hb, tar, idx_hb, idx_tar] = parsetrials(feeders, hbs)
    idx_hb = ismember(feeders, hbs);
    hb = feeders(idx_hb);
    idx_tar = ~ismember(feeders, hbs);
    tar = feeders(idx_tar);
end
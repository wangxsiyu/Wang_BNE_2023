function out = importRat_preprocess(dat, mazelayout)
    %% replace letters in games to numbers
    [dat.game] = replaceletters(dat.game, mazelayout);
    %% Merged data
    tab = dat.game; tab.filename = []; % tab.feeders_raw = []; tab.drop_raw = [];
    if all(dat.behavior.fileID == tab.fileID) % this  should be the same as behavior.fileID
        tab.fileID = [];
    else
        cprintf('Red', 'Error: fileID mismatch between Game.txt and Behavior.txt');
        pause;
    end
    tab = [dat.behavior tab];
    fdv = dat.behavior.feeder_visit;
    idx = arrayfun(@(x) nan_extend( ...
        find(  arrayfun(@(y)any(fdv(x,:) == y), tab.feeders(x,:))  ) ...
        ,1),  ...
        1:length(fdv)); % can be coded in a neater way.
    tab.fd_choice = arrayfun(@(x) nan_select(tab.feeders(x,:), idx(x)), 1:length(idx))';
%     tab = tab(~(isnan(tab.fd_choice) & ...
%                 ~(ismember(tab.feeder_BlinkStart(:,1), [1 4 6 2 8 5]) & ...
%                 colsum(~isnan(tab.feeder_BlinkStart'))' == 1)) , :); % issue with excluding 0s
    %% determine task version and preprocess
    out = [];
    fileIDs = unique(tab.fileID);
    id15 = arrayfun(@(x)isempty(find(ismember(tab.fd_choice(tab.fileID == x), [1 5]))), fileIDs);    
    fileID_rand = fileIDs(id15 == 1);
    fileID_exploration = fileIDs(id15 == 0);
    if ~isempty(fileID_rand)
        ver = 'Random';
        out.(ver) = tab(ismember(tab.fileID, fileID_rand),:);
        % add basic information
        out.(ver) = [out.(ver) repmat(dat.info, size(out.(ver),1), 1)];
    end
    if ~isempty(fileID_exploration) % horizon game
        ver = 'Exploration';
        out.(ver) = trial2game15(tab(ismember(tab.fileID, fileID_exploration),:));
        % add basic information
        out.(ver) = [out.(ver) repmat(dat.info, size(out.(ver),1), 1)];
    end
end
function out = trial2game15(tab)
    if any(isnan(tab.fd_choice)) % normal routine to deal with NaNs
        % filter out NaNs near the end of a file
        fileIDs = unique(tab.fileID);
        idxlastgame = arrayfun(@(x)max(find(tab.fileID == x)), fileIDs);
        idxfilter = true(height(tab),1);
        for li = 1:length(idxlastgame)
            tlast = idxlastgame(li);
            while tlast >= 1 && isnan(tab.fd_choice(tlast))
                idxfilter(tlast) = false;
                tlast = tlast - 1;
            end
        end
        tab = tab(idxfilter,:);
        % filter out NaNs at the first trial
        idxfirstgame = arrayfun(@(x)min(find(tab.fileID == x)), fileIDs);
        idxfilter = true(height(tab),1);
        for li = 1:length(idxfirstgame)
            tfirst = idxfirstgame(li);
            if isnan(tab.fd_choice(tfirst))
                idxfilter(tfirst) = false;
            end
        end
        tab = tab(idxfilter,:);
        % filter out 9s in the game
        tab = tab(colsum(tab.feeder_BlinkStart' == 9) ~= 1,:);
        % earlier, 7 was the homebase, need to figure that out as well.
        
        % replace NaNs for 1 light trials (guided or homebase) to be the 1
        % light, needs a mark to show that the rat may never visit the
        % feeder
        idxhbnan = find(isnan(tab.fd_choice) & (colsum(~isnan(tab.feeders')) == 1)' & ...
            any(strcmp(tab.label_visit, 'NoFeed')')'); % this is due to escape key likely
        if ~isempty(idxhbnan)
            tab.fd_choice(idxhbnan) = nan_unique_col(tab.feeders(idxhbnan,:)');
        end
        
        % replace NaNs for 1 light trials (guided or homebase) to be the 1
        % light, needs a mark to show that the rat may never visit the
        % feeder
        idxhbnan = find(isnan(tab.fd_choice) & (colsum(~isnan(tab.feeders')) == 1)');
        % not sure what this is ...
        if ~isempty(idxhbnan)
            tab.fd_choice(idxhbnan) = nan_unique_col(tab.feeders(idxhbnan,:)');
            cprintf('Red', 'Warning: not sure what caused the choice to be NaN, label %s\n', tab.label_visit{idxhbnan,1});
        end
        
        % replace NaNs for 2 light trials to be the 0, if it's 'NoFeed',
        % likely an escape key is pressed.
        % needs a mark to show that the rat may never visit the feeder
        idxhbnan = find(isnan(tab.fd_choice) & (colsum(~isnan(tab.feeders')) == 2)' & ...
            any(strcmp(tab.label_visit, 'NoFeed')')');
        if ~isempty(idxhbnan)
            tab.fd_choice(idxhbnan) = 0;
        end
    end
    if any(isnan(tab.fd_choice)) % have NaNs left to be dealt with
        cprintf('Red', 'unknown NaNs in the data, need immediate fix\n');
        pause;
    end
    if ~any(colsum(~isnan(tab.feeders')) == 2) % doesn't exist any choice, likely an incomplete file
        cprintf([1 0.5 0], 'incomplete file containing no choice: %d choices total\n', height(tab));
        out = table;
        return;
    end
    id15 = find(colany(ismember(tab.fd_choice, [1 5])')');
    id15not = find(~colany(ismember(tab.fd_choice, [1 5])')');
    t15 = abs(tab.fd_choice(id15,:));
    if length(nan_unique(t15,0)) == 1 % always the same home base 
        t15not = tab.feeders(id15not,:);
        fID = tab.fileID(id15not);
        tt = any(isnan(t15not)')' + fID * 10000;
        tt = unique([1; find(diff(tt) >= 1)+1; length(tt)+1]);
        tidx = [tt(1:end-1), tt(2:end)-1, tt(2:end) - tt(1:end-1)];
        tidx = tidx(tidx(:,3) > 1, :); % exclude only a single visit (may be 1 feeder visit, in that case, need more work
        ngame = size(tidx,1);
        for i = 1:ngame
            id1(i) = id15not(tidx(i,1))-1;
            id2(i) = id15not(tidx(i,2));
        end
        cond.cond_3light = 0;
        cond.cond_alternatehomebase = 0;
    else % alternate homebase
        fID = tab.fileID(id15);
        tidx = get_consecutives(t15 + fID * 10000);
        tidx = tidx(tidx(:,3) > 1, :); % exclude only a single visit (may be 1 feeder visit, in that case, need more work
        ngame = size(tidx,1);
        for i = 1:ngame
            id1(i) = id15(tidx(i,1));
            id2(i) = id15(tidx(i,2));
            if size(tab.feeders,2) == 3 % 3 light version
                lightexclude = [1 5 9];
                cond.cond_3light = 1;
            else % 2 light version
                lightexclude = [1 3 5 7 9]; % add 3, 7, 9 because in the old version, 7 is used as 9 to start a day
                cond.cond_3light = 0;
            end
            if id2(i) < size(tab,1) && ~colany(ismember(tab.fd_choice(id2(i)+1), lightexclude))
                id2(i) = id2(i) + 1;
            else
                id2(i) = id2(i) - 1;
            end
        end
        cond.cond_alternatehomebase = 1;
    end
    if ngame == 0
        out = table;
        return;
    end
    maxT = ceil(max(id2-id1 + 1)/2);
    out = repmat(struct2table(cond),ngame,1);
    var_timestamp = tab.Properties.VariableNames(contains(tab.Properties.VariableNames, 'timestamp'));
    for i = 1:ngame
        out.homebase(i) = unique(t15(tidx(i,1):tidx(i,2)));
        te = tab(id1(i):id2(i),:);
        teh = te(colany(ismember(te.fd_choice, out.homebase(i))')',:);
        te = te(~colany(ismember(te.fd_choice, out.homebase(i))')',:);
        % save homebase information
        for j = 1:length(var_timestamp)
            out.([var_timestamp{j} '_homebase'])(i,:) = nan_extend(teh.(var_timestamp{j})(:,1)', maxT);
        end
        out.releasetime_homebase(i) = nan_unique(teh.releasetime);
        
        % save choice information
        isguided = (colsum(~isnan(te.feeders')) == 1) + 0;
        out.isguided(i,:) = nan_extend(isguided, maxT);
        if any(isguided == 0) % has free choices
            out.feeders(i,:) = [nan_unique_col(te.feeders(isguided == 0,:))];
            out.drop(i,:) = [nan_unique_col(te.drop(isguided == 0,:))];
        else % needs more work, for now, ignore incomplete trials
            out.feeders(i,:) = [NaN(1,cond.cond_3light+2)];%[nan_unique(te.feeders(isguided == 1,1),1) ...
                %nan_unique(te.feeders(isguided == 1,2),1)];
            out.drop(i,:) = [NaN(1,cond.cond_3light+2)];%[nan_unique(te.drop(isguided == 1,1),1) ...
                %nan_unique(te.drop(isguided == 1,2),1)];
        end
        out.choice(i,:) = nan_extend(te.fd_choice', maxT);
        for j = 1:length(var_timestamp)
            out.([var_timestamp{j} '_choice'])(i,:) = nan_extend(te.(var_timestamp{j})(:,1)', maxT);
        end
        if any(isguided == 0)
            out.releasetime_free(i) = nan_unique(te.releasetime(isguided == 0));
            out.drop_homebase_free(i) = nan_unique(teh.drop(isguided == 0), 0);
            out.probability_homebase_free(i) = unique(teh.probability(isguided == 0));
        else
            out.releasetime_free(i) = NaN;
            out.drop_homebase_free(i) = NaN;
            out.probability_homebase_free(i) = NaN;
        end
        if any(isguided == 1)
            out.drop_homebase_guided(i) = nan_unique(teh.drop(isguided == 1), 0);
            out.probability_homebase_guided(i) = nan_unique(teh.probability(isguided == 1),0);
        else
            out.drop_homebase_guided(i) = NaN;
            out.probability_homebase_guided(i) = NaN;
        end
        out.releasetime_guided(i) = nan_unique(te.releasetime(isguided == 1));
        
        % basic information
        out.date_start(i) = unique(te.date);
        out.time_start(i) = unique(te.time);
       
        out.probability(i) = unique(te.probability);
        out.delaytime(i) = unique(te.delaytime);
        out.fileID(i,:) = unique(te.fileID');
    end
end
function game = replaceletters(game, mazelayout)
    if isempty(game)
        return;
    end
    maxlen = max(cellfun(@(x) length(x), game.feeders));
    te = cellfun(@(x)nan_extend( ...
        arrayfun(@(y)mazelayout.locationID(strcmp(mazelayout.letter,y), :), x),  ...
        maxlen), ...
        game.feeders, 'UniformOutput', false);
    game.feeders_raw = vertcat(te{:});
    tdp = cellfun(@(x)nan_extend(arrayfun(@(y)str2num(y), x),maxlen), game.drop, 'UniformOutput', false);
    game.drop_raw = vertcat(tdp{:});
    ng = size(game,1);
    % any feeder ID < 0 means that it's a sound not a location
    idxfd = arrayfun(@(x)find(game.feeders_raw(x,:) > 0), 1:ng, 'UniformOutput', false);
    maxlen = max(cellfun(@(x) length(x), idxfd));
    te = arrayfun(@(x)nan_extend( ...
        game.feeders_raw(x, idxfd{x}),  ...
        maxlen), ...
        1:ng, 'UniformOutput', false);
    game.feeders = vertcat(te{:});
    te = arrayfun(@(x)nan_extend( ...
        game.drop_raw(x, idxfd{x}),  ...
        maxlen), ...
        1:ng, 'UniformOutput', false);
    game.drop = vertcat(te{:});
end
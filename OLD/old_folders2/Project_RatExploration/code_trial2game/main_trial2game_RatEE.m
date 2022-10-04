%% load trials
data = readtable('../data_behavior_RatExploration/raw_RatEE.csv');
data = W.tab_autofieldcombine(data);
data.is37 = sum(ismember(data.feeders,[3 7])')';
data.homebase15 = all((ismember(data.feeders,[1 4 6]) | isnan(data.feeders))')' + ...
    all((ismember(data.feeders,[2 5 8]) | isnan(data.feeders))')' * 2;
data.n_lights = sum(~isnan(data.feeders)')';
data.releasetime = data.feeders*0 + data.releasetime;
rats = unique(data.rat);
isoverwrite = false;
%% 
if ~exist('../data_behavior_RatExploration/info_RatEE.csv', 'file') || isoverwrite
    %% get all sessions
    sessions = W_sub.selectsubject(data, {'foldername', 'filename'});
    % get basic session info
    info = W_sub.tab_unique(data, sessions);
    % calculate tm for info
    td = string(info.date);
    tt = info.time;
    tt = W.extend_strings(string(tt), 6, '0', 'left', 'right');
    info.str_date = td;
    info.str_time = tt;
    tm = datetime(strcat(td, 'T', tt));
    info.datetime = tm;
    %% for guided trials, fix NaNs (umm, if the feeder is skipped it should be noted, so remove this fix)
    % tchoice = data.choice;
    % tid = sum(~isnan(data.feeders'))'==1 & isnan(tchoice);
    % tchoice(tid) = W.col_unique(data.feeders(tid,:)', 0)';
    %% automatically determine game type
    tp = "";
    for si = 1:length(sessions)
        disp(sprintf('determine trial type %d: %d', si, length(sessions)));
        tdata = data(sessions{si},:);
        idx2 = tdata.n_lights;
        if all(idx2 <= 1)
            tp(si) = "random";
            % it could be that in early days, there are sessions with homebase
            % but only 1 light (will not affect main analysis)
        elseif any(idx2 >= 3) && mean(idx2 >= 3) >= 0.5
            tp(si) = "early_multi_lights";
        elseif any(idx2 == 3)
            tp(si) = "ee_3lights";
        elseif mean(idx2 == 2) > 0.7
            tp(si) = "early_2lights";
        elseif sum(tdata.is37) > 3 % 7 is the escape for earlier versions
            tp(si) = 'ee_randhb';
        elseif all(ismember([1 2], tdata.homebase15(idx2 == 1)))
            tp(si) = "ee_alterhb";
        else
            tp(si) = "ee_samehb";
        end
        disp(sprintf('... type - %s', tp(si)));
    end
    disp(sprintf('Unclassified percentage %.2f%%', mean(tp == "")*100));
    info.version = W.vert(tp);
    %% save info
    writetable(info, '../data_behavior_RatExploration/info_RatEE.csv');
else
    %% load info
    info = readtable('../data_behavior_RatExploration/info_RatEE.csv');
end
%% exclude sessions with very few trials (did not implement here)
% figure, hist(info.n_games, 100)
%% load existing games.csv
infos = string(fullfile(info.foldername, info.filename));
if exist('../data_behavior_RatExploration/games_EE.csv') && ~isoverwrite
    g0 = readtable('../data_behavior_RatExploration/games_EE.csv');
    games = W.tab_autofieldcombine(g0);
    gs = unique(string(fullfile(games.foldername,games.filename)));
    slists = find(arrayfun(@(x)~any(gs == x), infos));
else
    games = table;
    slists = 1:length(infos);
end
%% import based on condition
errorlist = [];
for i = 1:length(slists)
    si = slists(i);
    cond = string(info.version(si));
    disp(sprintf('trial2game %d/%d: %s', i, length(slists), cond));
    game = table;
    tinfo = info(si,:);
    switch cond
        case {'ee_alterhb', 'ee_3lights'} 
            strfunc = strcat('trial2game_', cond);
            tfunc = str2func(strfunc);
        case {'ee_samehb','ee_randhb'}
            tfunc = []; % these 2 need to be implemented
        case {'random','early_2lights','early_multi_lights'}
            tfunc = [];
        otherwise
            error('unknown version');
    end
%     try
        if ~isempty(tfunc)
            tic
            tidx = strcmp(data.foldername, tinfo.foldername) & strcmp(data.filename, tinfo.filename);
            d = data(tidx,:);
            d = W.tab_squeeze(d);
            % ----------
            % preprocess
            % delete esc key （usually 9 in front, in early days, it's 7)
            c1 = W.unique(W.vert(d.feeders(1,:)),0);
            if length(c1) == 1 && ...
                    (ismember(c1, [9 7]) || isnan(c1))
                d = d(2:end,:);
            end
            % delete NaN choices at the end
            while ~isempty(d) && isnan(d.choice(end))
                d = d(1:end-1,:);
            end
            if isempty(d)
                continue;
            end
            
            % ----------
            
            ttab = tfunc(d);
            game = W.tab_fill(ttab, tinfo);
            games = W.tab_vertcat(games, game);
            toc
        else
%             errorlist(end+1) = si;
        end
%     catch
%         errorlist(end+1) = si;
%         warning('Needs check, running error');
%     end
end
slists = errorlist;
disp('Complete');
%% needs check
% 341 - homebase is 7
%% save
writetable(games, '../data_behavior_RatExploration/games_EE.csv');
%% bug
% Earlier, maybe Hachi and Tianqi did versions that 
% guide - free - guide - free repeat more than once, 
% the current code combines those separated guide/free periods

% %% determine conditions
% id_tm = W.find_intervals(version.data, tm);
% id_row = W.arrayfun(@(x)W.iif_empty(id_tm{x}(find(strcmp(version.rat(id_tm{x}), info.rat{x}))),NaN), 1:height(info));
% info.version = W.vert(W.arrayfun(@(x)W.nan_selects(version.name, id_row(x)), 1:height(info)));

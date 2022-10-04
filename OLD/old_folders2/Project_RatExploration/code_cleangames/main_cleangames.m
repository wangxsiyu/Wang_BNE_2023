%% load data
data = readtable('../data_behavior_RatExploration/games_EE.csv');
data = W.tab_autofieldcombine(data);
data.homebase15 = all((ismember(data.feeders,[1 4 6]) | isnan(data.feeders))')' + ...
    all((ismember(data.feeders,[2 5 8]) | isnan(data.feeders))')' * 2;
%% deal with n_guided = 0,1,3 
% idx = data.n_guided <= 3;
% data = data(idx,:);
% data = W.tab_squeeze(data);
%% get ee_alterhb only - deal with all
% data = data(strcmp(data.version, 'ee_alterhb'),:);
% % THIS IS HARD CODE, REMOVE IT %% include only n_guided == 0,1,3
% gf = [data.n_guided, data.n_free];
% id = ismember(gf,[3 6;3 1; 1 6; 1 1; 0 7; 0 2],'rows');
% data = data(id, :);
%%
sessions = W_sub.selectsubject(data, {'foldername','filename'});
%% select games that have more than 2 games:
sessions = sessions(cellfun(@(x)length(x), sessions) > 2);
%% 
info = W_sub.tab_unique(data, sessions);
%% get task condition
d = table;
for si = 1:length(sessions)
    disp(sprintf('processing %d/%d', si, length(sessions)));
    td = data(sessions{si},:);
    % already excluded cases where ngame <= 2
    %% hard code - exclude (3,4) in (3,15) :
    if all(td.folderdate == 102620 & strcmp(td.filename, 'Game1') & strcmp(td.rat, 'Twenty'))
        td = td(nanmean(td.drop')' > 0,:);
    end
    %% check consistency
    nlast = size(td, 1) - 1;
      
    cons1 = unique([td.n_guided(1:nlast) td.homebase15(1:nlast)], 'rows');
    if size(cons1,1) > 2 || (size(cons1,1) == 2 && length(unique(cons1(:,2))) == 1)
        disp(cons1)
        info.is_consistent_nguided(si) = 0;
    else
        info.is_consistent_nguided(si) = 1;
    end
%     data.is_consistent_nguided(sessions{si}) = repmat(info.is_consistent_nguided(si), length(sessions{si}), 1);

    
    cons1 = unique([td.n_free(1:nlast) td.homebase15(1:nlast)], 'rows');
    if size(cons1,1) > 2 || (size(cons1,1) == 2 && length(unique(cons1(:,2))) == 1)
        disp(cons1)
        info.is_consistent_nfree(si) = 0;
    else
        info.is_consistent_nfree(si) = 1;
    end
%     data.is_consistent_nfree(sessions{si}) = repmat(info.is_consistent_nfree(si), length(sessions{si}), 1);

    
    cons1 = unique([td.n_guided(1:nlast)+td.n_free(1:nlast) td.homebase15(1:nlast)], 'rows');
    if size(cons1,1) > 2 || (size(cons1,1) == 2 && length(unique(cons1(:,2))) == 1)
        disp(cons1)
        info.is_consistent_ntotal(si) = 0;
    else
        info.is_consistent_ntotal(si) = 1;
    end
%     data.is_consistent_ntotal(sessions{si}) = repmat(info.is_consistent_ntotal(si), length(sessions{si}), 1);
    %% remove incomplete last game
    idx_hb = find(td.homebase15(1:nlast) == td.homebase15(nlast+1));
    if ~any((td.n_guided(idx_hb) == td.n_guided(nlast+1)) & (td.n_free(idx_hb) == td.n_free(nlast+1)))
        td = td(1:end-1, :);
    end
    %% check games with no free choices (should be none)
    idx_free0 = td.n_free == 0;
    if any(idx_free0(1:end))
        warning('no free choices in the game, check now');
    end
    %% 
%     id = W.unique_count(td.is_guided,'rows');
%     id1 = id.num == 1;
%     if length(id1) > 1 && sum(id1) == 1 && all(id.num(~id1) >=2)
%         id = id(~id1,:);
%     end
%     ng = unique(nansum(id.val, 2)');
%     nf = unique(nansum(id.val == 0, 2)');
    info.guidefree{si} = unique([td.n_guided td.n_free], 'rows');
    info.is_3lights(si) = any(all(~isnan(td.feeders)'));
%     data.is_3lights(sessions{si}) = repmat(info.is_3lights(si), length(sessions{si}), 1);
%     if contains(td.foldername, 'Exploration_Gerald/RawData/041521')
%         warning('test selected dataset');
%     end
    info.is_random(si) =  any(all(isnan(td.drop)'));
%     data.is_random(sessions{si}) = repmat(info.is_random(si), length(sessions{si}), 1);
    info.str_guidefree(si) = string(sprintf('(%d,%d)', info.guidefree{si}'));
%     if size(info.guidefree{si},1)
%         data.condition(sessions{si}) = "samehorizon";
%         info.condition(si) = "samehorizon";
%     elseif length(info.n_guided{si}) == 1 && length(info.n_free{si}) == 2
%         data.condition(sessions{si}) = "within";
%         info.condition(si) = "within";
%     elseif length(info.n_guided{si}) == 3 && length(info.n_free{si}) == 4
%         data.condition(sessions{si}) = "all013_1267";
%         info.condition(si) = "all013_1267";
%     end
    if isempty(td)
        warning('check');
    end
    d = W.tab_vertcat(d, td);
end
% info = W.tab_squeeze(info);
%%
writetable(d, '../data_behavior_RatExploration/cleaned_games_EE.csv');
writetable(info, '../data_behavior_RatExploration/cleaned_info_EE.csv');
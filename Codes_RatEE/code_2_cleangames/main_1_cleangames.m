%% load data
data = readtable('../../data_processed/compiled/games_EE.csv');
data = W.tab_autofieldcombine(data);
data.homebase15 = all((ismember(data.feeders,[1 4 6]) | isnan(data.feeders))')' + ...
    all((ismember(data.feeders,[2 5 8]) | isnan(data.feeders))')' * 2;
data = W_sub.add_gameID(data, {'foldername', 'filename'});
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
        %td = td(nanmean(td.drop')' > 0,:);
        td.n_free(:,1) = max(td.n_free);
    end
    %% hard code - exclude (3,11) in (3,15) :
    if all(td.folderdate == 102720 & strcmp(td.filename, 'Game1') & strcmp(td.rat, 'Twenty'))
%         td = td(td.n_free == 15, :);
        td.n_free(:,1) = max(td.n_free);
    end
    %% check consistency
    nlast = size(td, 1) - 1;
      
    cons1 = unique([td.n_guided(1:nlast) td.homebase15(1:nlast)], 'rows');
    if size(cons1,1) > 2 || (size(cons1,1) == 2 && length(unique(cons1(:,2))) == 1)
        disp(cons1)
        info.is_consistent_nguided(si) = 0;
        td.is_consistent_nguided(:,1) = 0;
    else
        info.is_consistent_nguided(si) = 1;
        td.is_consistent_nguided(:,1) = 1;
    end
%     data.is_consistent_nguided(sessions{si}) = repmat(info.is_consistent_nguided(si), length(sessions{si}), 1);

    
    cons1 = unique([td.n_free(1:nlast) td.homebase15(1:nlast)], 'rows');
    if size(cons1,1) > 2 || (size(cons1,1) == 2 && length(unique(cons1(:,2))) == 1)
        disp(cons1)
        info.is_consistent_nfree(si) = 0;
        td.is_consistent_nfree(:,1) = 0;
    else
        info.is_consistent_nfree(si) = 1;
        td.is_consistent_nfree(:,1) = 1;
    end
%     data.is_consistent_nfree(sessions{si}) = repmat(info.is_consistent_nfree(si), length(sessions{si}), 1);

    
    cons1 = unique([td.n_guided(1:nlast)+td.n_free(1:nlast) td.homebase15(1:nlast)], 'rows');
    if size(cons1,1) > 2 || (size(cons1,1) == 2 && length(unique(cons1(:,2))) == 1)
        disp(cons1)
        info.is_consistent_ntotal(si) = 0;
        td.is_consistent_ntotal(:,1) = 0;
    else
        info.is_consistent_ntotal(si) = 1;
        td.is_consistent_ntotal(:,1) = 1;
    end
%     data.is_consistent_ntotal(sessions{si}) = repmat(info.is_consistent_ntotal(si), length(sessions{si}), 1);
    %% check games with no free choices (should be none)
    idx_free0 = td.n_free == 0;
    if any(idx_free0(1:end))
        warning('no free choices in the game, check now');
    end
    %% remove incomplete last game
    idx_hb = find(td.homebase15(1:nlast) == td.homebase15(nlast+1));
    if ~any((td.n_guided(idx_hb) == td.n_guided(nlast+1)) & (td.n_free(idx_hb) == td.n_free(nlast+1)))
        tlast = td(end, :);
        td = td(1:end-1, :);
    else
        tlast = [];
    end
    %% check if is random horizon
    info.is_randomhorizon(si) = length(unique(td.n_free)) >= 2 && ...
        ~(length(unique(td.n_free(1:2:end))) == 1 && ...
            length(unique(td.n_free(2:2:end))) == 1);
    %% check if is random guided
    info.is_randomguided(si) = length(unique(td.n_guided)) >= 2 && ...
        ~(length(unique(td.n_guided(1:2:end))) == 1 && ...
            length(unique(td.n_guided(2:2:end))) == 1);
    %% add last game in
    if ~isempty(tlast) && size(td,1) >= 2
        tflag = false;
        if  ~info.is_randomhorizon(si) && ~info.is_randomguided(si)
            if td((end-1),:).n_free < tlast.n_free || td((end-1),:).n_guided < tlast.n_guided
                error('check: horizon error');
            else
                tlast.n_free = td(end-1,:).n_free;
                tlast.n_guided = td(end-1,:).n_guided;
                tflag = true;
            end
        elseif length(unique(td.n_free)) == 2 && tlast.n_free > min(td.n_free)
            if tlast.n_free >= max(td.n_free)
                error('check: horizon error');
            else
                tlast.n_free = max(td.n_free);
                tflag = true;
            end
        else
            tid = td.n_guided == tlast.n_guided;
            if length(unique(td.n_free(tid))) == 2 && tlast.n_free > min(td.n_free(tid))
                tlast.n_free = max(td.n_free(tid));
                tflag = true;
            end
        end
        if tflag
            td = vertcat(td, tlast);
        else
            warning('last game discarded');
            disp(vertcat(td, tlast));
        end
         % strcmp(unique(td.version), 'ee_alterhb')
            %         tflag = false;
            %         if size(td,1) >= 2 && ~info.is_randomhorizon(si)
            %             if td((end-1),:).n_free < tlast.n_free % max(td((end-1):-2:1,:).n_free) < tlast.n_free
            %                 error('check: horizon error');
            %             else
            %                 tlast.n_free = td(end-1,:).n_free;
            %                 tflag = true;
            %             end
            %         end
            %         if size(td,1) >= 2 && ~info.is_randomguided(si)
            %             if td((end-1),:).n_guided < tlast.n_guided %max(td((end-1):-2:1,:).n_guided) < tlast.n_guided
            %                 error('check: horizon error');
            %             else
            %                 tlast.n_guided = td(end-1,:).n_guided;
            %                 tflag = true;
            %             end
            %         end
            %         if tflag
            %             td = vertcat(td, tlast);
            %         end
   end
    %% 
%     id = W.unique_count(td.is_guided,'rows');
%     id1 = id.num == 1;
%     if length(id1) > 1 && sum(id1) == 1 && all(id.num(~id1) >=2)
%         id = id(~id1,:);
%     end
%     ng = unique(nansum(id.val, 2)');
%     nf = unique(nansum(id.val == 0, 2)');
    td.is_randomhorizon(:,1) = info.is_randomhorizon(si);
    td.is_randomguided(:,1) = info.is_randomguided(si);
    info.guidefree{si} = unique([td.n_guided td.n_free], 'rows');
    info.is_3lights(si) = any(all(~isnan(td.feeders)'));
    td.is_3lights(:,1) = any(all(~isnan(td.feeders)'));
%     data.is_3lights(sessions{si}) = repmat(info.is_3lights(si), length(sessions{si}), 1);
%     if contains(td.foldername, 'Exploration_Gerald/RawData/041521')
%         warning('test selected dataset');
%     end
    info.is_random(si) =  any(all(isnan(td.drop)'));
    td.is_random(:,1) = any(all(isnan(td.drop)'));
%     data.is_random(sessions{si}) = repmat(info.is_random(si), length(sessions{si}), 1);
    info.str_guidefree(si) = string(sprintf('(%d,%d)', info.guidefree{si}'));
    td.str_guidefree(:,1) = string(sprintf('(%d,%d)', info.guidefree{si}'));
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
if ~exist('../../data_processed/cleaned')
    mkdir('../../data_processed/cleaned');
end
writetable(d, '../../data_processed/cleaned/cleaned_games_EE.csv');
writetable(info, '../../data_processed/cleaned/cleaned_info_EE.csv');
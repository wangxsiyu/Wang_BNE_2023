classdef W_sub < handle
    properties
    end
    methods(Static)
        function str = tab_jointcondition(tab, fds, sep)
            % this is to compute a combined condition by treating
            % everything as strings
            if ~exist('sep') || isempty(sep)
                sep = ', ';
            end
            if ~exist('fds') || isempty(fds)
                fds = tab.Properties.VariableNames;
            end
            fds = W_basic.encell(fds);
            n = length(fds);
            for i = 1:n
                te = tab.(fds{i});
                if isnumeric(te) % deal with NaNs - string(NaN) = <missing>.
                    te = W_basic.arrayfun(@(x)(num2str(x)), te);
                end
                te = string(te);
                if contains(sep, ',')
                    te = replace(te, ',', '.');
                end
                if i == 1
                    str = te;
                else
                    str = strcat(str, sep, te);
                end
            end

        end
        function [rowid, tab] = selectsubject(data, cond_fds)
            cond = W_sub.tab_jointcondition(data, cond_fds);
            conds = W_basic.vert(unique(cond, 'stable'));
            tab = table;
            tab.condition = W_basic.str_csv2cell(conds);
            tab = splitvars(tab, 'condition', 'NewVariableNames', cond_fds);
            for i = 1:length(conds)
                rowid{i} = find(strcmp(cond, conds{i}));
            end
            rowid = W_basic.vert(rowid);
        end
        function [subtab, sub] = tab_unique(data, idxsub)
            if ~exist('idxsub') || isempty(idxsub)
                idxsub = {1:size(data,1)};
            end
            idxsub = W_basic.encell(idxsub);
            fs = data.Properties.VariableNames;
            for fi = 1:length(fs)
                for si = 1:length(idxsub)
                    lines = idxsub{si};
                    td = data.(fs{fi})(lines,:);
                    te = W_basic.unique(td, 'rows');
                    if size(te,1) == 1
                        flag_uniq(fi) = 1;
                    else
                        flag_uniq(fi) = 0;
                        break;
                    end
                end
            end
            for si = 1:length(idxsub)
                lines = idxsub{si};
                for fi = find(flag_uniq)
                    td = data.(fs{fi})(lines,:);
                    sub(si).(fs{fi}) = W_basic.unique(td, 'rows');
                end
                sub(si).n_games = length(lines);
            end
            subtab = struct2table(sub);
        end
        function [subtab, sub] = tab_trial2game(data, idxsub)
            if ~exist('idxsub') || isempty(idxsub)
                idxsub = {1:size(data,1)};
            end
            [~,sub] = W_sub.tab_unique(data, idxsub);
            fs = data.Properties.VariableNames;
            fs = setdiff(fs, fieldnames(sub));
            for fi = 1:length(fs)
                for si = 1:length(idxsub)
                    lines = idxsub{si};
                    td = data.(fs{fi})(lines,:);
                    if size(td,2) == 1
                        flag(fi) = 1;
                    else
                        flag(fi) = 0;
                        break;
                    end
                end
            end
            MT = max(cellfun(@(x)length(x), idxsub));
            for si = 1:length(idxsub)
                lines = idxsub{si};
                for fi = find(flag)
                    td = data.(fs{fi})(lines,:);
                    sub(si).(fs{fi}) = W_basic.extend(td', MT);
                end
            end
            subtab = struct2table(sub);
        end
        function games = preprocess_subxgame(games, rowid, funclist)
            funclist = W_basic.encell(funclist);
            n_sub = length(rowid);
            n_trials = cellfun(@(x)repmat(length(x),length(x),1), rowid, 'UniformOutput', false);
            games.n_trials = vertcat(n_trials{:});
            for oi = 1:length(funclist)
                tfunc = funclist{oi};
                if ischar(tfunc) || isstring(tfunc)
                    tfunc = str2func(tfunc);
                end
                try
                    disp(sprintf('preprocess subxgame %s...', funclist{oi}));
                catch
                    disp('??? catch: check...');
                end
                clear tsub
                sub = table;
                for si = 1:n_sub
                    disp(sprintf('    ...processing subject %d/%d', si, n_sub));
                    te = tfunc(games(rowid{si},:));
                    if isstruct(te)
                        tsub = struct2table(te);
                    else
                        tsub = te;
                    end
                    sub = W.tab_vertcat(sub, tsub);
                end
                games = sub;
%                 games = W.tab_horzcat(games, sub);
            end
            disp('complete preprocessing(subject dependent)');
        end
        function [sub] = analysis_sub(games, idxsub, funclist)
            if ~exist('funclist')
                error('please specify function to run');
                sub = [];
                return;
            end
            if ~exist('param')
                param = [];
            end
            funclist = W_basic.encell(funclist);
            games = W_basic.tab_autofieldcombine(games);
            if ~exist('idxsub') || isempty(idxsub)
                idxsub = {1:size(games,1)};
            end
            n_sub = length(idxsub);
            [~, sub] = W_sub.tab_unique(games, idxsub);
            for oi = 1:length(funclist)
                tfunc = funclist{oi};
                if ischar(tfunc) || isstring(tfunc)
                    tfunc = str2func(tfunc);
                end
                try
                    disp(sprintf('analysis %s...', funclist{oi}));
                catch
                    disp('analysis function...');
                end
                clear tsub
                for si = 1:n_sub
                    disp(sprintf('    ...processing subject %d/%d', si, n_sub));
%                     try 
                    tsub(si) = tfunc(games(idxsub{si},:));
%                     catch
%                         disp('error in subject');
%                         tsub(si) = struct;
%                     end
                end
                sub = catstruct(sub, tsub);
            end
            sub = struct2table(sub,'AsArray', true);
            sub = W.tab_squeeze(sub);
        end
        function gp = analysis_group(sub, cond_fds, varargin)
            [idx, tab] = W_sub.selectsubject(sub, cond_fds);
            gp = table;
            gp.group_analysis = tab;
            tgp = table;
            for  ii = 1:length(idx)
                te = W_sub.analysis_1group(sub(idx{ii},:), varargin{:});
                tgp = W_basic.tab_vertcat(tgp, te);
            end
            gp = [gp tgp];
        end
        function gp = analysis_1group(sub, switch_paircompare, additional_compare)
            if ~exist('switch_paircompare') || isempty(switch_paircompare)
                switch_paircompare = true;
            end
            if ~exist('additional_compare') || isempty(additional_compare)
                additional_compare = [];
            end
            gp = [];
            sub = W_basic.tab_autofieldcombine(sub);
            fnms = sub.Properties.VariableNames;
            for fi = 1:length(fnms) % ex. regular av/se
                fn = fnms{fi};
                td = sub.(fn);
                if isnumeric(td) || islogical(td)
                    [gp.(['av_' fn]), gp.(['ste_' fn])] = W_tools.avse(td);
                    % pvalue of pairs
                    if switch_paircompare && size(td,2) == 2
                        [~,gp.(['pvalue_' fn]), ~, tstat] = ttest(diff(td')');
%                         gp.(['cohen_d_' fn]) =  computeCohen_d(td(:,1), td(:,2), 'paired');
                        gp.(['tstat_' fn]) = tstat.tstat;
                    end
                elseif (iscell(td) && all(cellfun(@(x)isnumeric(x) || islogical(x), td), 'all'))
                    for tyi = 1:size(td,2)
                        [nx, ny] = size(td{1,tyi});
                        issamesz = cellfun(@(x) size(x,1) == nx && size(x,2) == ny, td(:, tyi));
                        if any(~issamesz)
                            warning(sprintf('ignored %s, cells of different size', fn));
                            continue;
                        end
                        for nxi = 1:nx
                            for nyi = 1:ny
                                te = cellfun(@(x)x(nxi,nyi), td(:, tyi));
%                                 if size(td,2) > 1
                                    [gp.(['av_' fn]){tyi}(nxi, nyi), gp.(['ste_' fn]){tyi}(nxi, nyi)] = W_tools.avse(te);
%                                 else
%                                     [gp.(['av_' fn])(nxi, nyi), gp.(['ste_' fn])(nxi, nyi)] = W_tools.avse(te);
%                                 end
                            end
                        end
                    end
                elseif size(W_basic.unique(td, 'rows'),1) == 1 % all elements are the same
                    gp.(fn) = W_basic.unique(td, 'rows');
                elseif ~any(strcmp(fn, {'filename','time','comment','csv_filename','SubjectID'}))
                    warning(sprintf('ignored %s, format not supported', fn));
                end
            end

            for ai = 1:length(additional_compare) % ex. _h1 vs _h6
                tfn = W.encell(additional_compare{ai});
                tds =  cellfun(@(x)sub.(x), tfn, 'UniformOutput', false);
                isnums =  cellfun(@(x)isnumeric(x) | islogical(x), tds);
                if ~all(isnums)
                    continue;
                end
                if length(tds) == 2
                    tpval = [];
                    tstat = [];
                    for ci = 1:size(tds{1},2)
                        [~, tpval(ci), ~, tt] = ttest(tds{2}(:,ci) - tds{1}(:,ci));
                        tstat(ci) = tt.tstat;
                    end
                    gp.(['pvalue_', strjoin(tfn,'_vs_')]) = tpval;
                    gp.(['tstat_', strjoin(tfn,'_vs_')]) = tstat;
                elseif length(tds) == 1
                    tds = tds{1};
                    tpval = [];
                    tstat = [];
                    for ci = 1:size(tds,2)
                        [~, tpval(ci), ~, tt] = ttest(tds(:,ci));
                        tstat(ci) = tt.tstat;
                    end
                    gp.(['pvalue_', tfn{1},'_vs0']) = tpval;
                    gp.(['tstat_', tfn{1},'_vs0']) = tstat;
                else
                    warning('ANOVA has not been implemented here, to be done');
                end
            end
            gp = struct2table(gp);
            gp.n_subject = size(sub,1);
        end
        function g = add_gameID(g, idx)
            if ischar(idx) || ischar(idx{1})
                idx = W_sub.selectsubject(g, idx);
            end
            gameID = W.cellfun(@(x)1:length(x), idx);
            g.gameID = [gameID{:}]';
            gameID_rev = W.cellfun(@(x)length(x):-1:1, idx);
            g.gameID_rev = [gameID_rev{:}]';
            gameID = W.cellfun(@(x)[1:length(x)]/length(x), idx);
            g.gameID_perc = [gameID{:}]';
        end
        function tab = display_conditions(data, cond_fds, sub_fds, iscomma)
            % cond_fds - conditions
            % sub_fds - subject
            if ~exist('iscomma') || isempty(iscomma)
                iscomma = 0;
            end
            if ~exist('sub_fds') || isempty(sub_fds)
                subs = W.arrayfun(@(x)string(num2str(x)), 1:size(data,1));
            else
                subs = W_sub.tab_jointcondition(data, sub_fds);
            end
            cond = W_sub.tab_jointcondition(data, cond_fds);
            conds = unique(cond);
            tab = table;
            if ~iscomma
                tab.condition = W_basic.str_csv2cell(conds);
                tab = splitvars(tab, 'condition', 'NewVariableNames', cond_fds);
            else
                tab.condition = conds;
            end
            nt = cellfun(@(x)sum(strcmp(x, cond)), conds);
            tab.n_subject = cellfun(@(x)length(unique(subs(strcmp(x, cond)))), conds);
            tab.n_trial = nt./tab.n_subject;
            tab.n_total = nt;
            tab.perc_total = nt/sum(nt) * 100;
        end
        function info = getversion(info, version)
            id_tm = W_tools.find_intervals([version.d1 version.d2], info.datetime);
            version.animal = string(version.animal);
            version.version = string(version.version);
            info.animal = string(info.animal);
            %             if iscell(id_tm)
            %                 id_tm = W.arrayfun(@(x) ...
            %                     W.iif_empty(id_tm{x}(...
            %                     find(strcmp(version.animal(id_tm{x}), info.animal(x))) ...
            %                     ),NaN), 1:height(info));
            %             end
            info.version = W.vert(W.arrayfun(@(x)W.nan_select(version.version, id_tm(x)), 1:height(info)));
        end
        function tab = event_trial2game(event, time, mks, mkignore, opt_repeat)
            if exist('opt_repeat') && ~isempty(opt_repeat) && opt_repeat == 1
                [event, x] = W.derepeat(event);
                if length(x) < length(time)
                    time = W.cellfun(@(x)mean(time(x)), x);
                end
            end
            if ~exist('mkignore')
                mkignore = [];
            end
            i = 1;
            mi = 1;
            nm = length(mks);
            c = 1;
            mka = horzcat(mks{:});
            x = NaN(1,nm);
            tm = NaN(1,nm);
            extra = [];
            raw = [];
            tab.extra{1} = [];
            while (i <= length(event))
                tev = event(i);
                raw = [raw tev];
                if ismember(tev, mkignore)
                    i = i + 1;
                    continue;
                end
                if ~ismember(tev, mka) % event not recognized
                    extra(end+1,:) = [tev mi];
                    i = i + 1;
                    continue;
                end
                while mi <= nm && ~ismember(tev, mks{mi})
                    mi = mi + 1;
                end
                if mi <= nm % found
                    x(c, mi) = event(i);
                    tm(c, mi) = time(i);
                    mi = mi + 1;
                    if mi > nm && i < length(event) && ~all(ismember(event(i+1:end), mkignore))
                        tab.raw{c,1} = raw;
                        tab.extra{c,1} = extra;
                        extra = [];
                        raw = [];
                        mi = 1;
                        c = c + 1;
                        x(c, :) = NaN(1,nm);
                        tm(c, :) = NaN(1,nm);
                    end
                else
                    raw = raw(1:end-1);
                    tab.raw{c,1} = raw;
                    tab.extra{c,1} = extra;
                    extra = [];
                    raw = [];
                    mi = 1;
                    i = i - 1;
                    c = c + 1;
                    x(c, :) = NaN(1,nm);
                    tm(c, :) = NaN(1,nm);
                end
                i = i + 1;
            end
            tab.extra{c,1} = extra;
            tab.raw{c,1} = raw;
            %             tab.extra = SW.cell_extend(tab.extra, 3);
            if length(vertcat(tab.extra{:})) == 0
                tab = rmfield(tab, 'extra');
            end
            tab.lb = x;
            tab.tm = tm;
            tab = struct2table(tab);
        end
    end
end

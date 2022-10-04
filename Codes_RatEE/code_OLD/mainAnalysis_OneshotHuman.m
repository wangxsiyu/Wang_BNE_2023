% load datahuman
datahuman = readtable('/Volumes/Wang/Lab_Fellous/datahuman_FellousLab/Importeddatahuman_FellousLab/tempHuman.csv');
datahuman = table_autofieldcombine(datahuman);
%% preprocess
datahuman.c_side = datahuman.choice;
datahuman.drop = datahuman.trueMean;
datahuman.r_best = max(datahuman.drop')';
datahuman.c_ac = (datahuman.reward == datahuman.r_best) + 0 * datahuman.reward;
datahuman.c_rp = [NaN(size(datahuman,1),1) (datahuman.c_side(:,2:end) == datahuman.c_side(:,1:end-1))] + 0 * datahuman.c_side;
datahuman.dR = datahuman.drop(:,2) - datahuman.drop(:,1);
datahuman.nGuided = ones(size(datahuman,1),1);
datahuman.nFree = nansum(~isnan(datahuman.choice'))' - 1;
datahuman = datahuman(datahuman.nFree ~= 0, :);
%% choice curve
sub = table;
idxsub = selectsubject(datahuman, {'filename','nFree'});
idxsub = idxsub(cellfun(@(x)length(x) > 10, idxsub));
for si = 1:length(idxsub)
    td = datahuman(idxsub{si},:);
    nF = unique(td.nFree);
    nG = 1;
    sub.horizon(si) = nF;
    c1 = td.c_ac(:,nF + nG) == 1;
    dR = abs(td.dR);
    xbin = [-0.5:1:5.5];
    [sub.choicecurve(si,:)] = tool_bin_average(c1, dR, xbin);
    
    tt = td.c_ac;
    sub.trial_ac(si, :) = nanmean(tt);
    xbin = [-0.5:1:5.5];
    c1 = td.c_side(:,1);
    c2 = td.c_side(:,nG + 1);
    ce = c1 ~= c2;
    r_guided = td.reward(:,1);
    [sub.choicecurve_explore(si,:)] = tool_bin_average(ce, r_guided, xbin);
    
    tt = td.c_ac;
    sub.av_trial_ac(si, :) = nanmean(tt);
    sub.se_trial_ac(si, :) = nanstd(tt)./sqrt(sum(~isnan(tt)));
    
    tt = (td.c_side ~= c1) + 0*td.c_side;
    sub.trial_explore(si, :) = nanmean(tt);
    
    tt = (td.c_rp) + 0*td.c_side;
    sub.trial_rp(si, :) = nanmean(tt);
end
%%
clear gp
hs = unique(sub.horizon);
for hi = 1:length(hs)
    idxh = sub.horizon == hs(hi);
    td = sub(idxh,:);
    gp(hi,:) = ANALYSIS_group(td);
end
%%
sub = gp;
%% initialize
plt_initialize('fig_dir', '/Volumes/Wang/Lab_Fellous/Manuscript_FellousLab/RatExploration/figs', ...
    'fig_projectname', 'OneshotHuman');
%% figure 1 - accuracy 
lgd = arrayfun(@(x)['H = ' num2str(x)], hs, 'UniformOutput', false);
plt_figure(1,1, 'istitle', 1);
plt_setfig('title', 'human', 'xlabel', '\Delta R', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 5.5], 'xtick', [1:5], 'ylim', [0.3 1.1]);
plt_new;
plt_setfig_ax('color', {'AZcactus30', 'AZcactus50', 'AZcactus70', 'AZcactus'},  ...
    'legloc', 'SouthEast', 'legend', lgd);
plt_lineplot(sub(:,:).av_choicecurve,  sub(:,:).ste_choicecurve);
plt_update;
plt_save('ac');
%% figure 2 - p(explore)
plt_figure(1,1, 'istitle', 1);
rat = {'Human'};
plt_setfig('title', ['human'], 'xlabel', 'R guided', 'ylabel', 'p(explore)', ...
    'xlim', [0.5 5.5], 'xtick', [1:5], 'xticklabel', [1:5],'ylim', [-0.1 1.1]);

cols = {'AZcactus30', 'AZcactus50', 'AZcactus70', 'AZcactus'};
    ri = 1;
    plt_new;
    plt_setfig_ax('legend', lgd, 'color', cols,  ...
        'legloc', 'SouthWest');
    plt_lineplot(sub(:,:).av_choicecurve_explore(:,2:end),  sub(:,:).ste_choicecurve_explore(:,2:end));
plt_update;
plt_save('pexplore');
%% figure 3 - later trials
plt_figure(1,1, 'istitle', 1);
rat = {'Human'};
plt_setfig('title', ['human'], 'xlabel', 'trial number', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 9.5], 'xtick', [1:9],'xticklabel', 1:9, 'ylim', [0.5 1], 'ytick', [0.5:0.1:1]);
    ri = 1;
        plt_new;
        plt_setfig_ax('legend', lgd, 'color', cols,  ...
            'legloc', 'SouthEast');
        plt_lineplot(sub(:,:).av_trial_ac(:,2:end),  sub(:,:).ste_trial_ac(:,2:end));
plt_update;
plt_save('performance');
%% 

















%% rat 
%%
plt.param_fig.islocked = 1;
% plt.setfig(3, 'legend', {'random', 'normal'});
plt.setfig(3, 'legend', {'random, bad', 'random, good',...
    'normal, bad','normal, good'});
%%
plt.param_fig.islocked = 1;
% plt.setfig(3, 'legend', {'random', 'normal'});
plt.setfig(3, 'legend', {'free, h = 1','free, h = 6','guided, h = 1','guided, h = 6'} ,...
    'color', {'AZblue50','AZred50','AZblue','AZred'});


%% select data - 0131267
tgp = gp(contains(gp.group_analysis.condition, "all013_1267"),:);
cond = 'all0131267';
%%
plt.param_fig.islocked = 1;
% plt.setfig(3, 'legend', {'random', 'normal'});
plt.setfig(3, 'legend', {'g0h1','g0h6','g1h1', 'g1h6','g3h1','g3h6'}, ...
    'color', {'AZcactus50','AZcactus','AZsand50','AZsand','AZblue','AZred'});
%% figure basic
plt.param_fig.islocked = 1;
plt.setfig(3,'ylim', {[0 1],[0 1],[0.1 0.8]});
plt = fig_basic(plt, tgp, cond);
%% figure r 
plt = fig_rcurve(plt, tgp, cond);
%% r x guided
plt.param_fig.islocked = 1;
plt.setfig(3,'ylim', {[0.3 1],[0.1 0.9],[0.1 0.9]});
plt = fig_basic_byguided(plt, tgp, cond);

%% explore
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'trial #', 'ylabel', 'p(explore)', 'legend',{'6','1'});
plt.ax(1,1);
gn = [6 5 7];
tgp = gp(gn,:);
plt.update;
plt.save('ep_nt');
%% plots
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'R guided', 'ylabel', 'p(correct)', 'legend',{'6','1'});
plt.ax(1,1);
gn = [6 5 7];
tgp = gp(gn,:);
plt.update;
plt.save('ac_r');
%% explore
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'R guided', 'ylabel', 'p(explore)', 'legend',{'6','1'}, ...
    'xtick',1:6, 'xticklabel',0:5);
plt.ax(1,1);
gn = [6 5 7];
tgp = gp(gn,:);
plt.lineplot(tgp.av_bin_all_c_explore, tgp.ste_bin_all_c_explore);
plt.update;
plt.save('ep_r');
%%

%%
plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE_il');
%% plots
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'trial #', 'ylabel', 'p(correct)', 'legend',{'6','1'});
plt.ax(1,1);
gn = [10 5];
tgp = gp(gn,:);
plt.lineplot(tgp.av_c_best, tgp.ste_c_best);
plt.update;
plt.save('ac_nt');
%% explore
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'trial #', 'ylabel', 'p(explore)', 'legend',{'6','1'});
plt.ax(1,1);
gn = [5 10];
tgp = gp(gn,:);
plt.lineplot(tgp.av_c_explore, tgp.ste_c_explore);
plt.update;
plt.save('ep_nt');
%% plots
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'R guided', 'ylabel', 'p(correct)', 'legend',{'6','1'});
plt.ax(1,1);
gn = [5 10];
tgp = gp(gn,:);
plt.lineplot(tgp.av_bin_all_c_best, tgp.ste_bin_all_c_best);
plt.update;
plt.save('ac_r');
%% explore
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'R guided', 'ylabel', 'p(explore)', 'legend',{'6','1'});
plt.ax(1,1);
gn = [5 10];
tgp = gp(gn,:);
plt.lineplot(tgp.av_bin_all_c_explore, tgp.ste_bin_all_c_explore);
plt.update;
plt.save('ep_r');
%%
plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE01');
%% plots
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'trial #', 'ylabel', 'p(correct)', 'legend',{'f,1', 'f 6', 'g,1','g,6'});
plt.ax(1,1);
gn = [1:4];
tgp = gp(gn,:);
plt.lineplot(tgp.av_c_best, tgp.ste_c_best);
plt.update;
plt.save('ac_nt');
%% explore
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'trial #', 'ylabel', 'p(explore)', 'legend',{'f,1', 'f 6', 'g,1','g,6'});
plt.ax(1,1);
gn = [1:4];
tgp = gp(gn,:);
plt.lineplot(tgp.av_c_explore, tgp.ste_c_explore);
plt.update;
plt.save('ep_nt');
%% plots
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'R guided', 'ylabel', 'p(correct)', 'legend',{'f,1', 'f 6', 'g,1','g,6'});
plt.ax(1,1);
gn = [1:4];
tgp = gp(gn,:);
plt.lineplot(tgp.av_bin_all_c_best, tgp.ste_bin_all_c_best);
plt.update;
plt.save('ac_r');
%% explore
plt.figure(1,1);
plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand'}, ...
    'legend', {'1','15','20','6'}, 'xlim', [0.5 6.5],'xlabel', 'R guided', 'ylabel', 'p(explore)', 'legend',{'f,1', 'f 6', 'g,1','g,6'});
plt.ax(1,1);
gn = [1:4];
tgp = gp(gn,:);
plt.lineplot(tgp.av_bin_all_c_explore, tgp.ste_bin_all_c_explore);
plt.update;
plt.save('ep_r');
%%
% data.fd_best = (data.drop(:,1) > data.drop(:,2)).* data.feeders(:,1) + ...
%     (data.drop(:,1) < data.drop(:,2)).* data.feeders(:,2);
% data.fd_best(data.fd_best == 0) = NaN;
% data.dp_good = max(data.drop')';
% data.dp_bad = min(data.drop')';
% data.c_guided_good = 1 - abs(sign(data.c_guided - data.fd_best));
% data.c_free_good = 1 - abs(sign(data.c_free - data.fd_best));
% data.dp_guided = data.c_guided_good .* data.dp_good + (1-data.c_guided_good) .* data.dp_bad;
% data.dp_free = data.c_free_good .* data.dp_good + (1-data.c_free_good) .* data.dp_bad;
% data.fd_lastguided = SYnan_last(data.c_guided);
% data.c_free_lastguided = 1 - abs(sign(data.c_free - data.fd_lastguided));
% data.c_free_good_last = SYnan_last(data.c_free_good);
% %% condition
% idx = W_sub.display_conditions(data, {'datetime','version'},'rat');

%% figure - histogram of numbber of runs per day
%% figure - number of sessions per rat
%% compute condition
% conds = [cellfun(@(x)unique(data(x,:).n_guided), idx), ...
% cellfun(@(x)unique(data(x,:).n_free), idx), ...
% cellfun(@(x)length(x), idx)];
% thres = 50;
% idx = idx(conds(:,3) > thres);
% conds = conds(conds(:,3) > thres,:);
% %% compute number of games per condition
% tabconds = table;
% for ii = 1:length(idx)
%     tabcond = table;
%     td = data(idx{ii},:);
%     [ct, nm] = SYcount(td.rat);
%     for ni = 1:length(nm)
%         tabcond.(nm{ni}) = ct(ni);
%     end
%     tabconds = W.tab_vertcat(tabconds, tabcond);
% end
% tabconds.nguided = conds(:,1);
% tabconds.nfree = conds(:,2);
% GTHTMLtable(table2array(tabconds), tabconds.Properties.VariableNames,'show');

% %% both guided (old)
% d = data(data.n_guided == 6 & data.n_free == 6,:);
% d = W.tab_squeeze(d);
% [idx,rat] = W_sub.selectsubject(d, 'rat');
% n_rat = length(idx);
% n_game = size(d,1);
% dR = d.dp_good - d.dp_bad;
% c = d.c_free_good;
% cc1 = []; se1 = [];
% ccl = []; sel = [];
% for ri = 1:length(idx)
%     tid = idx{ri};
%     [cc1(ri,:),se1(ri,:)] = SYbin1_mean(c(tid,1), dR(tid), unique(dR));
%     [ccl(ri,:),sel(ri,:)] = SYbin1_mean(c(tid,end), dR(tid), unique(dR));
% end
% %% both guided (4)
% d = data(data.n_guided == 4 & data.n_free == 6,:);
% d = SYtab_squeeze(d);
% [idx,rat] = SYselectsubject(d, 'rat');
% n_rat = length(idx);
% n_game = size(d,1);
% dR = d.dp_good - d.dp_bad;
% c = d.c_free_good;
% cc1 = []; se1 = [];
% ccl = []; sel = [];
% for ri = 1:length(idx)
%     tid = idx{ri};
%     [cc1(ri,:),se1(ri,:)] = SYbin1_mean(c(tid,1), dR(tid), unique(dR));
%     [ccl(ri,:),sel(ri,:)] = SYbin1_mean(c(tid,end), dR(tid), unique(dR));
% end
%% plots
% plt.figure(1,2);
% plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand','AZriver','AZbrick','AZcactus50'}, ...
%     'legend', rat, 'xlim', [0.5 6.5]);
% plt.ax(1,1);
% plt.lineplot(cc1, se1);
% plt.ax(1,2);
% plt.lineplot(ccl, sel);
% plt.update;
% %% main task
% d = data(data.n_guided == 3 & ismember(data.n_free, [1 6 15 20]) & data.releasetime == 100,:);
% d = W.tab_squeeze(d);
% [idx,rat] = W_sub.selectsubject(d, {'n_free'});
% % idx{2} = [idx{2};idx{3}];
% % idx = idx([1 2 4]);
% % rat = {'S','XL','L'};
% n_rat = length(unique(d.rat));
% n_game = size(d,1);
% dR = d.dp_guided(:,3);
% c = d.c_free_lastguided;
% cc1 = []; se1 = [];
% ccl = []; sel = [];
% %%
% for ri = 1:length(idx)
%     tid = idx{ri};
%     [ac(ri,:), se(ri,:)] = W.avse(d.c_free_good(tid,:));
%     [cc1(ri,:),se1(ri,:)] = SYbin1_mean(c(tid,1), dR(tid), W.unique(dR,0));
%     [ccl(ri,:),sel(ri,:)] = SYbin1_mean(SYnan_last(c(tid,:)), dR(tid), W.unique(dR,0));
% end
% %% plots
% plt.figure(1,1);
% plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand','AZriver','AZbrick','AZcactus50'}, ...
%     'legend', rat, 'xlim', [0.5 6.5],'ylim',[0 1],...
%     'xtick',1:6,'xticklabel',0:5, ...
%     'xlabel', 'R guided', 'ylabel', 'p(explore)');
% plt.ax(1,1);
% plt.lineplot(1-cc1', se1');
% plt.update;
% %%
% 
% plt.figure(1,1);
% plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand','AZriver','AZbrick','AZcactus50'}, ...
%     'legend', rat, 'xlim', [0.5,20.5],'ylim',[0.5 1],...
%     'xtick',1:20,'xticklabel',1:20, ...
%     'xlabel', 'trial #', 'ylabel', 'p(best)');
% plt.ax(1,1);
% plt.lineplot(ac, se);
% plt.update;
% %% main task
% d = data(data.n_guided == 1 & ismember(data.n_free, [1 6 15 20]),:);
% d = SYtab_squeeze(d);
% [idx,rat] = SYselectsubject(d, {'n_free'});
% % idx{2} = [idx{2};idx{3}];
% % idx = idx([1 2 4]);
% % rat = {'S','XL','L'};
% n_rat = length(unique(d.rat));
% n_game = size(d,1);
% dR = d.dp_guided(:,1);
% d.fd_lastguided = SYnan_last(d.c_guided);
% d.c_free_lastguided = 1 - abs(sign(d.c_free - d.fd_lastguided));
% c = d.c_free_lastguided;
% cc1 = []; se1 = [];
% ccl = []; sel = [];
% ac = [];se = [];
% for ri = 1:length(idx)
%     tid = idx{ri};
%     [ac(ri,:), se(ri,:)] = tool_meanse(d.c_free_good(tid,:));
%     [cc1(ri,:),se1(ri,:)] = SYbin1_mean(c(tid,1), dR(tid), SYnan_unique(dR,0));
% %     [ccl(ri,:),sel(ri,:)] = SYbin1_mean(SYnan_last(c(tid,:)), dR(tid), SYnan_unique(dR,0));
% end
% %%
% d = data(data.n_guided == 0 & ismember(data.n_free, [2 7 16 21]),:);
% d = SYtab_squeeze(d);
% [idx,rat2] = SYselectsubject(d, {'n_free'});
% idx = idx([2 1 3]);
% % idx{2} = [idx{2};idx{3}];
% % idx = idx([1 2 4]);
% % rat = {'S','XL','L'};
% n_rat = length(unique(d.rat));
% n_game = size(d,1);
% dR = d.dp_free(:,1);
% d.fd_lastguided = d.c_free(:,1);
% d.c_free_lastguided = 1 - abs(sign(d.c_free - d.fd_lastguided));
% c = d.c_free_lastguided(:,2);
% cc2 = []; se2 = [];
% ccl = []; sel = [];
% acc = [];see = [];
% for ri = 1:length(idx)
%     tid = idx{ri};
%     [acc(ri,:), see(ri,:)] = tool_meanse(d.c_free_good(tid,:));
%     [cc2(ri,:),se2(ri,:)] = SYbin1_mean(c(tid,1), dR(tid), SYnan_unique(dR,0));
% %     [ccl(ri,:),sel(ri,:)] = SYbin1_mean(SYnan_last(c(tid,:)), dR(tid), SYnan_unique(dR,0));
% end
% %% plots
% plt.figure(1,1);
% plt.setfig('color',{'AZred','AZblue','AZcactus','AZsand','AZriver','AZbrick','AZcactus50'}, ...
%     'legend', rat, 'xlim', [0.5 6.5],'ylim',[0 1],...
%     'xtick',1:6,'xticklabel',0:5, ...
%     'xlabel', 'R guided', 'ylabel', 'p(explore)');
% plt.new;
% plt.lineplot(1-cc1, se1);
% plt.update;
% %%
% plt.figure(1,3);
% plt.setfig('color',{'AZred','AZblue','AZcactus','AZred50','AZblue50','AZcactus50','AZcactus50'}, ...
%     'legend', rat, 'xlim', [0.5,6.5],'ylim',[0 1],...
%     'xtick',1:6,'xticklabel',0:5, ...
%     'xlabel', 'R guided', 'ylabel', 'p(explore)');
% for i = [1 3 2]
% plt.new;
% plt.lineplot(1-cc1(i,:), se1(i,:));
% plt.lineplot(1-cc2(i,2:end), se2(i,2:end));
% end
% plt.update;
% %%
% 
% plt.figure(1,3);
% plt.setfig('color',{'AZred','AZblue','AZcactus','AZred50','AZblue50','AZcactus50','AZcactus50'}, ...
%     'legend', rat, 'xlim', [0.5,20.5],'ylim',[0.4 0.9],...
%     'xtick',1:20,'xticklabel',1:20, ...
%     'xlabel', 'trial #', 'ylabel', 'p(best)');
% for i = [1 3 2]
% plt.new;
% plt.lineplot(ac(i,:), se(i,:));
% plt.lineplot(acc(i,2:end), see(i,2:end));
% end
% plt.update;

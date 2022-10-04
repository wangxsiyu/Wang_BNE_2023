% load data2
data2 = readtable('/Volumes/Wang/Lab_Fellous/data_FellousLab/Importeddata_FellousLab/tempHuman.csv');
data2 = table_autofieldcombine(data2);
%% rename
data2.timestamp_visit_choice = data2.timeKeyPress;
data2.timestamp_BlinkStart_choice = data2.timeBanditOn;
data2.drop = data2.trueMean;
data2.feeders = repmat([1  2], height(data2),1);
data2.isguided = repmat([1 zeros(1,size(data2.choice,2)-1)], height(data2),1) + 0*data2.choice;
%% preprocess
data2.c_side = abs(sign(data2.choice - data2.feeders(:,1))) + 1;
te = arrayfun(@(x)arrayfun(@(y)nan_select(data2.drop(x,:), y), data2.c_side(x,:)), 1:size(data2,1), 'UniformOutput', false);
data2.reward = vertcat(te{:});
data2.r_best = max(data2.drop')';
data2.c_ac = (data2.reward == data2.r_best) + 0 * data2.reward;
data2.c_rp = [NaN(size(data2,1),1) (data2.c_side(:,2:end) == data2.c_side(:,1:end-1))] + 0 * data2.c_side;
data2.dR = data2.drop(:,2) - data2.drop(:,1);
data2.nGuided = nansum(data2.isguided')';
data2.nFree = nansum(data2.isguided' == 0)';
data2 = data2(data2.nFree ~= 0, :);
% data2.r_guided = arrayfun(@(x)mean(data2.r(x, 1:data2.nGuided(x))), 1:size(data2,1))';
% 
% 
% data2.side_guided = arrayfun(@(x)mean(data2.fd_side(x, 1:data2.nGuided(x))), 1:size(data2,1))';
% data2.c_explore = (data2.side_guided ~= data2.fd_side) + data2.fd_side * 0;
% % data2.c_repeat = [NaN(size(data2,1),1),data2.c_ac(:,2:end) == data2.c_ac(:,1:end-1)] +  data2.c_ac * 0;
% data2.rpairID = sort(data2.r_side')' * [10  1]';
%%
nFrees = unique(data2.nFree);
nFrees = nFrees(arrayfun(@(x)sum(data2.nFree == x), nFrees) > 100);
%%
subs = unique(data2.subjectID);
hs = unique(data2.nFree);
for si = 1:length(subs)
    
    for hi = 1:length(hs)
        td = data2(data2.subjectID == subs(si) & data2.nFree == hs(hi),:);
        ac(si,hi) = mean(td.c_ac(:,hs(hi)));
        te = tempMLEfit(td.c_rp(:,2), td.reward(:,1));
        thres(si,hi) = te(1);
        noise(si,hi) = te(2);
    end
end
%%
idx = all((ac(:,3:4)> 0.9)')
thres1 = thres(idx,:);
noise1 = noise(idx,:);
%%
plt_figure(1,2);
[a1,a2] = tool_meanse(thres1);
[b1,b2] = tool_meanse(noise1);
plt_new;
plt_lineplot(a1, a2);
plt_new;
plt_lineplot(b1,b2);
%%
cc = (data2.isguided.*data2.choice)';
cc(cc ==  0) = NaN;
cc = nan_unique_col(cc);
if isnumeric(cc)
    idx = true(size(cc,1), size(cc,2));
end
if iscell(cc)
    idx = cellfun(@(x)length(x)  ==  1, cc);
end
data2 = data2(idx,:);
%%
data2 = table_squeeze(data2);
%%
% nd = height(data2);
% g0 = arrayfun(@(x)sum(data2.c_side(x,1:data2.nGuided(x)) == 1), 1:nd);
% g1 = arrayfun(@(x)sum(data2.c_side(x,1:data2.nGuided(x)) == 2), 1:nd)
% mg0 = min([g0; g1]);
% mg1 = max([g0; g1]);
% version = [data2.is_3light, g0*10 + g1];
%%
plt_initialize('fig_dir', './figs', ...
    'fig_projectname', 'HumanEE');
cols = 'AZcactus';
cols = {[cols '30'], [cols '50'],[cols '70'], cols};
%% basic analysis
idxsub2 = selectsubject(data2, {'filename','nFree'});
sub2 = ANALYSIS_sub(data2, idxsub2, 'basic', 'basic', 'RatEE_analysis');
%% group
clear gp2 tgp
gp2 = table;
for hi = 1:length(nFrees)
    tgp = ANALYSIS_group(sub2(sub2.cond_horizon == nFrees(hi),:));
    gp2 = tool_vertcat(gp2, tgp);
end
%% model fit
plt_figure(1,2, 'istitle',1);
plt_setfig('new','title', {'directed exploration','random exploration'}, 'xlabel', 'horizon', 'ylabel', {'threshold', 'noise'}, ...
    'xlim', {[0.5 4.5],[0.5 4.5]}, 'xtick', {[1:4],1:4},'xticklabel',{[1 2 5 9], [1 2 5 9]}, ...
    'color', {'AZred','AZred'});
plt_new;
plt_lineplot(gp2.av_thres',  gp2.ste_thres');
plt_new;
plt_lineplot(gp2.av_noise',  gp2.ste_noise');
plt_update;

%% trial number
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['human'], 'xlabel', 'trial number', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 9.5], 'xtick', [1:9],'xticklabel',1:9, 'ylim', [0.5 1],'ytick', 0.5:0.1:1);
lgd = arrayfun(@(x) ['H = ' num2str(x)], nFrees, 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', cols,  ...
    'legloc', 'SouthEast');
plt_lineplot(gp2.av_trialn_ac,  gp2.ste_trialn_ac);
plt_update;
plt_save('performance');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['human'], 'xlabel', 'trial number', 'ylabel', 'p(switch)', ...
    'xlim', [0.5 9.5], 'xtick', [1:9],'xticklabel',1:9, 'ylim', [0 1],'ytick', 0:0.1:1);
lgd = arrayfun(@(x) ['H = ' num2str(x)], nFrees, 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', cols,  ...
    'legloc', 'NorthEast');
plt_lineplot(1-gp2.av_trialn_rp,  gp2.ste_trialn_rp);
plt_update;
plt_save('prepeat');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['human'], 'xlabel', 'trial number', 'ylabel', 'reaction time (s)', ...
    'xlim', [0.5 9.5], 'xtick', [1:9],'xticklabel',1:9, 'ylim', 0:1, 'ytick', 0:0.2:4);
lgd = arrayfun(@(x) ['H = ' num2str(x)], nFrees, 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', cols,  ...
    'legloc', 'NorthEast');
plt_lineplot(gp2.av_trialn_rt,  gp2.ste_trialn_rt);
plt_update;
plt_save('rt');
%% rcurve
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['human'], 'xlabel', 'R guided', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5,'xlim', [1.5 6.5], 'ylim', [0 1],'ytick', 0:0.2:1);
lgd = arrayfun(@(x) ['H = ' num2str(x)], nFrees, 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', cols,  ...
    'legloc', 'SouthEast');
plt_lineplot(gp2.av_rcurve_ac,  gp2.ste_rcurve_ac);
plt_update;
plt_save('performance_r');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['human'], 'xlabel', 'R guided', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5,'xlim', [1.5 6.5], 'ylim', [0 1],'ytick', 0:0.2:1);
lgd = arrayfun(@(x) ['H = ' num2str(x)], nFrees, 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', cols,  ...
    'legloc', 'SouthEast');
plt_lineplot(gp2.av_rcurve_ac1,  gp2.ste_rcurve_ac1);
plt_update;
plt_save('performance_r1');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['human'], 'xlabel', 'R guided', 'ylabel', 'p(explore)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5, 'xlim', [1.5 6.5],'ylim', [0 1],'ytick', 0:0.2:1);
lgd = arrayfun(@(x) ['H = ' num2str(x)], nFrees, 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', cols,  ...
    'legloc', 'NorthEast');
plt_lineplot(1-gp2.av_rcurve_ee,  gp2.ste_rcurve_ee);
plt_update;
plt_save('prepeat_r');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['human'], 'xlabel', 'R guided', 'ylabel', 'reaction time (s)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5, 'xlim', [1.5 6.5], 'ylim', [0 1],'ytick', 0:0.5:5);
lgd = arrayfun(@(x) ['H = ' num2str(x)], nFrees, 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', cols,  ...
    'legloc', 'SouthEast');
plt_lineplot(gp2.av_rcurve_rt,  gp2.ste_rcurve_rt);
plt_update;
plt_save('rt_r');
% plt_figure(1,1, 'istitle', 1);
% plt_new;
% 
% rat = {'Ratzo', 'Rizzo'};
% plt_setfig('title', ['rat'], 'xlabel', 'trial number', 'ylabel', 'p(correct)', ...
%     'xlim', [0.5 6.5], 'xtick', [1:5],'xticklabel',1:6, 'ylim', [0.5 1]);
% vers = {'all rat'};
% cols = 'AZblue';
% lgd = tool_de_(vers{vi});
% lgd = arrayfun(@(x) [', H = ' num2str(x)], [1 6], 'UniformOutput', false);
% plt_setfig('legend', lgd, 'color', {[cols '50'], cols},  ...
%     'legloc', 'SouthEast');
% for hi = 1:2
% plt_lineplot(gp2{hi}.av_av_choicecurve(:,:),  gp2{hi}.ste_av_choicecurve(:, :));
% end
% plt_update;
% plt_save('performance2');
% 
% %% figure 1 - accuracy 
% plt_figure(1,2, 'istitle', 1);
% rat = {'Ratzo', 'Rizzo'};
% plt_setfig('title', rat, 'xlabel', '\Delta R', 'ylabel', 'p(correct)', ...
%     'xlim', [0.5 5.5], 'xtick', [1:5],'xticklabel', 1:5, 'ylim', [0.3 1.1]);
% for ri = 1:length(rat)
%     idx = sub2.horizon == 6 & strcmp(sub2.rat, rat{ri});
%     lgd = sub2(idx,:).version;
%     lgd = cellfun(@(x)tool_de_(x), lgd, 'UniformOutput', false);
%     plt_new;
%     plt_setfig_ax('legend', lgd, 'color', {'AZred', 'AZblue', 'AZsand'},  ...
%         'legloc', 'SouthEast');
%     plt_lineplot(sub2(idx,:).av_choicecurve,  sub2(idx,:).se_choicecurve);
% end
% plt_update;
% plt_save('ac');
% %%
% plt_figure(1,1, 'istitle', 0);
% rat = {'Ratzo', 'Rizzo'};
% plt_setfig('title', [rat  {'' '' '' ''}], 'xlabel', {'','','','','\Delta R','\Delta R'}, ...
%     'ylabel', {'p(correct)', '','p(correct)','','p(correct)',''}, ...
%     'xlim', [0.5 5.5], 'xtick', [1:5], 'xticklabel', 1:5, 'ylim', [0.3 1.1]);
% plt_setparams('fontsize_leg', 10);
% vers = {'Guided1_Sound'};
% cols = {'AZsand', 'AZblue', 'AZred'};
% for vi = 1:length(vers)
% %     for ri = 1:length(rat)
%         idx = 1:2;%strcmp(sub2.rat, rat{ri}) & strcmp(sub2.version, vers{vi});
%         lgd = tool_de_(vers{vi});
%         lgd = arrayfun(@(x) [lgd, ', H = ' num2str(x)], sub2.horizon(idx), 'UniformOutput', false);
%         plt_new;
%         plt_setfig_ax('legend', lgd, 'color', {[cols{vi} '50'], cols{vi}},  ...
%             'legloc', 'SouthEast');
%         plt_lineplot(sub2(idx,:).av_choicecurve_explore,  sub2(idx,:).se_choicecurve_explore);
% %     end
% end
% plt_update;
% plt_save('ac2');
% %% figure 2 - p(explore)
% plt_figure(1,1, 'istitle', 1);
% rat = {'Ratzo', 'Rizzo'};
% plt_setfig('title', ['Rat'], 'xlabel', 'R guided', 'ylabel', 'p(explore)', ...
%     'xlim', [0.5 4.5], 'xtick', [1 2 3 4], 'xticklabel', [0 1 3 5], 'ylim', [-0.1 1.1]);
% vers = {''};
% cols = {'AZblue', 'AZblue'};
% plt_new; 
% lgd = tool_de_(vers{vi});
%         lgd = arrayfun(@(x) [lgd, ', H = ' num2str(x)], sub2.horizon(idx), 'UniformOutput', false);
%       plt_setfig('legend', lgd, 'color', {[cols{hi} '50'], cols{hi}},  ...
%             'legloc', 'SouthEast'); 
% for hi = 1:2
% %     for ri = 1:length(rat)
%         idx = 1:2;%strcmp(sub2.rat, rat{ri}) & strcmp(sub2.version, vers{vi});
%         
%         plt_lineplot(gp2{hi}.av_av_choicecurve_explore([1 2 4 6]),  gp2{hi}.ste_av_choicecurve_explore([1 2 4 6]));
% %     end
% end
% plt_update;
% plt_save('pexplore');
% %% figure 3 - later trials
% plt_figure(2,2, 'istitle', 1);
% rat = {'Ratzo', 'Rizzo'};
% plt_setfig('title', [rat  {'' ''}], 'xlabel', 'trial number', 'ylabel', 'p(repeat)', ...
%     'xlim', [0.5 10.5], 'xtick', [1:10], 'ylim', [-0.1 1.1]);
% vers = {'Guided1_Sound', 'FreeChoice_Sound'};
% cols = {'AZblue', 'AZsand'};
% % for vi = 1:length(vers)
%     for ri = 1:length(rat)
%         idx = strcmp(sub2.rat, rat{ri}) & strcmp(sub2.version, vers{vi});
%         lgd = tool_de_(vers{vi});
%         lgd = arrayfun(@(x) [lgd, ', H = ' num2str(x)], sub2.horizon(idx), 'UniformOutput', false);
%         plt_new;
%         plt_setfig_ax('legend', lgd, 'color', {[cols{vi} '50'], cols{vi}},  ...
%             'legloc', 'SouthEast');
%         plt_lineplot(sub2(idx,:).av_trial_explore,  sub2(idx,:).se_trial_explore);
%     end
% % end
% plt_update;
% plt_save('pexplore_bytrial');
% %% 
% 
% 
% %% figure 2 - RT
% plt_figure(1,1, 'istitle', 1);
% rat = {'Ratzo', 'Rizzo'};
% plt_new;
% plt_setfig('new','title', ['Rat'], 'xlabel', 'R guided', 'ylabel', 'RT');
% vers = {'Guided1_Sound'};
% cols = {'AZblue', 'AZblue'};
% lgd = tool_de_(vers{vi});
% lgd = arrayfun(@(x) ['H = ' num2str(x)],[1 6], 'UniformOutput', false);
% plt_setfig('legend', lgd, 'color', {{[cols{1} '50'], cols{1}}},  ...
%     'legloc', 'SouthEast');
% for hi = 1:2
% %     for ri = 1:length(rat)
%         idx = 1:2;%strcmp(sub2.rat, rat{ri}) & strcmp(sub2.version, vers{vi});
%         plt_lineplot(gp2{hi}.av_av_RT/1000,  gp2{hi}.ste_av_RT/1000);
% %     end
% end
% plt_update;
% plt_save('RT');
% %%
% plt_figure(1,1, 'istitle', 1);
% rat = {'Ratzo', 'Rizzo'};
% plt_new;
% plt_setfig('new','title', ['Rat'], 'xlabel', 'R guided', 'ylabel', 'p(right)');
% vers = {'Guided1_Sound'};
% cols = {'AZblue', 'AZblue'};
% lgd = tool_de_(vers{vi});
% lgd = arrayfun(@(x) ['H = ' num2str(x)],[1 6], 'UniformOutput', false);
% plt_setfig('legend', lgd, 'color', {{[cols{1} '50'], cols{1}}},  ...
%     'legloc', 'SouthEast');
% for hi = 1:2
% %     for ri = 1:length(rat)
%         idx = 1:2;%strcmp(sub2.rat, rat{ri}) & strcmp(sub2.version, vers{vi});
%         plt_lineplot(gp2{hi}.av_av_r,  gp2{hi}.ste_av_r);
% %     end
% end
% plt_update;
% plt_save('r');
% load data
data = readtable('/Volumes/Wang/Lab_Fellous/Data_FellousLab/ImportedData_FellousLab/ratEE.csv');
%% preprocess
data = RatEE_preprocess(data);
%%
nFrees = unique(data.nFree);
nFrees = nFrees(arrayfun(@(x)sum(data.nFree == x), nFrees) > 100);
data = data(ismember(data.nFree, nFrees) & data.cond_alternatehomebase == 1 & data.cond_3light == 0,:);
%% select condition
cc = (data.isguided.*data.choice)';
cc(cc ==  0) = NaN;
idx = cellfun(@(x)length(x)  ==  1, nan_unique_col(cc));
data = data(idx,:);
data = table_squeeze(data);
%% basic analysis
idxsub = selectsubject(data, {'rat','nFree','nGuided'});
nidxsub = cellfun(@(x)length(x), idxsub);
idxsub = idxsub(nidxsub > 20);
sub = ANALYSIS_sub(data, idxsub, 'basic', 'basic', 'RatEE_analysis');
sub = table_squeeze(sub);
%% group
clear gp
gp1 = ANALYSIS_group(sub(sub.cond_horizon == 1  &  sub.nGuided ==3,:));
gp2 = ANALYSIS_group(sub(sub.cond_horizon == 6 &  sub.nGuided ==3,:));
gp3 = ANALYSIS_group(sub(sub.cond_horizon == 20 &  sub.nGuided ==3,:));
gp = table_vertcat(gp1, gp2, gp3);
% %% temp
% for i = 0:5
% t1 = data(data.nFree == 1 & data.nGuided == 3 & data.reward(:,1) == i,:).c_rt(:,4);
% t2 = data(data.nFree == 6 & data.nGuided == 3 & data.reward(:,1) == i,:).c_rt(:,4);
% [~,pp] = ttest2(t1,t2)
% end
% %%
% for i = 0:5
% t1 = data(data.nFree == 1 & data.nGuided == 3 & data.reward(:,1) == i,:).c_ac(:,4);
% t2 = data(data.nFree == 6 & data.nGuided == 3 & data.reward(:,1) == i,:).c_ac(:,9);
% [~,pp] = ttest2(t1,t2)
% end
% %%
% for i = 0:5
% t1 = data(data.nFree == 2 & data.nGuided == 0 & data.reward(:,1) == i,:).c_rp(:,2);
% t2 = data(data.nFree == 7 & data.nGuided == 0 & data.reward(:,1) == i,:).c_rp(:,2);
% [~,pp] = ttest2(t1,t2)
% end
% %%
% for i = 1:6
% t1 = data(data.nFree == 6 & data.nGuided == 1,:).c_rp(:,i+1);
% t2 = data(data.nFree == 7 & data.nGuided == 0,:).c_rp(:,i+1);
% [~,pp] = ttest2(t1,t2)
% end
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
% plt_lineplot(gp{hi}.av_av_choicecurve(:,:),  gp{hi}.ste_av_choicecurve(:, :));
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
%     idx = sub.horizon == 6 & strcmp(sub.rat, rat{ri});
%     lgd = sub(idx,:).version;
%     lgd = cellfun(@(x)tool_de_(x), lgd, 'UniformOutput', false);
%     plt_new;
%     plt_setfig_ax('legend', lgd, 'color', {'AZred', 'AZblue', 'AZsand'},  ...
%         'legloc', 'SouthEast');
%     plt_lineplot(sub(idx,:).av_choicecurve,  sub(idx,:).se_choicecurve);
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
%         idx = 1:2;%strcmp(sub.rat, rat{ri}) & strcmp(sub.version, vers{vi});
%         lgd = tool_de_(vers{vi});
%         lgd = arrayfun(@(x) [lgd, ', H = ' num2str(x)], sub.horizon(idx), 'UniformOutput', false);
%         plt_new;
%         plt_setfig_ax('legend', lgd, 'color', {[cols{vi} '50'], cols{vi}},  ...
%             'legloc', 'SouthEast');
%         plt_lineplot(sub(idx,:).av_choicecurve_explore,  sub(idx,:).se_choicecurve_explore);
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
%         lgd = arrayfun(@(x) [lgd, ', H = ' num2str(x)], sub.horizon(idx), 'UniformOutput', false);
%       plt_setfig('legend', lgd, 'color', {[cols{hi} '50'], cols{hi}},  ...
%             'legloc', 'SouthEast'); 
% for hi = 1:2
% %     for ri = 1:length(rat)
%         idx = 1:2;%strcmp(sub.rat, rat{ri}) & strcmp(sub.version, vers{vi});
%         
%         plt_lineplot(gp{hi}.av_av_choicecurve_explore([1 2 4 6]),  gp{hi}.ste_av_choicecurve_explore([1 2 4 6]));
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
%         idx = strcmp(sub.rat, rat{ri}) & strcmp(sub.version, vers{vi});
%         lgd = tool_de_(vers{vi});
%         lgd = arrayfun(@(x) [lgd, ', H = ' num2str(x)], sub.horizon(idx), 'UniformOutput', false);
%         plt_new;
%         plt_setfig_ax('legend', lgd, 'color', {[cols{vi} '50'], cols{vi}},  ...
%             'legloc', 'SouthEast');
%         plt_lineplot(sub(idx,:).av_trial_explore,  sub(idx,:).se_trial_explore);
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
%         idx = 1:2;%strcmp(sub.rat, rat{ri}) & strcmp(sub.version, vers{vi});
%         plt_lineplot(gp{hi}.av_av_RT/1000,  gp{hi}.ste_av_RT/1000);
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
%         idx = 1:2;%strcmp(sub.rat, rat{ri}) & strcmp(sub.version, vers{vi});
%         plt_lineplot(gp{hi}.av_av_r,  gp{hi}.ste_av_r);
% %     end
% end
% plt_update;
% plt_save('r');

%%
%%
% nd = height(data);
% g0 = arrayfun(@(x)sum(data.c_side(x,1:data.nGuided(x)) == 1), 1:nd);
% g1 = arrayfun(@(x)sum(data.c_side(x,1:data.nGuided(x)) == 2), 1:nd)
% mg0 = min([g0; g1]);
% mg1 = max([g0; g1]);
% version = [data.is_3light, g0*10 + g1];
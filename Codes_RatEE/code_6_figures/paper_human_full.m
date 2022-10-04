human = importdata('../../data_processed/output/gp_human_full.mat');
hbidir = '../../result_bayes';
file = fullfile(hbidir, 'HBI_model_human_full_human_full_samples.mat');
file = fullfile(hbidir, 'HBI_model_human_full_history_human_full_samples.mat');
sp1 = importdata(file);
file = fullfile(hbidir, 'HBI_model_human_full_human_full_stat.mat');
file = fullfile(hbidir, 'HBI_model_human_full_history_human_full_stat.mat');
st1 = importdata(file).stats.mean;
%% figure
plt = W_plt('fig_dir', '../../figures','fig_projectname', 'human','fig_saveformat','emf');
plt.setuserparam('param_setting', 'isshow', 1);
%% colors
col_human = {'AZcactus', 'AZred', 'AZsky','AZblue'};
leg_human = strcat("H = ",human.gp.group_analysis.cond_horizon);
%% contrast - behavior
% plt.figure(2,4,'rect',[0 0 0.6 0.7], ...
%     'gap',{[ 0.12],[0.05 0.05 0.05]}, 'margin', [0.15 0.1 0.08 0.02]);
plt.figure(3,4,'matrix_hole', [1 1 1 1; 1 1 1 1; 1 1 1 1], 'istitle',...
    'rect',[0 0 0.6 0.9], ...
    'gap',[0.11 0.1], 'margin', [0.08 0.1 0.04 0.02]);
plt.setup_pltparams('fontsize_leg',7);
plt.setfig(1:2,'color', {col_human, col_human}, ...
    'xlabel', {'trial number','trial number'}, 'legord', 'reverse', ...
    'ylabel', {'p(high reward)','p(switch)'}, 'legloc', {'SouthEast','NorthEast'}, ...
    'legend', {leg_human, leg_human}, ...
    'xlim', [0.5 15.5], 'ylim', {[0.5 1],[0 1]}, ...
    'ytick', {0.5:0.5:1,0:0.5:1});
plt.new;
plt.lineplot(ff(human.gp.av_av_cc_best), ff(human.gp.ste_av_cc_best));
plt.new;
plt.lineplot(ff(human.gp.av_av_cc_switch), ff(human.gp.ste_av_cc_switch));

plt.setfig([5 3 7], 'xlim', [0.5 6.5], 'xtick', 1:2.5:6, 'xticklabel', 0:50:100, ...
    'ylim', [0 1], 'ytick', 0:0.5:1, ...
    'legord', 'reverse', 'legloc', 'SouthWest',...
    'color',{col_human,col_human,col_human}, ...
    'legend',{leg_human,leg_human,leg_human}, ...
    'xlabel', {'guided reward', 'guided reward','guided reward'}, ...
    'ylabel', {{'p(high reward)','last choice'},{'p(high reward)','1st choice'},'p(explore)'});

plt.new;
plt.lineplot(human.gp.av_bin_all_c1_cc_best, human.gp.ste_bin_all_c1_cc_best);

plt.new;
plt.setfig_ax('color', col_human(end:-1:1),'xlabel', 'horizon', 'ylabel', {'p(high reward)','1st choice'}, 'xtick',1:4, 'xticklabel', [1 2 5 10],...
    'xlim', [],'ylim',[.5 .7]);
plt.barplot(human.gp.av_av_cc_best(end:-1:1,1)',human.gp.ste_av_cc_best(end:-1:1,1)');

plt.new;
plt.lineplot(human.gp.av_bin_all_ce_cc_best, human.gp.ste_bin_all_ce_cc_best);

plt.new;
plt.setfig_ax('color', col_human(end:-1:1),'xlabel', 'horizon', 'ylabel', {'p(high reward)','last choice'}, 'xtick',1:4, 'xticklabel', [1 2 5 10],...
    'xlim', [],'ylim',[.5 1]);
plt.barplot(W.nan_get(human.gp.av_av_cc_best(end:-1:1,:),1),W.nan_get(human.gp.ste_av_cc_best(end:-1:1,:),1));


plt.new;
plt.lineplot(human.gp.av_bin_all_c1_cc_explore, human.gp.ste_bin_all_c1_cc_explore);

plt.new;
plt.setfig_ax('color', col_human(end:-1:1),'xlabel', 'horizon', 'ylabel', 'p(explore)', 'xtick',1:4, 'xticklabel', [1 2 5 10],...
    'xlim', [],'ylim',[0.5 1]);
plt.barplot(human.gp.av_av_cc_explore(end:-1:1,1)',human.gp.ste_av_cc_explore(end:-1:1,1)');


rgr = {[0 100], [0 30]};
plt.setfig(([9 11]) ,'color', {{'AZblue','AZsky', 'AZred','AZcactus'},{'AZblue','AZsky', 'AZred','AZcactus'}}, ...
    'legend',{{'H = 1','H = 2','H = 5','H = 10'},{'H = 1','H = 2','H = 5','H = 10'}}, ...
    'xlim', rgr, ...
    'legloc', {'NorthWest','NorthWest'}, ...
    'xlabel', {'threshold','noise'}, ...
    'ylabel',{'density','density'});

%split by good/bad
plt.setup_pltparams('hold','fontsize_face', 18);
% plt.setfig([5:12],'ylabel', {{'(high reward)'},'','','',...
%     {'p(switch)'},'','',''}, ...
%     'legend', leg_human, 'ylim', {[0 1],[0 1],[0 1],[0 1],[0 1],[0 1],[0 1],[0 1]}, ...
%     'xlabel', 'trial number', ...
%     'xlim', [0.5 15.5], ...
%     'color', {{'AZblue50','AZblue'},{'AZsky50','AZsky'},{'AZred50','AZred'},{'AZcactus50','AZcactus'},...
%     {'AZblue50','AZblue'},{'AZsky50','AZsky'},{'AZred50','AZred'},{'AZcactus50','AZcactus'}},...
%     'legloc', {'SouthEast','SouthEast','SouthEast','SouthEast','NorthEast','NorthEast','NorthEast','NorthEast'}, ...
%     'legend', {'guided = good', 'guided = bad'}, ...
%     'title', {'H = 1', 'H = 2', 'H = 5', 'H = 10','','','',''}, ...
%     'xtick',5:5:15,'xticklabel',5:5:15);
% tav = ff(human.gp.av_gp_av_cc_best);
% tse = ff(human.gp.ste_gp_av_cc_best);
% for i = 1:4
%     rid = [((5-i) * 2 -1),(5-i) * 2];
%     plt.new;
%     plt.lineplot(tav(rid,:), tse(rid,:));
% end
% tav = ff(human.gp.av_gp_av_cc_switch);
% tse = ff(human.gp.ste_gp_av_cc_switch);
% for i = 1:4
%     rid = [((5-i) * 2 -1),(5-i) * 2];
%     plt.new;
%     plt.lineplot(tav(rid,:), tse(rid,:));
% end


plt.new;
[ty, tm] = W_plt_JAGS.density(sp1.thres, -1:.1:101);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('color', col_human(end:-1:1),'ylim', [60 100], 'xlabel', 'horizon', 'ylabel','threshold',...
    'xtick',1:4,'xticklabel',[1 2 5 10]);
[tav,tse] = W.avse(st1.tthres');
plt.barplot(tav * 100', tse * 100');

plt.new;
[ty, tm] = W_plt_JAGS.density(sp1.noise, -1:.05:101);
plt.lineplot(ty,[],tm);

plt.new;
plt.setfig_ax('color', col_human(end:-1:1),'ylim', [0 30], 'xlabel', 'horizon', 'ylabel','noise',...
    'xtick',1:4,'xticklabel',[1 2 5 10]);
[tav,tse] = W.avse(st1.tnoise');
plt.barplot(tav, tse);

plt.update;
plt.addABCs([-0.06, 0.04]);
plt.save('all');


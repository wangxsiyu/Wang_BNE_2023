%% comparison between n_guided
tsub = sub(sub.nGuided< 3,:);
tgp1 = ANALYSIS_group(tsub(tsub.cond_horizon == 1  &  tsub.nGuided ==1,:));
tgp2 = ANALYSIS_group(tsub(tsub.cond_horizon == 1  &  tsub.nGuided ==0,:));
tgp3 = ANALYSIS_group(tsub(tsub.cond_horizon == 6 &  tsub.nGuided ==1,:));
tgp4 = ANALYSIS_group(tsub(tsub.cond_horizon == 6  &  tsub.nGuided ==0,:));
tgp5 = ANALYSIS_group(tsub(tsub.cond_horizon == 20 &  tsub.nGuided ==1,:));
tgp6 = ANALYSIS_group(tsub(tsub.cond_horizon == 15  &  tsub.nGuided ==0,:));
tgp = table_vertcat(tgp1, tgp2, tgp3, tgp4,tgp5, tgp6);
nG = tgp.av_nGuided;
nH = tgp.av_nFree; nH(nH == 7) = 6; nH(nH == 2)= 1; nH(nH == 16) = 15;
lgd = arrayfun(@(x)['H = '  num2str(nH(x)), ', nGuided = '  num2str(nG(x))], 1:length(nG), 'UniformOutput', false);
tcols = {'AZblue20','AZred20', 'AZblue50', 'AZred50', 'AZblue','AZred'};
% tcol = cellfun(@(x)tcol{find(strcmp(x, unique(rats)))},  rats, 'UniformOutput',false);
% cols = arrayfun(@(x)[col_rat{x} num2str(nG(x)  * 20+ 20)], 1:length(nG), 'UniformOutput', false);
% col_rat = {'AZred','AZcactus', 'AZsand', 'AZblue'};
% col_rat = cellfun(@(x)col_rat{find(strcmp(x, unique(rats)))},  rats, 'UniformOutput',false);
% cols = arrayfun(@(x)[col_rat{x} num2str(nG(x)  * 20+ 20)], 1:length(nG), 'UniformOutput', false);
%%
plt_initialize('fig_dir', '../Figures_FellousLab', 'fig_projectname', 'RatEE','fig_suffix', '01');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['rat'], 'xlabel', 'trial number', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 20.5], 'xtick', [1:20],'xticklabel',1:20, 'ylim', [0.5 1],'ytick', 0.5:0.1:1);
plt_setfig('legend', lgd,  ...
    'legloc', 'NorthWest','color', tcols);
plt_lineplot(tgp.av_trialn_ac,  tgp.ste_trialn_ac);
plt_update;
plt_save('01performance');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['rat'], 'xlabel', 'trial number', 'ylabel', 'p(switch)', ...
    'xlim', [0.5 20.5], 'xtick', [1:20],'xticklabel',1:20, 'ylim', [0 1],'ytick', 0:0.1:1);
plt_setfig('legend', lgd,  ...
    'legloc', 'NorthEast','color', tcols);
plt_lineplot(1-tgp.av_trialn_rp,  tgp.ste_trialn_rp);
plt_update;
plt_save('01switch');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['rat'], 'xlabel', 'R guided', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5, 'ylim', [0 1],'ytick', 0:0.2:1);
plt_setfig('legend', lgd, 'color', tcols,  ...
    'legloc', 'SouthEast');
plt_lineplot(tgp.av_rcurve_ac,  tgp.ste_rcurve_ac);
plt_update;
plt_save('01performance_r');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['rat'], 'xlabel', 'R guided', 'ylabel', 'p(explore)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5, 'ylim', [0 1],'ytick', 0:0.2:1);
plt_setfig('legend', lgd, 'color', tcols,  ...
    'legloc', 'NorthEast');
plt_lineplot(1- tgp.av_rcurve_ee,  tgp.ste_rcurve_ee);
plt_update;
plt_save('01switch_r');
plt_initialize('fig_dir', '../Figures_FellousLab', 'fig_projectname', 'RatEE');
%% model fit
% plt_figure(1,2, 'istitle',1);
% plt_setfig('new','title', {'directed exploration','random exploration'}, 'xlabel', 'horizon', 'ylabel', {'threshold', 'noise'}, ...
%     'xlim', {[0.5 3.5],[0.5 3.5]}, 'xtick', {[1:3],1:3},'xticklabel',{[1 6 20], [1 6 20]}, ...
%     'color', {'AZred','AZred'});
% plt_new;
% plt_lineplot(gp.av_thres',  gp.ste_thres');
% plt_new;
% plt_lineplot(gp.av_noise',  gp.ste_noise');
% plt_update;
%% trial number
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['rat'], 'xlabel', 'trial number', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 20.5], 'xtick', [1:20],'xticklabel',1:20, 'ylim', [0.5 1],'ytick', 0.5:0.1:1);
cols = 'AZblue';
lgd = arrayfun(@(x) ['H = ' num2str(x)], [1 6 20], 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', {[cols '50'], cols},  ...
    'legloc', 'SouthEast');
plt_lineplot(gp.av_trialn_ac,  gp.ste_trialn_ac);
plt_update;
plt_save('performance');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['rat'], 'xlabel', 'trial number', 'ylabel', 'p(switch)', ...
    'xlim', [0.5 20.5], 'xtick', [1:20],'xticklabel',1:20, 'ylim', [0 1],'ytick', 0:0.1:1);
cols = 'AZblue';
lgd = arrayfun(@(x) ['H = ' num2str(x)], [1 6 20], 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', {[cols '50'], cols},  ...
    'legloc', 'NorthEast');
plt_lineplot(1-gp.av_trialn_rp,  gp.ste_trialn_rp);
plt_update;
plt_save('prepeat');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['rat'], 'xlabel', 'trial number', 'ylabel', 'reaction time (s)', ...
    'xlim', [0.5 20.5], 'xtick', [1:20],'xticklabel',1:20, 'ylim', [0 5], 'ytick', 0:1:5);
cols = 'AZblue';
lgd = arrayfun(@(x) ['H = ' num2str(x)], [1 6 20], 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', {[cols '50'], cols},  ...
    'legloc', 'SouthEast');
plt_lineplot(gp.av_trialn_rt,  gp.ste_trialn_rt);
plt_update;
plt_save('rt');
%% rcurve
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['last choice'], 'xlabel', 'R guided', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5, 'ylim', [0 1],'ytick', 0:0.2:1);
cols = 'AZblue';
lgd = arrayfun(@(x) ['H = ' num2str(x)], [1 6 20], 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', {[cols '50'], cols},  ...
    'legloc', 'SouthEast');
plt_lineplot(gp.av_rcurve_ac,  gp.ste_rcurve_ac);
plt_update;
plt_save('performance_r');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['first choice'], 'xlabel', 'R guided', 'ylabel', 'p(correct)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5, 'ylim', [0 1],'ytick', 0:0.2:1);
cols = 'AZblue';
lgd = arrayfun(@(x) ['H = ' num2str(x)], [1 6], 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', {[cols '50'], cols},  ...
    'legloc', 'SouthEast');
plt_lineplot(gp.av_rcurve_ac1,  gp.ste_rcurve_ac1);
plt_update;
plt_save('performance_r1');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['rat'], 'xlabel', 'R guided', 'ylabel', 'p(explore)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5, 'ylim', [0 1],'ytick', 0:0.2:1);
cols = 'AZblue';
lgd = arrayfun(@(x) ['H = ' num2str(x)], [1 6 20], 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', {[cols '50'], cols},  ...
    'legloc', 'SouthEast');
plt_lineplot(1-gp.av_rcurve_ee,  gp.ste_rcurve_ee);
plt_update;
plt_save('prepeat_r');
%%
plt_figure(1,1, 'istitle', 1);
plt_new;
plt_setfig('title', ['rat'], 'xlabel', 'R guided', 'ylabel', 'reaction time (s)', ...
    'xlim', [0.5 6.5], 'xtick', [1:6],'xticklabel',0:5, 'ylim', [0 5],'ytick', 0:1:5);
lgd = arrayfun(@(x) ['H = ' num2str(x)], [1 6 20], 'UniformOutput', false);
plt_setfig('legend', lgd, 'color', {[cols '50'], cols},  ...
    'legloc', 'SouthEast');
plt_lineplot(gp.av_rcurve_rt,  gp.ste_rcurve_rt);
plt_update;
plt_save('rt_r');
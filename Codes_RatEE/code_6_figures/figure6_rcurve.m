function figure6_rcurve(plt,rat,human)
col_rat = {'AZcactus', 'AZred', 'AZblue'};
leg_rat = strcat("H = ",rat.gp.group_analysis.cond_horizon);
col_human = {'AZcactus', 'AZred', 'AZsky','AZblue'};
leg_human = strcat("H = ",human.gp.group_analysis.cond_horizon);
plt.figure(2,2,'istitle','gap',[0.07 0.1], 'margin', [0.1 0.13 0.05 0.02]);
% plt.figure(2,3,'gap',{[0.08], [0.1 0.08]}, 'margin', [0.12, 0.13, 0.05, 0.02], ...
%     'rect', [0.12 0.05 0.65 0.7]);
plt.setup_pltparams('fontsize_face', 20);
% plt.setfig([1:3 4:6],'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
%     'ylim', [0 1], 'ytick', 0:0.2:1, ...
%     'legord', 'reverse', 'legloc', 'SouthWest',...
%     'color',{col_human,col_human,col_human,col_rat,col_rat,col_rat}, ...
%     'legend',{leg_human,leg_human,leg_human,leg_rat,leg_rat,leg_rat}, ...
%     'xlabel', {'','','','guided reward', 'guided reward','guided reward'}, ...
%     'ylabel', {{'human','p(high reward)','last choice'},{'p(high reward)','1st choice'},'p(explore)',...
%         {'rat','p(high reward)','last choice'},{'p(high reward)','1st choice'},'p(explore)'});
plt.setfig([2 1 4 3],'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
    'ylim', [0 1], 'ytick', 0:0.2:1, ...
    'legord', 'reverse', 'legloc', 'SouthWest',...
    'color',{col_human,col_human,col_rat,col_rat}, ...
    'legend',{leg_human,leg_human,leg_rat,leg_rat}, ...
    'xlabel', {'','','guided reward', 'guided reward'}, ...
    'ylabel', {{'p(high reward)','last choice'},{'human','p(high reward)','1st choice'},...
        {'p(high reward)','last choice'},{'rat','p(high reward)','1st choice'}});
plt.new;
plt.lineplot(human.gp.av_bin_all_c1_cc_best, human.gp.ste_bin_all_ce_cc_best);
plt.new;
plt.lineplot(human.gp.av_bin_all_ce_cc_best, human.gp.ste_bin_all_c1_cc_best);
% plt.new;
% plt.lineplot(human.gp.av_bin_all_c1_cc_explore, human.gp.ste_bin_all_c1_cc_explore);

% plt.new;
% plt.setfig_ax('xlabel', 'horizon', 'ylabel', {'human', 'p(high reward)','last choice'}, 'xtick',1:4, 'xticklabel', [1 2 5 10],...
%     'color', col_human(end:-1:1), 'xlim', [],'ylim',[.5 1]);
% plt.barplot(W.nan_get(human.gp.av_av_cc_best(end:-1:1,:),1),W.nan_get(human.gp.ste_av_cc_best(end:-1:1,:),1));
% 
% plt.new;
% plt.setfig_ax('xlabel', 'horizon', 'ylabel', {'p(high reward)','1st choice'}, 'xtick',1:4, 'xticklabel', [1 2 5 10],...
%     'color',col_human(end:-1:1),'xlim', [],'ylim',[.5 1]);
% plt.barplot(human.gp.av_av_cc_best(end:-1:1,1)',human.gp.ste_av_cc_best(end:-1:1,1)');
% 
% plt.new;
% plt.setfig_ax('xlabel', 'horizon', 'ylabel', 'p(explore)', 'xtick',1:4, 'xticklabel', [1 2 5 10],...
%     'color',col_human(end:-1:1),'xlim', [],'ylim',[.4 .8],'ytick',0.4:.2:.8);
% plt.barplot(human.gp.av_av_cc_explore(end:-1:1,1)',human.gp.ste_av_cc_explore(end:-1:1,1)');


plt.new;
plt.lineplot(rat.gp.av_bin_all_c1_cc_best, rat.gp.ste_bin_all_ce_cc_best);
plt.new;
plt.lineplot(rat.gp.av_bin_all_ce_cc_best, rat.gp.ste_bin_all_c1_cc_best);
% plt.new;
% plt.lineplot(rat.gp.av_bin_all_c1_cc_explore, rat.gp.ste_bin_all_c1_cc_explore);


% plt.new;
% plt.setfig_ax('xlabel', 'horizon', 'ylabel', {'rat', 'p(high reward)','last choice'}, 'xtick',[1 2 3], 'xticklabel', [1 6 15],...
%     'color', col_rat(end:-1:1), 'xlim', [],'ylim',[.5 1]);
% plt.barplot(W.nan_get(rat.gp.av_av_cc_best(end:-1:1,:),1),W.nan_get(rat.gp.ste_av_cc_best(end:-1:1,1),1),[1 2 3]);
% 
% plt.new;
% plt.setfig_ax('xlabel', 'horizon', 'ylabel', {'p(high reward)','1st choice'}, 'xtick',[1 2 3], 'xticklabel', [1 6 15],...
%     'color', col_rat(end:-1:1),'xlim', [],'ylim',[.5 1]);
% plt.barplot(rat.gp.av_av_cc_best(end:-1:1,1)',rat.gp.ste_av_cc_best(end:-1:1,1)',[1 2 3]);
% 
% plt.new;
% plt.setfig_ax('xlabel', 'horizon', 'ylabel', 'p(explore)', 'xtick',[1 2 3], 'xticklabel', [1 6 15],...
%     'color', col_rat(end:-1:1),'xlim', [],'ylim',[.4 .8],'ytick',0.4:.2:.8);
% plt.barplot(rat.gp.av_av_cc_explore(end:-1:1,1)',rat.gp.ste_av_cc_explore(end:-1:1,1)',[1 2 3]);

plt.update;
plt.addABCs([-0.05, 0.04]);
plt.save('rcurve');
end
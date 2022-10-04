function figure4_basic(plt, rat, human)
col_rat = {'AZcactus', 'AZred', 'AZblue'};
leg_rat = strcat("H = ",rat.gp.group_analysis.cond_horizon);
col_human = {'AZcactus', 'AZred', 'AZsky','AZblue'};
leg_human = strcat("H = ",human.gp.group_analysis.cond_horizon);


plt.figure(2,2,'istitle','gap',[0.07 0.1], 'margin', [0.1 0.13 0.05 0.02]);
plt.setfig('color', {col_human, col_human, col_rat , col_rat}, ...
    'xlabel', {'','','trial number','trial number'}, 'legord', 'reverse', ...
    'ylabel', {{'human';'p(high reward)'}, 'p(switch)',{'rat';'p(high reward)'},'p(switch)'}, 'legloc', 'NorthEast', ...
    'legend', {leg_human, leg_human, leg_rat, leg_rat}, ...
    'xlim', [0.5 15.5], 'ylim', {[0.5 1],[0 1],[0.5 1],[0 1]}, ...
    'ytick', {0.5:0.1:1, 0:0.2:1, 0.5:0.1:1, 0:0.2:1});
plt.new;
plt.lineplot(ff(human.gp.av_av_cc_best), ff(human.gp.ste_av_cc_best));
plt.new;
plt.lineplot(ff(human.gp.av_av_cc_switch), ff(human.gp.ste_av_cc_switch));
plt.new;
plt.lineplot(ff(rat.gp.av_av_cc_best), ff(rat.gp.ste_av_cc_best));
plt.new;
plt.lineplot(ff(rat.gp.av_av_cc_switch), ff(rat.gp.ste_av_cc_switch));
plt.addABCs([-0.07 0.05],'ABCD');
plt.update;
plt.save('ac_sw');
end
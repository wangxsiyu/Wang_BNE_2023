function figure7_rcurve_switch(plt,rat,human)
col_rat = {'AZcactus', 'AZred', 'AZblue'};
leg_rat = strcat("H = ",rat.gp.group_analysis.cond_horizon);
col_human = {'AZcactus', 'AZred', 'AZsky','AZblue'};
leg_human = strcat("H = ",human.gp.group_analysis.cond_horizon);

plt.figure(2,2,'istitle','gap',[0.07 0.1], 'margin', [0.1 0.13 0.05 0.02]);

plt.setfig([1 3],'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
    'ylim', [0 1], 'ytick', 0:0.2:1, ...
    'legord', 'reverse', 'legloc', 'SouthWest',...
    'color',{col_human, col_rat}, ...
    'legend',{leg_human, leg_rat}, ...
    'xlabel', {'','guided reward'}, ...
    'ylabel', {{'human','p(explore)'},...
        {'rat','p(explore)'}});


plt.new;
plt.lineplot(human.gp.av_bin_all_c1_cc_explore, human.gp.ste_bin_all_c1_cc_explore);

plt.new;
plt.setfig_ax('xlabel', '', 'ylabel', 'p(explore)', 'xtick',1:4, 'xticklabel', [1 2 5 10],...
    'color',col_human(end:-1:1),'xlim', [],'ylim',[.4 .8],'ytick',0.4:.2:.8);
plt.barplot(human.gp.av_av_cc_explore(end:-1:1,1)',human.gp.ste_av_cc_explore(end:-1:1,1)');

cc = human.sub.av_cc_explore(:,1);
hh = human.sub.cond_horizon;
% [~,pp]=ttest(cc(hh==1 & gg==0)-cc(hh==6 & gg==0))
% [~,pp]=ttest(cc(hh==1 & gg==1)-cc(hh==6 & gg==1))
% [~,pp]=ttest(cc(hh==1 & gg==3)-cc(hh==6 & gg==3))
rid = arrayfun(@(x) find(ismember(unique(human.sub.rat), x)),human.sub.rat);
anovan(cc, [hh rid], 'random', 2)

cc = human.sub.bin_all_c1_cc_explore;
cc = reshape(cc,[],1);
tt = [cc, repmat(hh, 6,1),reshape(repmat(0:5, length(hh),1),[],1), repmat(rid, 6,1)];
tt = tt(~isnan(cc),:);
anovan(tt(:,1), tt(:,2:4),'random',3,'model','interaction')


plt.new;
plt.lineplot(rat.gp.av_bin_all_c1_cc_explore, rat.gp.ste_bin_all_c1_cc_explore);


plt.new;
plt.setfig_ax('xlabel', 'horizon', 'ylabel', 'p(explore)', 'xtick',[1 2 3], 'xticklabel', [1 6 15],...
    'color', col_rat(end:-1:1),'xlim', [],'ylim',[.4 .8],'ytick',0.4:.2:.8);
plt.barplot(rat.gp.av_av_cc_explore(end:-1:1,1)',rat.gp.ste_av_cc_explore(end:-1:1,1)',[1 2 3]);

cc = rat.sub.av_cc_explore(:,1);
hh = rat.sub.cond_horizon;
rid = arrayfun(@(x) find(ismember(unique(rat.sub.rat), x)),rat.sub.rat);
anovan(cc, [hh rid])

cc = rat.sub.bin_all_c1_cc_explore;
cc = reshape(cc,[],1);
tt = [cc, repmat(hh, 6,1),reshape(repmat(0:5, length(hh),1),[],1), repmat(rid, 6,1)];
tt = tt(~isnan(cc),:);
anovan(tt(:,1), tt(:,2:4),'random',3)

plt.update;
plt.addABCs([-0.06, 0.04]);
plt.save('rcurve_explore');
end
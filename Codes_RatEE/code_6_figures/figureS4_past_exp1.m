function figureS3_past_exp1(plt, human, rat)

col_rat = {'AZcactus', 'AZred', 'AZblue'};
leg_rat = strcat("H = ",{'1','6','15'});
col_human = {'AZcactus', 'AZred', 'AZsky','AZblue'};
leg_human = strcat("H = ",{'1','2','5','10'});
plt.figure(2,2,'matrix_hole',[1 0;1 1],'margin',[0.15 0.15 0.05 0.05]);
plt.setfig('xlabel',{'\alpha_{LG}','\alpha_{LG}','\alpha_{LS}'},...
    'ylabel', {{'Human','p(unguided)'},...
    {'Rat','p(unguided)'},'p(unguided)'})
for i = 1:1
    plt.new;
    plt.setfig_ax('xlim', [0.5 8.5-i], 'xtick', 1:(8-i), 'xticklabel', W.iif(i == 1,{'NaN',0:5},0:5), ...
        'ylim', [0 1], 'ytick', 0:0.2:1, ...
        'legord', 'reverse', 'legloc', 'SouthWest',...
        'color',col_human, ...
        'legend',leg_human);
    if i == 1
        plt.lineplot(human.gp.av_LG_bin_all_c1_cc_explore, human.gp.ste_LG_bin_all_c1_cc_explore);
    else
        tt = human.gp.av_LS_bin_all_c1_cc_explore;
        tt(0 ==human.gp.ste_LS_bin_all_c1_cc_explore) = NaN;
        plt.lineplot(tt(:,2:end), rat.gp.ste_LS_bin_all_c1_cc_explore(:,2:end));
    end
end
for i = 1:2
    plt.new;
    plt.setfig_ax('xlim', [0.5 8.5-i], 'xtick', 1:(8-i), 'xticklabel', W.iif(i == 1,{'NaN',0:5},0:5), ...
        'ylim', [0 1], 'ytick', 0:0.2:1, ...
        'legord', 'reverse', 'legloc', 'SouthWest',...
        'color',col_rat, ...
        'legend',leg_rat);
    if i == 1
        plt.lineplot(rat.gp.av_LG_bin_all_c1_cc_explore, rat.gp.ste_LG_bin_all_c1_cc_explore);
    else
        tt = rat.gp.av_LS_bin_all_c1_cc_explore;
        tt(0 ==rat.gp.ste_LS_bin_all_c1_cc_explore) = NaN;
        plt.lineplot(tt(:,2:end), rat.gp.ste_LS_bin_all_c1_cc_explore(:,2:end));
    end
end
plt.update;
plt.save('past_exp1')
end
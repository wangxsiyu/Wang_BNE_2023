function figure5_split(plt, rat, human)

%% colors
col_rat = {'AZcactus', 'AZred', 'AZblue'};
leg_rat = strcat("H = ",rat.gp.group_analysis.cond_horizon);
col_human = {'AZcactus', 'AZred', 'AZsky','AZblue'};
leg_human = strcat("H = ",human.gp.group_analysis.cond_horizon);

% compute t-stat

tstat_ratcb = ratlinetstat(rat.sub.gp_av_cc_best, rat.sub.cond_horizon);
tstat_ratcb = tstat_ratcb(:, 1:15);
tstat_humancb = ratlinetstat(human.sub.gp_av_cc_best, human.sub.cond_horizon);
tstat_ratsw = ratlinetstat(rat.sub.gp_av_cc_switch, rat.sub.cond_horizon);
tstat_ratsw = tstat_ratsw(:, 1:15);
tstat_humansw = ratlinetstat(human.sub.gp_av_cc_switch, human.sub.cond_horizon);
tylm = [0 1.05];
plt.figure(4,4,'matrix_hole',[1 1 1 1; 1 0 1 1;1 1 1 1; 1 0 1 1],'rect',[0 0 0.6 0.9], ...
    'gap',{[0.05 0.14 0.05],[0.05 0.05 0.05]}, 'margin', [0.1 0.1 0.05 0.02],...
    'ax_ratio', [1 2 6 15;1 2 6 15;1 2 6 15;1 2 6 15]);
plt.setup_pltparams('fontsize_leg', 7, 'fontsize_face', 20,'legend_linewidth', [18 10]);
plt.setfig('gap_sigstarx', -0.2, 'gap_sigstary', 0.03);
colall = {'AZblue50','AZblue','AZsky50','AZsky','AZred50','AZred','AZcactus50','AZcactus'};
plt.setfig([1:4 8:11],'ylabel', {{'human';'(high reward)'},'','','',...
    {'human';'p(switch)'},'','',''}, ...
    'ylim', {tylm,tylm,tylm,tylm,tylm,tylm,tylm,tylm}, ...
    'xlabel', {'','trial #','','','','trial #','',''}, ...
    'xlim', {[0.5 1.5],[0.5 2.5],[0.5 6.5],[0.5 15.5],[0.5 1.5],[0.5 2.5],[0.5 6.5],[0.5 15.5]}, ...
    'color', {{'AZblue50','AZblue'},{'AZsky50','AZsky'},{'AZred50','AZred'},{'AZcactus50','AZcactus'},...
    {'AZblue50','AZblue'},{'AZsky50','AZsky'},{'AZred50','AZred'},{'AZcactus50','AZcactus'}},...
    'legloc', {'SouthEast','SouthEast','SouthEast','SouthEast','NorthEast','NorthEast','NorthEast','NorthEast'}, ...
    'title', {'H = 1', 'H = 2', 'H = 5', 'H = 10','H = 1', 'H = 2', 'H = 5', 'H = 10'}, ...
    'xtick',{1, 1:2, 2:2:6, 5:5:15, 1, 1:2, 2:2:6, 5:5:15},'xticklabel',{{},{1:2},{},{},{},{1:2},{},{}});
plt.setfig([5:7 12:14], 'ylabel', {{'rat';'p(high reward)'},'','',...
    {'rat';'p(switch)'},'',''}, ...
    'ylim', {tylm,tylm,tylm,tylm,tylm,tylm}, ...
    'xlabel', 'trial #', ...
    'xlim', {[0.5 1.5],[0.5 6.5],[0.5 15.5],[0.5 1.5],[0.5 6.5],[0.5 15.5]}, ...
    'color', {{'AZblue50','AZblue'},{'AZred50','AZred'},{'AZcactus50','AZcactus'},...
    {'AZblue50','AZblue'},{'AZred50','AZred'},{'AZcactus50','AZcactus'}},...
    'legloc', {'SouthEast','SouthEast','SouthEast','NorthEast','NorthEast','NorthEast'}, ...
    'title', {'H = 1', 'H = 6', 'H = 15','H = 1', 'H = 6', 'H = 15'}, ...
    'xtick', {1, 2:2:6, 5:5:15, 1, 2:2:6, 5:5:15},'xticklabel',{1, 2:2:6, 5:5:15, 1, 2:2:6, 5:5:15});
tav = ff(human.gp.av_gp_av_cc_best);
tse = ff(human.gp.ste_gp_av_cc_best);
for i = 1:4
    rid = [((5-i) * 2 -1),(5-i) * 2];
    plt.new;
    if i == 4
        plt.setfig_ax('color',colall);
        for j = 1:6
            plt.lineplot(100,1);
        end
    end
    plt.lineplot(tav(rid,:), tse(rid,:));%,[],[],tstat_humancb(i,:));
    if i == 4 
        [lgd] = columnlegend(4,  {" "," "," "," "," "," ",'guided = bad', 'guided = good'}');
        lgd.Position = [0.6519 0.6111 0.3681 0.2525];
        lgd.FontSize = plt.param_figsetting.fontsize_leg;
    end
end
tav = ff(rat.gp.av_gp_av_cc_best);
tse = ff(rat.gp.ste_gp_av_cc_best);
for i = 1:3
    rid = [((4-i) * 2 -1),(4-i) * 2];
    plt.new;
    if i == 3
        plt.setfig_ax('color',[{'white','white'},colall([1 2 5:8])]);
        for j = 1:6
            plt.lineplot(100,1);
        end
    end
    plt.lineplot(tav(rid,:), tse(rid,:));%,[],[],tstat_ratcb(i,:));
    if i == 3
        [lgd] = columnlegend(4,  {" "," "," "," "," "," ",'guided = bad', 'guided = good'}');
        lgd.Position = [0.6519 0.4111 0.3681 0.2525];
        lgd.FontSize = plt.param_figsetting.fontsize_leg;
    end
end
tav = ff(human.gp.av_gp_av_cc_switch);
tse = ff(human.gp.ste_gp_av_cc_switch);
for i = 1:4
    rid = [((5-i) * 2 -1),(5-i) * 2];
    plt.new;
    if i == 4
        plt.setfig_ax('color',colall);
        for j = 1:6
            plt.lineplot(100,1);
        end
    end
    plt.lineplot(tav(rid,:), tse(rid,:));%,[],[],tstat_humansw(i,:));
    if i == 4 
        [lgd] = columnlegend(4,  {" "," "," "," "," "," ",'guided = bad', 'guided = good'}');
        lgd.Position = [0.6519 0.2011 0.3681 0.2525];
        lgd.FontSize = plt.param_figsetting.fontsize_leg;
    end
end
tav = ff(rat.gp.av_gp_av_cc_switch);
tse = ff(rat.gp.ste_gp_av_cc_switch);
for i = 1:3
    rid = [((4-i) * 2 -1),(4-i) * 2];
    plt.new;
    if i == 3
        plt.setfig_ax('color',[{'white','white'},colall([1 2 5:8])]);
        for j = 1:6
            plt.lineplot(100,1);
        end
    end
    plt.lineplot(tav(rid,:), tse(rid,:));%,[],[],tstat_ratsw(i,:));
    if i == 3
        [lgd] = columnlegend(4,  {" "," "," "," "," "," ",'guided = bad', 'guided = good'}');
        lgd.Position = [0.6519 0.0011 0.3681 0.2525];
        lgd.FontSize = plt.param_figsetting.fontsize_leg;
%         lgd. = plt.param_figsetting.fontsize_leg;
    end
end
plt.update;
plt.addABCs([-0.09, 0.04],'A   B  C   D  ');
plt.save('split_gb');
end
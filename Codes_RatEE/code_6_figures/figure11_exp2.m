function figure11_exp2(plt, gp, sub)
gp = gp(gp.av_n_guided <=1,:);
gp = sortrows(gp, {'av_cond_horizon','av_n_guided'});
plt.figure(2,3,'matrix_hole', [1 1 0;1 1 1],'gap',[0.15 0.08]);
plt.setfig_new;
legs = {'H = 6, guided', 'H = 6, free', 'H = 1, guided', 'H = 1, free'};
col = {'AZred50','AZred','AZblue50','AZblue'};
col = col(end:-1:1);
plt.setfig([1 2],'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 1:6, ...
    'ylim', {[0.4 0.8],[0 0.8]}, 'ytick', {0:0.1:1, 0:0.2:1}, ...
    'legloc', 'SouthWest',...
    'color', col, 'legloc', {'SouthEast','NorthEast'}, ...
    'xlabel', 'trial number', ...
    'ylabel', {'p(high reward)', 'p(switch)'}, 'legend', legs(end:-1:1));
tid = [1 1 1 1] == 1;%gp.av_cond_guided <= 1;
plt.ax(1,1);
tp = gp.av_av_cc_best;
tp_se = gp.ste_av_cc_best;
plt.lineplot(tp(tid,:), tp_se(tid,:));
plt.ax(1,2);
tp = gp.av_av_cc_switch;
tp_se = gp.ste_av_cc_switch;
plt.lineplot(tp(tid,:), tp_se(tid,:));


tav = gp.av_av_cc_explore(:,1)';
tse = gp.ste_av_cc_explore(:,1)';
plt.ax(2,3);
plt.setfig_ax('xlabel','horizon','ylabel','p(explore)',...
    'color',col, ...
    'xtick',[1.5 4.5],'xticklabel', [1 6],'ylim', [0 0.7]);
plt.barplot(tav, tse, [1 2 4 5]);
cc = sub.av_cc_explore(:,1);
hh = sub.cond_horizon;
gg = sub.cond_guided;
rid = arrayfun(@(x) find(ismember(unique(sub.rat), x)),sub.rat);
tt = [cc,hh,gg,rid];
tid = gg <= 1;
anovan(tt(tid,1), tt(tid,2:4), 'random', 3)





% plt.update;
% guided vs free - rcurve
hzs = [1 6];
tlt = W.arrayfun(@(x)sprintf('H = %d', x), hzs);
nfig = length(hzs);
% plt.figure(1,nfig, 'istitle', 'margin', [0.2 0.07 0.1 0.01],'gap',[0.05 0.07]);
% plt.setfig_new;
col = {{'AZblue', 'AZblue50'},{'AZred', 'AZred50'}};
plt.setfig([3 4],'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
    'ylim', [0 1], 'ytick', 0:0.2:1, 'legord', 'reverse', 'legloc', 'SouthWest',...
    'color', col, ...
    'xlabel', 'guided reward', ...
    'ylabel', 'p(explore)', 'legend', {{'free','guided'},{'free','guided'}}, ...
    'title', tlt);
tp = gp.av_bin_all_c1_cc_explore;
tp_se = gp.ste_bin_all_c1_cc_explore;
for i = 1:length(hzs)
    plt.ax(2,i);
    tid = gp.av_cond_horizon == hzs(i);
    plt.lineplot(tp(tid,:), tp_se(tid,:));
end
plt.update;
plt.addABCs([-0.05 0.05], 'ABC D');
plt.save('guidefree');
end
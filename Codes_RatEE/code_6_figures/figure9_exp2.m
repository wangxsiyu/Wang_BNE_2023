function figure9_exp2(plt, gp, sub, sp, st)
% tstat = ratlinetstat_h16(sub.bin_all_c1_cc_explore, sub.cond_horizon, sub.cond_guided);
gds = [0 1 3];
tlt = W.arrayfun(@(x)sprintf('nGuided = %d', x), gds);
nfig = length(gds);
% plt.figure(3,4, 'matrix_hole', [1 1 1 1; 1 1 1 1; 1 1 1 1], 'istitle','rect', [0 0 0.7 0.9],...
%     'margin', [0.1 0.1 0.06 0.01],'gap',{[0.1 0.1], [0.07 0.07 0.07]});
plt.figure(4,4, 'matrix_hole', [1 1 1 1; 1 1 1 1; 1 1 1 1;1 1 0 0], 'istitle',...
    'rect', [0 0 0.6 0.9],...
    'margin', [0.08 0.08 0.03 0.01],'gap',{[0.1 0.1 0.1]-0.01, [0.07 0.07 0.07]});
plt.setup_pltparams('fontsize_face',18,'fontsize_leg',8,'legend_linewidth',[15 8]);
% plt.setfig_new;
rgr = {[0 5], [0 5],[0 5], [0 10],[0 10],[0 10]};
plt.setfig([4:6, 8:10]+1,'color', {'AZblue','AZred'}, ...
    'legend',{'H = 1','H = 6'}, 'xlim', rgr, ...
    'xlabel', {'threshold', 'threshold', 'threshold', 'noise', 'noise', 'noise'}, ...
    'ylabel', 'density',...
    'legloc',{'NorthEast','NorthWest','NorthWest','NorthEast','NorthEast','NorthEast'});
% plt.setfig(8:10, 'ylim', {[0 0.3], [0 0.25], [0 0.4]});
plt.setfig(1:3,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
    'ytick', 0:0.2:1, 'legord', 'reverse', 'legloc', 'SouthWest',...
    'color', {'AZred', 'AZblue'}, ...
    'xlabel', 'guided reward', ...
    'ylabel', 'p(explore)', 'legend', {'H = 6', 'H = 1'}, ...
    'title', tlt, ...
    'ylim', [0 1],...
    'ytick',0:.5:1);
% tp = gp.av_av_cc_switch;
% tp_se = gp.ste_av_cc_switch;
% for i = 1:length(gds)
%     plt.ax(1,i);
%     tid = gp.av_cond_guided == gds(i);
%     plt.lineplot(tp(tid,:), tp_se(tid,:));
% end
tp = gp.av_bin_all_c1_cc_explore;
tp_se = gp.ste_bin_all_c1_cc_explore;
for i = 1:length(gds)
    plt.new;
    tid = gp.av_cond_guided == gds(i);
    plt.lineplot(tp(tid,:), tp_se(tid,:));
end

cc = sub.av_cc_explore(:,1);
hh = sub.cond_horizon;
gg = sub.cond_guided;
% [~,pp]=ttest(cc(hh==1 & gg==0)-cc(hh==6 & gg==0))
% [~,pp]=ttest(cc(hh==1 & gg==1)-cc(hh==6 & gg==1))
% [~,pp]=ttest(cc(hh==1 & gg==3)-cc(hh==6 & gg==3))
rid = arrayfun(@(x) find(ismember(unique(sub.rat), x)),sub.rat);
anovan(cc, [hh gg rid], 'random', 3)


tav = gp.av_av_cc_explore([4 1 6 3 5 2 ],1);
tse = gp.ste_av_cc_explore([4 1 6 3 5 2 ],1);
x = [1 2 4 5 7 8];
plt.ax(1,4);
plt.setfig_ax('xlabel','nGuided','ylabel','p(explore)',...
    'color',{'AZblue','AZred','AZblue','AZred','AZblue','AZred'}, ...
    'xtick',[1.5 4.5 7.5],'xticklabel', [0 1 3],'ylim', [0.2 .8], 'ytick',0.2:.2:.8);
plt.barplot(tav', tse', x);


plt.ax(2,4);
tall = [];
for i = 1:3
    [tav([2*i-1 2*i]),tse([2*i-1 2*i])] = W.avse(squeeze(st.stats.mean.tthres(i,:,:))');
    ttee = [reshape(squeeze(st.stats.mean.tthres(i,:,:))',[],1),[ones(4,1);zeros(4,1)], ones(8,1)*i, [1:4,1:4]'];
    tall = vertcat(tall, ttee);
end
anovan(tall(:,1), tall(:,2:4), 'random', 3)

plt.setfig_ax('xlabel','nGuided','ylabel','threshold',...
    'color',{'AZblue','AZred','AZblue','AZred','AZblue','AZred'}, ...
    'xtick',[1.5 4.5 7.5],'xticklabel', [0 1 3],'ylim', [0 5]);
plt.barplot(tav'*5, tse'*5, x);


plt.ax(3,4);
tall = [];
for i = 1:3
    [tav([2*i-1 2*i]),tse([2*i-1 2*i])] = W.avse(squeeze(st.stats.mean.tnoise(i,:,:))');
%     [~,pp(i)]=ttest(diff(squeeze(st.stats.mean.tnoise(i,:,:)))');
ttee = [reshape(squeeze(st.stats.mean.tnoise(i,:,:))',[],1),[ones(4,1);zeros(4,1)], ones(8,1)*i, [1:4,1:4]'];
    tall = vertcat(tall, ttee);
end
anovan(tall(:,1), tall(:,2:4), 'random', 3)

plt.setfig_ax('xlabel','nGuided','ylabel','noise',...
    'color',{'AZblue','AZred','AZblue','AZred','AZblue','AZred'}, ...
    'xtick',[1.5 4.5 7.5],'xticklabel', [0 1 3],'ylim', [0 5]);
plt.barplot(tav', tse', x);

% plt.figure(3,3,'rect', [0 0 0.6 0.7], 'gap', [0.2 0.1], 'margin', [0.15 0.1 0.05 0.05]);
plt.setup_pltparams('hold','linewidth',2)
[ty, tm] = W_plt_JAGS.density(sp.thres, -1:.01:21);
for i =  1:3
plt.ax(2,i);
% plt.setfig_ax('xlabel','');
plt.lineplot(ty{i} ,[],tm);
end
[ty, tm] = W_plt_JAGS.density(sp.noise, -1:.04:21);
for i = 1:3
plt.ax(3,i);
% plt.setfig_ax('xlabel','');
plt.lineplot(ty{i},[],tm);
end
% [ty, tm] = W_plt_JAGS.density(sp.bias_mu, -21:.04:21)
% for i = [3 2 1]
% plt.new;
% % plt.setfig_ax('xlabel','');
% plt.lineplot(ty{i},[],tm);
% end
% plt.update;
% plt.save('within_simple');
% %%
% % file = fullfile(hbidir, 'HBI_model_within_diff_within_all_samples.mat');
% % sp = importdata(file);
% %%
% plt.figure(2,1, 'istitle','rect', [0 0 0.2 0.6], 'gap', [0.2 0.15], ...
%     'margin', [0.15 0.25 0.05 0.05]);
rgr = {[-3 3], [-10 10]};
% str1 = sprintf('%.2f samples < 0', mean(sp.dthres(:,:,1) <= 0, 'all')*100)
% str2 = sprintf('%.2f samples < 0', mean(sp.dnoise <= 0, 'all')*100)
% plt.setfig_new;
plt.setfig([13 14], 'color', {'AZsand','AZmesa','black'}, ...
    'xlim', rgr, ...
    'ylabel', 'density', 'xlabel', {'\Delta threshold','\Delta noise'},...
    'legend', {'nGuided = 0','nGuided = 1','nGuided = 3'});
plt.ax(4,1);
[ty, tm] = W_plt_JAGS.density(sp.dthres, -10:.01:10);
plt.lineplot(ty ,[],tm);
ylm1 = get(plt.fig.axes(7),'YLim');
hold on;
plot([0 0], ylm1,'--r');
plt.ax(4,2);
[ty, tm] = W_plt_JAGS.density(sp.dnoise, -11:.04:11);
plt.lineplot(ty,[],tm);
ylm2 = get(plt.fig.axes(11),'YLim');
hold on;
plot([0 0], ylm2,'--r');
plt.update;
plt.addABCs([-0.05 0.03],'A  BC  DE  FGH');
plt.save('exp2');
% %%
% file = fullfile(hbidir, 'HBI_model_simple_between_all_stat.mat');
% st1 = importdata(file);
% file = fullfile(hbidir, 'HBI_model_simple_human_stat.mat');
% st2 = importdata(file);
end
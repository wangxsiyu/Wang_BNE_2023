%% color/legend
% %% by trial number
% plt.setfig_new;
% plt.setfig_loc(2,'xlim', [0.5 6.5], 'ylim', {[0.5 0.8], [0 1]} , ...
%     'ytick', {0.5:0.1:1, 0:0.2:1}, 'legord', 'reverse', 'legloc', {'SouthEast', 'NorthEast'});
% plt = fig_behavior_gp(plt, gp, 'av', 'trial number', col, ...
%     leg, ['gp_av']);
% %% split by good/bad
% % plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0.4 1], [0 1]},'legloc', {'NorthWest', 'NorthEast'});
% % plt = fig_behavior_gp(plt, gp, 'gp_av', 'trial number', col2, ...
% %     leg2, ['gp_acG']);
% %% R curve
% plt.setfig_new;
% plt.setfig_loc(2,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
%     'ylim', {[0 1],[0 1]}, 'ytick', {0:0.2:1, 0:0.2:1}, 'legord', 'reverse', 'legloc', 'SouthWest');
% plt = fig_behavior_gp(plt, gp, 'bin_all', 'R guided', col , ...
%     leg, ['gp_rG']);
%% average curve
% gds = [0 1 3];
% tlt = W.arrayfun(@(x)sprintf('nGuided = %d', x), gds);
% nfig = length(gds);
% plt.figure(1,nfig, 'istitle', 'margin', [0.2 0.07 0.1 0.01],'gap',[0.05 0.07]);
% plt.setfig_new;
% col = {'AZred', 'AZblue'};
% plt.setfig(nfig,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
%     'ylim', [0.5 .8], 'ytick', 0:0.2:1, 'legord', 'reverse', 'legloc', 'SouthWest',...
%     'color', col, ...
%     'xlabel', 'R guided', ...
%     'ylabel', 'p(explore)', 'legend', {'H = 6', 'H = 1'}, ...
%     'title', tlt);
% tp = gp.av_av_cc_best;
% tp_se = gp.ste_av_cc_best;
% for i = 1:length(gds)
%     plt.ax(1,i);
%     tid = gp.av_cond_guided == gds(i);
%     plt.lineplot(tp(tid,:), tp_se(tid,:));
% end
% plt.update;
% plt.save('av_best_horizon');

%%

% %%
% file = fullfile(hbidir, 'HBI_model_within_H_within_all_samples.mat');
% sp = importdata(file);
% %%
% plt.figure(2,2);
% plt.setfig('xlim', {[0 5],[0 20],[0 20],[0 1]});
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp.thres_mu, [-1:0.01:6])
% plt.lineplot(ty ,[],tm);
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp.noise, [-1:0.01:50])
% plt.lineplot(ty,[],tm);
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp.prior, [-1:0.01:50])
% plt.lineplot(ty ,[],tm);
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp.alpha, [-2:0.001:2])
% plt.lineplot(ty,[],tm);
% plt.update;
%%
% subplot(2,2,1);
% violin(reshape(sp2.thres_mu, [],4))
% ylim([0 5]);
% subplot(2,2,2);
% violin(reshape(sp1.thres_mu, [],3))
% ylim([0 5]);
% 
% subplot(2,2,3);
% violin(reshape(sp2.noise, [],4))
% ylim([0 10]);
% subplot(2,2,4);
% violin(reshape(sp1.noise, [],3))
% ylim([0 10]);
% 
% subplot(2,2,1);
% boxplot(reshape(sp2.thres_mu, [],4),'symbol', '')
% ylim([0 5]);
% subplot(2,2,2);
% boxplot(reshape(sp1.thres_mu, [],3),'symbol', '')
% ylim([0 5]);
% 
% subplot(2,2,3);
% boxplot(reshape(sp2.noise, [],4),'symbol', '')
% ylim([0 10]);
% subplot(2,2,4);
% boxplot(reshape(sp1.noise, [],3),'symbol', '')
% ylim([0 10]);
% 

% [tav, tse] = W.avse(st1.stats.mean.tthres');
% [tav2, tse2] = W.avse(st2.stats.mean.tthres');
% plt.new;
% plt.lineplot(tav, tse, [1 6 15]);
% plt.lineplot(tav2, tse2, [1 2 5 10]);
% [tav, tse] = W.avse(st1.stats.mean.tnoise');
% [tav2, tse2] = W.avse(st2.stats.mean.tnoise');
% plt.new;
% plt.lineplot(tav, tse, [1 6 15]);
% plt.lineplot(tav2, tse2, [1 2 5 10]);
function figure12_exp2(plt, sp, st)
plt.figure(2,2);
% 'istitle','rect', [0 0 0.2 0.6], 'gap', [0.2 0.15], ...
%     'margin', [0.15 0.25 0.05 0.05]);
% str1 = sprintf('%.2f samples < 0', mean(sp.dthres <= 0, 'all')*100);
% str2 = sprintf('%.2f samples < 0', mean(sp.dnoise <= 0, 'all')*100);
% plt.setfig_new;
plt.setfig([1 3],'color', {'AZblue', 'AZblue50', 'AZred', 'AZred50'}, ...
    'xlim', {[0 5], [0 12]}, ...
    'ylabel', 'density', 'xlabel', {'threshold','noise'},...
    'legend', {'H = 1, free','H = 1, guided', 'H = 6, free', 'H = 6, guided'});
plt.setfig([2 4],'color', {{'AZblue','AZred'}}, ...
    'xlim', {[-5 5], [-12 12]}, ...
    'ylabel', 'density', 'xlabel', {'\Delta threshold_{free - guided}','\Delta noise_{free - guided}'},...
    'legend', {{'H = 1, difference', 'H = 6, difference'}});
plt.new;
spt = sp.thres(:,:,1:2,:);
spt = cat(3,squeeze(spt(:,:,:,1)), squeeze(spt(:,:,:,2)));
% spt(:,:,3) = squeeze(spt(:,:,1)) + sp.dthres_mu;
% spt(:,:,4) = squeeze(spt(:,:,2)) + sp.dthres_mu;
[ty, tm] = W_plt_JAGS.density(spt, -21:.01:21);
% [ty1] = W_plt_JAGS.density(repmat(sp.dthres_mu, 1,1,2), rgr2)
% ty = ty + ty1;
plt.lineplot(ty ,[],tm);

plt.new;
spt = sp.thres(:,:,1:2,:);
spt = squeeze(spt(:,:,1,:) - spt(:,:,2,:));
[ty, tm] = W_plt_JAGS.density(spt, -21:.01:21);
plt.lineplot(ty ,[],tm);
ylm1 = get(plt.fig.axes(2),'YLim');
hold on;
plot([0 0], ylm1,'--k');

plt.new;
spt = sp.noise(:,:,1:2,:);
spt = cat(3,squeeze(spt(:,:,:,1)), squeeze(spt(:,:,:,2)));
% spt(:,:,3) = squeeze(spt(:,:,1)) + sp.dthres_mu;
% spt(:,:,4) = squeeze(spt(:,:,2)) + sp.dthres_mu;
[ty, tm] = W_plt_JAGS.density(spt, -21:.04:21);
% [ty, tm] = W_plt_JAGS.density(sp.noise(:,:,[1:2]), rgr2)
% [ty1] = W_plt_JAGS.density(sp.dnoise_mu, rgr2)
% ty = ty + ty1;
plt.lineplot(ty,[],tm);

plt.new;
spt = sp.noise(:,:,1:2,:);
spt = squeeze(spt(:,:,1,:) - spt(:,:,2,:));
[ty, tm] = W_plt_JAGS.density(spt, -21:.04:21);
plt.lineplot(ty ,[],tm);
ylm1 = get(plt.fig.axes(4),'YLim');
hold on;
plot([0 0], ylm1,'--k');
plt.addABCs([- 0.06 0.04]);
plt.update;
plt.save('bayes_guidefree');
end
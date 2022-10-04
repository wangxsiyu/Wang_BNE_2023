function figureS2_otherpos_exp1(plt,sp1,sp2)

col_rat = {'AZcactus', 'AZred', 'AZblue'};
leg_rat = strcat("H = ",{'1','6','15'});
col_human = {'AZcactus', 'AZred', 'AZsky','AZblue'};
leg_human = strcat("H = ",{'1','2','5','10'});
plt.figure(2,3,'margin',[0.15 0.12 0.05 0.05],'gap',[0.13 0.08])

plt.new;
plt.setfig_ax('legend',leg_human,...
    'color', col_human(end:-1:1),...
    'xlabel', 'bias', 'ylabel',{'human','posterior density'},...
    'xlim',[-3 3]);
[ty, tm] = W_plt_JAGS.density(sp2.bias, -10:.01:10);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('legend',leg_human,...
    'color', col_human(end:-1:1),...
    'xlabel', '\alpha_{LG}', 'ylabel','posterior density',...
    'xlim',[0 1]);
[ty, tm] = W_plt_JAGS.density(sp2.lr_last, -1:.001:1);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('legend',leg_human,...
    'color', col_human(end:-1:1),...
    'xlabel', '\alpha_{LS}', 'ylabel','posterior density',...
    'xlim',[0 1]);
[ty, tm] = W_plt_JAGS.density(sp2.lr_lastgs, -1:.005:1);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('legend',leg_rat,...
    'color', col_rat(end:-1:1),...
    'xlabel', 'bias', 'ylabel',{'rat','posterior density'},...
    'xlim',[-3 3]);
[ty, tm] = W_plt_JAGS.density(sp1.bias, -10:.01:10);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('legend',leg_rat,...
    'color', col_rat(end:-1:1),...
    'xlabel', '\alpha_{LG}', 'ylabel','posterior density',...
    'xlim',[0 1]);
[ty, tm] = W_plt_JAGS.density(sp1.lr_last, -1:.001:1);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('legend',leg_rat,...
    'color', col_rat(end:-1:1),...
    'xlabel', '\alpha_{LS}', 'ylabel','posterior density',...
    'xlim',[0 1]);
[ty, tm] = W_plt_JAGS.density(sp1.lr_lastgs, -1:.005:1);
plt.lineplot(ty ,[],tm);

plt.update;
plt.save('otherposterior_exp1');
end
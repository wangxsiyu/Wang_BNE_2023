function figure8_bayes_exp1(plt, sp1, sp2, st1,st2)% plt.figure(2,2, 'istitle','margin',[0.1 0.13 0.05 0.02]);

col_rat = {'AZcactus', 'AZred', 'AZblue'};
leg_rat = strcat("H = ",{'1','6','15'});
col_human = {'AZcactus', 'AZred', 'AZsky','AZblue'};
leg_human = strcat("H = ",{'1','2','5','10'});

plt.figure(2,4, 'istitle','gap',[0.15 0.06]);
rgr = {[0 5], [0 10], [0 5], [0 10]};
rgr2 = -1:.01:21;
plt.setfig_new;
plt.setfig([1 3 5 7],'color', {{'AZblue','AZsky', 'AZred','AZcactus'},{'AZblue','AZsky', 'AZred','AZcactus'},...
    {'AZblue', 'AZred','AZcactus'},{'AZblue', 'AZred','AZcactus'}}, ...
    'legend',{{'H = 1','H = 2','H = 5','H = 10'},{'H = 1','H = 2','H = 5','H = 10'},...
    {'H = 1','H = 6','H = 15'},{'H = 1','H = 6','H = 15'}}, 'xlim', rgr, ...
    'legloc', {'NorthWest','NorthEast','NorthWest','NorthEast'}, ...
    'xlabel', {'threshold','noise',...
    'threshold','noise'}, ...
    'ylabel',{{'human','density'},'density',{'rat','density'},'density'});
% plt.setfig('color', {{'AZblue','AZsky', 'AZred','AZcactus'},{'AZblue','AZsky', 'AZred','AZcactus'},{'AZblue','AZsky', 'AZred','AZcactus'},...
%     {'AZblue','AZsky', 'AZred','AZcactus'},{'AZblue','AZsky', 'AZred','AZcactus'},{'AZblue','AZsky', 'AZred','AZcactus'},...
%     {'AZblue', 'AZred','AZcactus'},{'AZblue', 'AZred','AZcactus'},{'AZblue', 'AZred','AZcactus'}}, ...
%     'legend',{{'H = 1','H = 2','H = 5','H = 10'},{'H = 1','H = 2','H = 5','H = 10'},{'H = 1','H = 2','H = 5','H = 10'},...
%     {'H = 1','H = 2','H = 5','H = 10'},{'H = 1','H = 2','H = 5','H = 10'},{'H = 1','H = 2','H = 5','H = 10'},...
%     {'H = 1','H = 6','H = 15'},{'H = 1','H = 6','H = 15'},{'H = 1','H = 6','H = 15'}}, 'xlim', rgr, ...
%     'legloc', {'NorthWest','NorthEast','NorthEast','NorthWest','NorthEast','NorthEast','NorthWest','NorthEast','NorthEast'}, ...
%     'xlabel', {'threshold - human','noise - human','bias - human',...
%     'threshold - human (1-5)','noise - human (1-5)','bias - human (1-5)',...
%     'threshold - rat','noise - rat','bias - rat'}, ...
%     'ylabel',{'density','','','density','','','density','',''});
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp3.thres, [-1:0.1:100])
% plt.lineplot(ty ,[],tm);
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp3.noise, [-1:0.1:100])
% plt.lineplot(ty,[],tm);
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp3.bias_mu, [-100:0.1:100])
% plt.lineplot(ty,[],tm);

plt.new;
[ty, tm] = W_plt_JAGS.density(sp2.thres, rgr2);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('color', col_human(end:-1:1),'ylim', [0 5], 'xlabel', 'horizon', 'ylabel','threshold',...
    'xtick',1:4,'xticklabel',[1 2 5 10]);
[tav,tse] = W.avse(st2.mean.tthres');
tall = [reshape(st2.mean.tthres',[],1),reshape(ones(40,1) * [1 2 3 4],[],1), repmat(1:40,1,4)'];
anovan(tall(:,1), tall(:,2:3), 'random', 2)

plt.barplot(tav*5, tse*5);

plt.new;
[ty, tm] = W_plt_JAGS.density(sp2.noise, rgr2);
plt.lineplot(ty,[],tm);
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp2.bias_mu, [-6:0.1:6])
% plt.lineplot(ty,[],tm);

plt.new;
plt.setfig_ax('color', col_human(end:-1:1),'ylim', [0 10], 'xlabel', 'horizon', 'ylabel','noise',...
    'xtick',1:4,'xticklabel',[1 2 5 10]);
[tav,tse] = W.avse(st2.mean.tnoise');
tall = [reshape(st2.mean.tnoise',[],1),reshape(ones(40,1) * [1 2 3 4],[],1), repmat(1:40,1,4)'];
anovan(tall(:,1), tall(:,2:3), 'random', 2)
plt.barplot(tav, tse);


plt.new;
[ty, tm] = W_plt_JAGS.density(sp1.thres, -1:.01:21);
plt.lineplot(ty ,[],tm);


plt.new;
plt.setfig_ax('color', col_rat(end:-1:1),'ylim', [0 5], 'xlabel', 'horizon', 'ylabel','threshold',...
    'xtick',1:3,'xticklabel',[1 6 15],'ytick',0:5);
[tav,tse] = W.avse(st1.mean.tthres');
plt.barplot(tav*5, tse*5);
tall = [reshape(st1.mean.tthres',[],1),reshape(ones(6,1) * [1 2 3],[],1), repmat(1:6,1,3)'];
tall = tall(~(tall(:,2) == 3 & ismember(tall(:,3),[2 5])),:);
anovan(tall(:,1), tall(:,2:3), 'random', 2)

plt.new;
[ty, tm] = W_plt_JAGS.density(sp1.noise, -1:.05:21);
plt.lineplot(ty,[],tm);


plt.new;
plt.setfig_ax('color', col_rat(end:-1:1),'ylim', [0 10], 'xlabel', 'horizon', 'ylabel','noise',...
    'xtick',1:3,'xticklabel',[1 6 15]);
[tav,tse] = W.avse(st1.mean.tnoise');

tall = [reshape(st1.mean.tnoise',[],1),reshape(ones(6,1) * [1 2 3],[],1), repmat(1:6,1,3)'];
anovan(tall(:,1), tall(:,2:3), 'random', 2)
plt.barplot(tav, tse);
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp1.bias_mu, [-6:0.1:6])
% plt.lineplot(ty,[],tm);
plt.update;
plt.addABCs([-0.04, 0.05]);
plt.save('bayes_density');
end
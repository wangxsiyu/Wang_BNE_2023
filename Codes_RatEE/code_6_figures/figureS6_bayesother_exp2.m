function figureS6_bayesother_exp2(plt, sp, st)

gds = [0 1 3];
tlt = W.arrayfun(@(x)sprintf('nGuided = %d', x), gds);
nfig = length(gds);
plt.figure(3,3, 'istitle',...
    'rect',[0 0 0.7 0.95],...
    'margin',[0.08 0.12 0.08 0.05],'gap',[0.1 0.1]);
plt.setup_pltparams('fontsize_face',18,'fontsize_leg',13,'fontsize_axes',16,'legend_linewidth',[15 8]);
% plt.setfig_new;
rgr = {[-5 5],[-5 5],[-5 5],[0 1], [0 1],[0 1], [0 1],[0 1],[0 1]};
plt.setfig('color', {'AZblue','AZred'}, ...
    'title',{'nG = 0','nG = 1','nG = 3','','','','','',''},...
    'legend',{'H = 1','H = 6'}, 'xlim', rgr, ...
    'xlabel', '', ...
    'ylabel', {{'bias','density'}, '','',{'\alpha_{LG}','density'}, '','',{'\alpha_{LS}','density'},'',''},...
    'legloc',{'NorthEast','NorthEast','NorthEast','NorthEast','NorthEast','NorthEast',...
    'NorthEast','NorthEast','NorthEast'});
plt.setup_pltparams('hold','linewidth',2)

[ty, tm] = W_plt_JAGS.density(sp.bias, -10:.01:10);
for i =  1:3
plt.ax(1,i);
plt.setfig_ax('ylim',[0 1]);
plt.lineplot(ty{i} ,[],tm);
% ytickangle(90);
end

[ty, tm] = W_plt_JAGS.density(sp.lr_last, -1:.001:21);
for i =  1:3
plt.ax(2,i);
% plt.setfig_ax('xlabel','');
plt.lineplot(ty{i} ,[],tm);
end
ratio =1;%mean(nanstd(data.value_lastsession))/mean(nanstd(data.value_lastgame));
[ty, tm] = W_plt_JAGS.density(sp.lr_lastgs * ratio, -1:.005:21);
for i = 1:3
plt.ax(3,i);
% plt.setfig_ax('xlabel','');
plt.lineplot(ty{i},[],tm);
end
plt.update;
plt.addABCs([-0.05 0.03]);
plt.save('all_other');
end
%%
plt = W_plt('fig_dir', '../../figures','fig_projectname', 'control','fig_saveformat', 'emf');
plt.setuserparam('param_setting', 'isshow', 1)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  RAND CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%
rat = importdata('../../data_processed/output/gp_between.mat');
ctl = importdata('../../data_processed/output/gp_control.mat');
gp = W.tab_vertcat(rat.gp(rat.gp.av_cond_horizon == 6,:), ctl.gp);
%% load samples
hbidir = '../../result_bayes';
file = fullfile(hbidir, 'HBI_model_simple_between_all_samples.mat');
file = fullfile(hbidir, 'HBI_model_simple_history_between_all_samples.mat');
sp1 = importdata(file);
file = fullfile(hbidir, 'HBI_model_simple_between_all_stat.mat');
file = fullfile(hbidir, 'HBI_model_simple_history_between_all_stat.mat');
st1 = importdata(file);
file = fullfile(hbidir, 'HBI_model_simple_1H_control_samples.mat');
file = fullfile(hbidir, 'HBI_model_simple_1H_history_control_samples.mat');
sp2 = importdata(file);
file = fullfile(hbidir, 'HBI_model_simple_1H_control_stat.mat');
file = fullfile(hbidir, 'HBI_model_simple_1H_history_control_stat.mat');
st2 = importdata(file);
%%
col = {'AZred', 'AZsand'};
leg = {'contant reward', 'random reward'};
col3 = {'AZblue','AZred','AZsand'};
leg3 = {'constant reward, H = 1','constant reward, H = 6','random reward'};
plt.figure(3,2,'margin',[0.12 0.1 0.05 0.01]);
plt.setup_pltparams('fontsize_leg',10);
plt.setfig_new;
plt.setfig(1:2,'xlim', [0.5 6.5], 'ylim', {[0 1],[0 1]} , ...
    'ytick', {0:0.5:1,[0:0.5:1]},'color', {col}, 'legend', {leg}, ...
    'legloc', {'NorthEast','SouthWest'},'xlabel',{'trial number', 'guided reward'}, ...
    'ylabel', {'p(switch)','p(explore)'});
plt.setfig(1:2, 'xtick', 1:6, 'xticklabel', {1:6,0:5});
plt.setfig([3 5],'xlim', {[0 5],[0 20]},'color', col3,...
    'legend',leg3, ...
    'legloc', {'NorthWest', 'NorthEast'}, 'xlabel', {'threshold', 'noise'}, ...
    'ylabel', 'density');
% plt.new;
% plt.lineplot(gp.av_av_cc_best, gp.ste_av_cc_best);
plt.new;
plt.lineplot(gp.av_av_cc_switch, gp.ste_av_cc_switch);
plt.new;
plt.lineplot(gp.av_bin_all_c1_cc_explore, gp.ste_bin_all_c1_cc_explore);

spt = cat(3,sp1.thres(:,:,1:2), sp2.thres);
plt.new;
plt.setfig_ax('xlim', [0 5])
[ty, tm] = W_plt_JAGS.density(spt, -1:.01:5.1);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('color', col3,'ylim', [1 5], 'xlabel', '', 'ylabel','threshold',...
    'xtick',1:3,'xticklabel',{'H = 1','H = 6','random'});
[tav,tse] = W.avse([st1.stats.mean.tthres(1:2,:)']);
[tav(3), tse(3)] = W.avse(st2.stats.mean.tthres');
plt.barplot(5*tav, 5*tse);
xtickangle(45);

spt = cat(3,sp1.noise(:,:,1:2), sp2.noise);
plt.new;
[ty, tm] = W_plt_JAGS.density(spt, -1:.04:21);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('color', col3,'ylim', [0 10], 'xlabel', '', 'ylabel','noise',...
    'xtick',1:3,'xticklabel',{'H = 1','H = 6','random'});
[tav,tse] = W.avse([st1.stats.mean.tnoise(1:2,:)']);
[tav(3), tse(3)] = W.avse(st2.stats.mean.tnoise');
plt.barplot(tav, tse);
xtickangle(45);
plt.update;
plt.addABCs([-0.07 0.05]);
plt.save('rand');
%%
%%
col = {'AZred', 'AZsand'};
leg = {'contant reward', 'random reward'};
plt.figure(3,2,'margin',[0.12 0.1 0.05 0.01]);
plt.setup_pltparams('fontsize_leg',10);
plt.setfig_new;
plt.setfig(1:2,'xlim', [0.5 6.5], 'ylim', {[0 1],[0 1]} , ...
    'ytick', {0:0.5:1,[0:0.5:1]},'color', {col}, 'legend', {leg}, ...
    'legloc', {'NorthEast','SouthWest'},'xlabel',{'trial number', 'guided reward'}, ...
    'ylabel', {'p(switch)','p(unguided)'});
plt.setfig(1:2, 'xtick', 1:6, 'xticklabel', {1:6,0:5});
plt.setfig([3 5],'xlim', {[0 5],[0 20]},'color', {col},...
    'legend',leg, ...
    'legloc', {'NorthWest', 'NorthEast'}, 'xlabel', {'threshold', 'noise'}, ...
    'ylabel', 'density');
% plt.new;
% plt.lineplot(gp.av_av_cc_best, gp.ste_av_cc_best);
plt.new;
plt.lineplot(gp.av_av_cc_switch, gp.ste_av_cc_switch);
plt.new;
plt.lineplot(gp.av_bin_all_c1_cc_explore, gp.ste_bin_all_c1_cc_explore);

spt = cat(3,sp1.thres(:,:,2), sp2.thres);
plt.new;
plt.setfig_ax('xlim', [0 5])
[ty, tm] = W_plt_JAGS.density(spt, -1:.01:5.1);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('color', col,'ylim', [1 5], 'xlabel', '', 'ylabel','threshold',...
    'xtick',1:2,'xticklabel',{'constant','random'});
[tav,tse] = W.avse([st1.stats.mean.tthres(2,:)']);
[tav(2), tse(2)] = W.avse(st2.stats.mean.tthres');
plt.barplot(5*tav, 5*tse);
xtickangle(45);

spt = cat(3,sp1.noise(:,:,2), sp2.noise);
plt.new;
[ty, tm] = W_plt_JAGS.density(spt, -1:.04:21);
plt.lineplot(ty ,[],tm);

plt.new;
plt.setfig_ax('color', col,'ylim', [0 10], 'xlabel', '', 'ylabel','noise',...
    'xtick',1:2,'xticklabel',{'constant','random'});
[tav,tse] = W.avse([st1.stats.mean.tnoise(2,:)']);
[tav(2), tse(2)] = W.avse(st2.stats.mean.tnoise');
plt.barplot(tav, tse);
xtickangle(45);
plt.update;
plt.addABCs([-0.07 0.05]);
plt.save('rand2');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  SOUND 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
gp = importdata('../../data_processed/output/gp_sound.mat').gp;
hbidir = '../../result_bayes';
file = fullfile(hbidir, 'HBI_model_simple_within_sound_samples.mat');
file = fullfile(hbidir, 'HBI_model_simple_history_within_sound_samples.mat');
sp1 = importdata(file);
%%
plt.figure(1,3,'margin',[0.2 0.06 0.05 0.02]);
plt.setfig(3,1, 'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
    'ylim', [0 1], 'ytick', 0:0.5:1, ...
    'legord', 'reverse', 'legloc', 'SouthWest',...
    'color',{'AZred','AZblue'}, ...
    'legend',{'H = 6','H = 1'}, ...
    'xlabel', {'guided reward'}, ...
    'ylabel', {'p(explore)'});
plt.new;
plt.lineplot(gp.av_bin_all_c1_cc_explore, gp.ste_bin_all_c1_cc_explore);

rgr = {[0 5], [0 20]};
plt.setfig(2:3,'color', {{'AZblue','AZred'},{'AZblue','AZred'}}, ...
    'legend',{{'H = 1','H = 6'},{'H = 1','H = 6'}}, ...
    'xlim', rgr, ...
    'legloc', {'NorthWest','NorthWest'}, ...
    'xlabel', {'threshold','noise'}, ...
    'ylabel',{'density','density'});

plt.new;
[ty, tm] = W_plt_JAGS.density(sp1.thres, -1:.01:101);
plt.lineplot(ty ,[],tm);
plt.new;
[ty, tm] = W_plt_JAGS.density(sp1.noise, -1:.05:101);
plt.lineplot(ty,[],tm);
plt.update;
plt.addABCs([-0.05, 0.04]);
plt.save('sound');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  01long 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
gp = importdata('../../data_processed/output/gp_long01.mat').gp;
hbidir = '../../result_bayes';
file = fullfile(hbidir, 'HBI_model_long01_long01_samples.mat');
sp1 = importdata(file);
%%
col = {'AZcactus50', 'AZcactus'};
leg = {'free, H = 15', 'guided, H = 15'};
plt.figure(2,2);
plt.setfig_new;
plt.setfig(1:2,'xlim', {[0.5 15.5],[0.5 6.5]}, 'ylim', {[0 1],[0 1]} , ...
    'ytick', {0:0.2:1,[0:0.2:1]},'color', {{'AZcactus', 'AZcactus50'},{'AZcactus', 'AZcactus50'}},...
    'legend', {{'guided, H = 15', 'free, H = 15'},{'guided, H = 15', 'free, H = 15'}}, ...
    'legloc', {'NorthEast','SouthWest'},'xlabel',{'trial number', 'guided reward'}, ...
    'ylabel', {'p(switch)','p(explore)'});
plt.setfig(4,2, 'xtick', 1:6, 'xticklabel', {0:5});
plt.setfig(3:4,'xlim', {[0 5],[0 20]},'color',{col},...
    'legend',{leg}, ...
    'legloc', {'NorthWest', 'NorthEast'}, 'xlabel', {'threshold', 'noise'}, ...
    'ylabel', 'density');
% plt.new;
% plt.lineplot(gp.av_av_cc_best, gp.ste_av_cc_best);
plt.new;
plt.lineplot(ff(gp.av_av_cc_switch), ff(gp.ste_av_cc_switch));
plt.new;
plt.lineplot(gp.av_bin_all_c1_cc_explore, gp.ste_bin_all_c1_cc_explore);
plt.new;
[ty, tm] = W_plt_JAGS.density(sp1.thres, -1:.005:21);
plt.lineplot(ty ,[],tm);
plt.new;
[ty, tm] = W_plt_JAGS.density(sp1.noise, -1:.01:21);
plt.lineplot(ty ,[],tm);
plt.update;
plt.save('long01');
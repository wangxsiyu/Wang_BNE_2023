%% load datadir
datadir = '../data_behavior_RatExploration';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% select data
data = W.readtable(fullfile(datadir, 'gameversion_3lights'));
data = addgameID_ratEE(data);
%%
%% determine session
sessions = W_sub.selectsubject(data, {'rat', 'n_free','n_guided'});
%% display condition
disp_cond_ratEE(data);
%% determine session
%%
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE_3lights');
%% exclude first and last game of each day
data = data(~(data.gameID <= 2 | data.gameID_rev == 1),:);
%%
% get_bayesdata(data, fullfile(datadir, 'bayesdata', 'gameversion_random'));
%%
sessions = W_sub.selectsubject(data, {'rat', 'n_free','n_guided'});
%% basic analysis
sub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE_3lights');
sub = W.tab_squeeze(sub);
%% group
gp = W_sub.analysis_group(sub, {'n_free','n_guided'});
%%
av = [gp.av_p_explore';gp.av_p_novel'];
ste = [gp.ste_p_explore';gp.ste_p_novel'];
%%
plt = W_plt;
plt.figure(1,1);
plt.new;
bar(av(2,:))
plt.setfig('legend', {'p(explore)', 'p(novel)'});
plt.update;

%%
% 
% %%
% plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE', 'fig_suffix', '_between_G3F16');
% %% plot - by group
% plt = ratfig_behavior_gp(plt, gp);
% %% plot - by rat
% plt = ratfig_behavior_sub(plt, sub);
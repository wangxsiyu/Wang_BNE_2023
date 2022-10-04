%% load datadir
datadir = '../data_behavior_RatExploration';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% select data
data = W.readtable(fullfile(datadir, 'gameversion_control_G3F6_random'));
%% determine session
sessions = W_sub.selectsubject(data, {'rat', 'n_free'});
%% basic analysis
sub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(sub);
%% group
gp = W_sub.analysis_group(sub, {'n_guided','n_free'});
%%
plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE', 'fig_suffix', '_between_G3F16');
%% plot - by group
plt = ratfig_behavior_gp(plt, gp);
%% plot - by rat
plt = ratfig_behavior_sub(plt, sub);
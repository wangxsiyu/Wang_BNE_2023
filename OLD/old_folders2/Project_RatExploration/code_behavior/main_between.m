%% load datadir
datadir = '../data_behavior_RatExploration';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% select data
data = W.readtable(fullfile(datadir, 'gameversion_G3_between'));
data2 = W.readtable(fullfile(datadir, 'gameversion_mixed_long_between'));
data2 = data2(data2.n_guided == 3, :);
data = W.tab_vertcat(data, data2);
idx = W_sub.selectsubject(data, {'foldername','filename'});
gameID = W.cellfun(@(x)1:length(x), idx);
data.gameID = [gameID{:}]';
gameID = W.cellfun(@(x)[1:length(x)]/length(x), idx);
data.gameID_perc = [gameID{:}]';
%% determine session
sessions = W_sub.selectsubject(data, {'rat', 'n_free'});
%% basic analysis
sub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(sub);
%%
sub.n_free(sub.n_free == 20) = 15;
%% group
gp = W_sub.analysis_group(sub, {'n_guided','n_free'});
gp = gp([1 3 2],:);
%%
plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE', 'fig_suffix', '_between_G3F16');
%% plot - by group
plt = ratfig_behavior_gp(plt, gp);
%% plot - by rat
plt = ratfig_behavior_sub(plt, sub);
%% load datadir
datadir = '../data_behavior_RatExploration';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% select data
data = W.readtable(fullfile(datadir, 'gameversion_G01_within'));
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
%% group
gp = W_sub.analysis_group(sub, {'n_guided','n_free'});
%%
plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE', 'fig_suffix', '_between_G3F16');
%% plot - by group
plt = ratfig_behavior_gp(plt, gp);
%% plot - by rat
plt = ratfig_behavior_sub(plt, sub);

%%
    plt.setfig_new;
    plt.setfig_loc(4,'xlim', [0.5 6.5]);
    plt = fig_behavior_gp(plt, gp, 'av', 'trial number', col2, ...
        repmat({{'h1,f','h6,f','h1,g','h6,g'}},1,4), ['gp_av']);
    %%
    
    plt.setfig_loc(4,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5);
    plt = fig_behavior_gp(plt, gp, 'bin_all', 'R guided', col2 , ...
        repmat({{'h1,f','h6,f','h1,g','h6,g'}},1,4), ['gp_rG']);
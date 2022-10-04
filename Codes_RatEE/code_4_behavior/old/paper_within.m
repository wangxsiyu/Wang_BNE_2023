fn = '../../data_processed/versions_cleaned/final_within_all.csv';
data = W.readtable(fn);
%% within
data = data(data.n_guided < 4, :);
% data = filter_longRT(data, 0.9);
%% preprocess
sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'n_guided'});
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
%% ac
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
data = W_sub.preprocess_subxgame(data, sessions, 'performance_RatEE');
%% exclude sessions based accuracy
tac = W_sub.analysis_group(data, {'rat', 'foldername', 'n_free'});
% %% session plot
% tses = W_sub.selectsubject(tac, {'rat', 'foldername'});
% tac_ses =  W_sub.tab_trial2game(tac, tses);
% %%
tac = tac(tac.av_n_free > 1,:);
data = data(contains(data.foldername, tac.foldername(tac.av_cc_best_smoothed > 0.5)),:);
%% include only horizon 3
data = data(ismember(data.n_guided,[1, 3]), :);
%% basic analysis
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
tsub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(tsub);
%% group
gp = W_sub.analysis_group(sub, {'cond_horizon','n_guided'});
% sort
[~, od] = sort(gp.av_cond_horizon, 'descend');
gp = gp(od,:);
%% get bayes
data.cond_guided = data.n_guided;
data.cond_guided(data.n_guided == 2) = 3;
bayesname = replace(fn, 'final', 'bayes');
bayesname = replace(bayesname, '.csv', '');
bayesname = replace(bayesname, 'versions_cleaned', 'bayesdata');
get_bayesdata(data, bayesname);
%% figure
plt = W_plt('fig_dir', '../../figures','fig_projectname', 'RatEE','fig_suffix','within');
plt.setuserparam('param_setting', 'isshow', 1);
%% color/legend
col = {'AZred', 'AZblue'};
leg = strcat("H = ", W_sub.tab_jointcondition(gp.group_analysis));
%% by trial number
plt.setfig_new;
plt.setfig_loc(2,'xlim', [0.5 6.5], 'ylim', {[0.5 0.8], [0 1]} , ...
    'ytick', {0.5:0.1:1, 0:0.2:1}, 'legord', 'reverse', 'legloc', {'SouthEast', 'NorthEast'});
plt = fig_behavior_gp(plt, gp, 'av', 'trial number', col, ...
    leg, ['gp_av']);
%% split by good/bad
% plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0.4 1], [0 1]},'legloc', {'NorthWest', 'NorthEast'});
% plt = fig_behavior_gp(plt, gp, 'gp_av', 'trial number', col2, ...
%     leg2, ['gp_acG']);
%% R curve
plt.setfig_new;
plt.setfig_loc(2,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
    'ylim', {[0 1],[0 1]}, 'ytick', {0:0.2:1, 0:0.2:1}, 'legord', 'reverse', 'legloc', 'SouthWest');
plt = fig_behavior_gp(plt, gp, 'bin_all', 'R guided', col , ...
    leg, ['gp_rG']);


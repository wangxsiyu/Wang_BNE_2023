%% load datadir
datadir = '../data_behavior_RatExploration';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% select data
%% preprocess
data = addgameID_ratEE(data);
%% exclude first and last game of each day
data = data(~(data.gameID <= 2 | data.gameID_rev == 1),:);
%% display condition
disp_cond_ratEE(data);
%% determine session
sessions = W_sub.selectsubject(data, {'rat', 'n_free'});
%%
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
%% save bayesian data
get_bayesdata(data, fullfile(datadir, 'bayesdata', 'gameversion_01'));
%% determine session
sessions = W_sub.selectsubject(data, {'rat', 'n_free','n_guided'});
%% basic analysis
sub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(sub);
%% group
gp = W_sub.analysis_group(sub, {'n_free'});
gp = gp([3 4 1 2],:);
%%
plt = W_plt;
% %% plot - by group
% plt = ratfig_behavior_gp(plt, gp);
% %% plot - by rat
% plt = ratfig_behavior_sub(plt, sub);

%%
    col2 = {'AZred','AZred50','AZblue','AZblue50'};
    leg = repmat({{'h = 6, guided','h = 6, free','h = 1, guided','h = 6, free'}},1,2);
    horizons = [1 6 15];
    xlm = [0 6] + 0.5;
%%
    plt.setfig_new;
    plt.setfig_loc(2,'xlim', [0.5 6.5],'ylim', {[0.5 1], [0 1]});
    plt = fig_behavior_gp(plt, gp, 'av', 'trial number', col2, ...
        leg, ['gp_av']);
    %%
    plt.setfig_new;
    
    plt.setfig_loc(2,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5);
    plt = fig_behavior_gp(plt, gp, 'bin_all', 'R guided', col2 , ...
        leg, ['gp_rG']);
%% load datadir
datadir = '../data_behavior_RatExploration';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% select data
data = addgameID_ratEE(data);
%%
%% determine session
sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'foldername'});
%% display condition
disp_cond_ratEE(data);
%% determine session
%%
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE_random');
%% exclude first and last game of each day
data = data(~(data.gameID <= 2 | data.gameID_rev == 1),:);
%%
get_bayesdata(data, fullfile(datadir, 'bayesdata', 'gameversion_random'));
%%
sessions = W_sub.selectsubject(data, {'rat', 'cond_horizon'});
%% basic analysis
sub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(sub);
%% group
gp = W_sub.analysis_group(sub, {'n_guided','cond_horizon'});
%%

 col = {'AZred','AZsand'};
    col2 = {'AZred','AZred50','AZsand','AZsand50'};
    leg = {'fixed R', 'random R'};
    leg2 = {'fixed R, bad', 'fixed R, good' ,'random R, bad', 'random R, good'}
    horizons = [1 6 15];
    xlm = [0 6] + 0.5;
    %% by trial number
    plt.setfig_new;
    plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0 1], [0 1]});
    plt = fig_behavior_gp(plt, gp, 'av', 'trial number', {col,col}, ...
        {leg,leg}, ['gp_av']);
    
    %% by good/bad guide
    plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0 1], [0 1]});
    plt = fig_behavior_gp(plt, gp, 'avbygp', 'trial number', col2, ...
        leg2, ['gp_acG']);
   
    %% by R guided
    plt.setfig_loc(2,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5);
    plt = fig_behavior_gp(plt, gp, 'bin_all', 'R guided', {col,col} , ...
        {leg,leg}, ['gp_rG']);
%%
% 
% %%
% plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE', 'fig_suffix', '_between_G3F16');
% %% plot - by group
% plt = ratfig_behavior_gp(plt, gp);
% %% plot - by rat
% plt = ratfig_behavior_sub(plt, sub);
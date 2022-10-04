%% load datadir

%% determine session
sessions = W_sub.selectsubject(data, {'filename', 'n_free'});
%%
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
%% save bayesian data
get_bayesdata(data, fullfile('../data_behavior_RatExploration/', 'bayesdata', 'gameversion_human'));
%% basic analysis
sessions = W_sub.selectsubject(data, {'rat', 'n_free'});
sub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(sub);
%% group
gp = W_sub.analysis_group(sub, {'n_guided','n_free'});
    gp = gp([4 3 2 1],:);
%%
 col = {'AZblue','AZsky','AZred','AZcactus'};
    leg = {'h = 1', 'h = 2', 'h = 5','h = 9'};
    col = col([4 3 2 1]);
    leg = leg([4 3 2 1]);
    col2 = {'AZblue50','AZblue','AZsky50','AZsky','AZred50','AZred','AZcactus50','AZcactus'};
    col2 = col2([8:-1:1]);
    leg2 = {'h = 1, bad','h = 1, good','h = 2, bad', 'h = 2, good',...
        'h = 5, bad', 'h = 5, good','h = 9, bad','h = 9, good'};
    leg2 = leg2([7 8 5 6 3 4 1 2]);
    xlm = [0 9.5];
    %% by trial number
    plt.setfig_new;
    plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0.5 1], [0 1]}, 'legloc', 'NorthWest');
    plt = fig_behavior_gp(plt, gp, 'av', 'trial number', col, ...
        leg, ['gp_av']);
    
    %% by good/bad guide
    plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0.4 1], [0 1]},'legloc', {'SouthEast','NorthEast'});
    plt = fig_behavior_gp(plt, gp, 'avbygp', 'trial number', col2, ...
        [leg2], ['gp_acG']);
   
    %% by R guided
    plt.setfig_loc(2,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5);
    plt = fig_behavior_gp(plt, gp, 'bin_all', 'R guided', col , ...
        leg, ['gp_rG']);
% %%
% plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE', 'fig_suffix', '_between_G3F16');
% %% plot - by group
% plt = ratfig_behavior_gp(plt, gp);
% %% plot - by rat
% plt = ratfig_behavior_sub(plt, sub);
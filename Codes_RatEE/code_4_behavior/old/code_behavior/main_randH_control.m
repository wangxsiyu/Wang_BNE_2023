%% load datadir
datadir = '../../data_processed/versions';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% select data
%% add ID
data = W_sub.add_gameID(data, {'foldername', 'filename'});
%% display condition
% disp_cond_ratEE(data);
%% determine session
sessions = W_sub.selectsubject(data, {'rat', 'n_free'});
data = W_sub.preprocess_subxgame(data, sessions, { 'preprocess_RatEE'});
%% basic analysis
sessions = W_sub.selectsubject(data, {'rat', 'cond_horizon'});
sub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(sub);
%% group
gp = W_sub.analysis_group(sub, {'n_guided','cond_horizon'});
%% sort
[~, od] = sort(gp.av_n_free, 'descend');
gp = gp(od,:);
%% save bayesian data
if ~exist('../../data_processed/bayesdata')
    mkdir('../../data_processed/bayesdata');
end
get_bayesdata(data, fullfile('../../data_processed/bayesdata', 'gameversion_randH'));
%%
plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE', 'fig_suffix', '_between_G3F16');
% %% plot - by group
% plt = ratfig_behavior_gp(plt, gp);
% %% plot - by rat
% plt = ratfig_behavior_sub(plt, sub);
%%
 col = {'AZred','AZblue'};
    col2 = {'AZred','AZred50','AZblue','AZblue50'};
    leg = {'h = 6', 'h = 1'};
    leg2 = {'h = 6, bad', 'h = 6, good' ,'h = 1, bad', 'h = 1, good'}
    horizons = [1 6 15];
    xlm = [0 6] + 0.5;
    %% by trial number
    plt.setfig_new;
    plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0.5 1], [0 1]});
    plt = fig_behavior_gp(plt, gp, 'av', 'trial number', {col,col}, ...
        {leg,leg}, ['gp_av']);
    
    %% by good/bad guide
    plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0.5 1], [0 1]});
    plt = fig_behavior_gp(plt, gp, 'gp_av', 'trial number', col2, ...
        leg2, ['gp_acG']);
   
    %% by R guided
    plt.setfig_loc(2,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5);
    plt = fig_behavior_gp(plt, gp, 'bin_all', 'R guided', {col,col} , ...
        {leg,leg}, ['gp_rG']);
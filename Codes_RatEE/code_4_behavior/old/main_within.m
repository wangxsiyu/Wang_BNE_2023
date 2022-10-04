%% load datadir
datadir = '../../data_processed/versions';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% select data
%% add ID
data = W_sub.add_gameID(data, {'foldername', 'filename'});
%% exclude first 2 games of the day (first visit to each homebase)
% tid = ~(data.gameID <= 2);% | data.gameID_rev == 1
% disp(sprintf('%.5f %% of the trials kept', 100 * mean(tid)));
% data = data(tid,:);
%% get reward setting
% sessions = W_sub.selectsubject(data, {'foldername', 'filename'});
% data = W_sub.preprocess_subxgame(data, sessions, {'func_cond_drop'});

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
get_bayesdata(data, fullfile('../../data_processed/bayesdata', 'gameversion_within'));
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
%%
% plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE', 'fig_suffix', '_between_G3F16');
% %% plot - by group
% plt = ratfig_behavior_gp(plt, gp);
% %% plot - by rat
% plt = ratfig_behavior_sub(plt, sub);
% 


% %% analysis by session time
% % tb = W_sub.display_conditions(data, {'rat', 'n_free'})
% tb = W_sub.display_conditions(data, {'rat', 'str_date', 'str_time', 'n_free'})
% %% fit basic model
% sub_mle = W_sub.analysis_sub(data, sessions, 'MLE_RatEE');
% 
% sub_mle = W.tab_squeeze(sub_mle);
% %%
% sub_mle.n_free(sub_mle.n_free == 20) = 15;
% %%
% gp_mle = W_sub.analysis_group(sub_mle, {'n_free'});
% gp_mle = gp_mle([1 3 2],:);
% %% 
% plt.figure(1,3,'title', 'margin', [0.2 0.07 0.05 0.05]);
% names = {'noise','threshold','bias_side'};
% prefix = 'MLE1_';
% suffix = '_byT';
% plt.setfig('xlabel', 'training session', 'xlim', [.5 5.5], 'ylim', {[0 5],[],[]},...
%     'color', {'AZblue', 'AZred'}, 'legend', gp_mle.group_analysis.n_free);
% for i = 1:3
%     plt.new;
%     plt.setfig_ax('ylabel', W.str_de_(names{i}));
%     tname = [prefix, names{i}, suffix];
%     plt.lineplot(gp_mle.(['av_' tname]), gp_mle.(['ste_' tname]));
% end
% plt.update;
% %%
% plt.figure(2,3,'title', 'rect', [0 0 0.9 0.6], 'margin', [0.2 0.07 0.05 0.05], ...
%     'gap', [0.2 0.05]);
% names = {'noise','v0','bias_side','learningrate','bias_info','bias_repeat'};
% prefix = 'MLE2_';
% suffix = '';
% plt.setfig('xlabel', 'rat',  'xlim', [.5 4.5], ...
%     'color', {'AZblue', 'AZred'});
% for i = 1:6
%     plt.new;
%     plt.setfig_ax('ylabel', W.str_de_(names{i}));
%     tname = [prefix, names{i}, suffix];
%     plt.lineplot(reshape(sub_mle.([tname]),2,[]));
% end
% plt.update;
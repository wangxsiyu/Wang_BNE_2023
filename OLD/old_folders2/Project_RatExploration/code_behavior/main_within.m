%% load datadir
datadir = '../data_behavior_RatExploration';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% select data
data = W.readtable(fullfile(datadir, 'gameversion_G34_within'));
data = data(data.rat ~= "Bobo",:);
data = data(data.n_guided == 3,:);
data = data(~(data.str_date == 20200809 & data.rat == "Gerald"),:);% exclude one session for Gerald


idx = W_sub.selectsubject(data, {'foldername','filename'});
gameID = W.cellfun(@(x)1:length(x), idx);
data.gameID = [gameID{:}]';
gameID = W.cellfun(@(x)[1:length(x)]/length(x), idx);
data.gameID_perc = [gameID{:}]';
%% determine session
sessions = W_sub.selectsubject(data, {'rat', 'n_free','n_guided'});
%% basic analysis
sub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(sub);
%% group
gp = W_sub.analysis_group(sub, {'n_free'});
%%
plt = W_plt('fig_dir', '../figures','fig_projectname', 'RatEE', 'fig_suffix', '_between_G3F16');
%% plot - by group
plt = ratfig_behavior_gp(plt, gp);
%% plot - by rat
plt = ratfig_behavior_sub(plt, sub);



%% analysis by session time
% tb = W_sub.display_conditions(data, {'rat', 'n_free'})
tb = W_sub.display_conditions(data, {'rat', 'str_date', 'str_time', 'n_free'})
%% fit basic model
sub_mle = W_sub.analysis_sub(data, sessions, 'MLE_RatEE');

sub_mle = W.tab_squeeze(sub_mle);
%%
sub_mle.n_free(sub_mle.n_free == 20) = 15;
%%
gp_mle = W_sub.analysis_group(sub_mle, {'n_free'});
gp_mle = gp_mle([1 3 2],:);
%% 
plt.figure(1,3,'title', 'margin', [0.2 0.07 0.05 0.05]);
names = {'noise','threshold','bias_side'};
prefix = 'MLE1_';
suffix = '_byT';
plt.setfig('xlabel', 'training session', 'xlim', [.5 5.5], 'ylim', {[0 5],[],[]},...
    'color', {'AZblue', 'AZred'}, 'legend', gp_mle.group_analysis.n_free);
for i = 1:3
    plt.new;
    plt.setfig_ax('ylabel', W.str_de_(names{i}));
    tname = [prefix, names{i}, suffix];
    plt.lineplot(gp_mle.(['av_' tname]), gp_mle.(['ste_' tname]));
end
plt.update;
%%
plt.figure(2,3,'title', 'rect', [0 0 0.9 0.6], 'margin', [0.2 0.07 0.05 0.05], ...
    'gap', [0.2 0.05]);
names = {'noise','v0','bias_side','learningrate','bias_info','bias_repeat'};
prefix = 'MLE2_';
suffix = '';
plt.setfig('xlabel', 'rat',  'xlim', [.5 4.5], ...
    'color', {'AZblue', 'AZred'});
for i = 1:6
    plt.new;
    plt.setfig_ax('ylabel', W.str_de_(names{i}));
    tname = [prefix, names{i}, suffix];
    plt.lineplot(reshape(sub_mle.([tname]),2,[]));
end
plt.update;
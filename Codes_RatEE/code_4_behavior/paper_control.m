fn = '../../data_processed/versions/gameversion_RandR_G3F6.csv';
data = W.readtable(fn);
% fn = '../../data_processed/versions_cleaned/final_between_all.csv';
% data = W.readtable(fn);
% data = data(data.n_guided == 3 & data.n_free == 6,:);
%% within/guide 0-1-3
% data = data(~ismember(data.n_free, [3 8]),:);
% data = filter_longRT(data, 0.9);
% data = W.tab_vertcat(data, data2);
%% preprocess
sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'n_guided','is_random'});
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
%% ac
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
data = W_sub.preprocess_subxgame(data, sessions, 'performance_RatEE');
%% exclude sessions based accuracy
tac = W_sub.analysis_group(data, {'rat', 'foldername','cond_horizon'});
tac = tac(tac.av_cond_horizon > 1,:);
%%
cols = {'AZblue', 'AZred', 'AZcactus', 'AZsand','AZbrick'};
syms = strcat('-', {'o','+','+','+','x','d','^'});
ww = W_colors;
rats = unique(tac.rat);
nrat = length(rats);
conds = unique(tac.str_guidefree);
ncond = length(conds);
for i = 1:nrat
    for j = 1:ncond
        tid = strcmp(tac.rat, rats(i)) & strcmp(tac.str_guidefree, conds(j));
        td = tac(tid,:);
        plot(td.datetime, td.av_cc_best(:,end), syms{j}, 'color', ww.(cols{i}));
        hold on;
    end
end
%%
% tid = find(tac.av_cc_best(:,end) < 0.4);
% ses_exclude = tac(tid,:).foldername;
% mean(~contains(data.foldername, ses_exclude))
% data = data(~contains(data.foldername, ses_exclude),:);
% % %% session plot
% % tses = W_sub.selectsubject(tac, {'rat', 'foldername'});
% % tac_ses =  W_sub.tab_trial2game(tac, tses);
% % %%
% tac = tac(tac.av_n_free > 1,:);
% data = data(contains(data.foldername, tac.foldername(tac.av_cc_best_smoothed > 0.5)),:);
%% include only horizon 3
% data = data(ismember(data.n_guided,[1, 3]), :);
%% basic analysis
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon','is_random'});
tsub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(tsub);
%% group
gp = W_sub.analysis_group(sub, {'is_random'});
% sort
[~, od] = sort(gp.av_cond_horizon, 'descend');
gp = gp(od,:);
%%
save('../../data_processed/output/gp_control.mat', 'sub','gp');
%% get bayes
bayesname = '../../data_processed/bayesdata/bayes_control';
get_bayesdata(data, bayesname);

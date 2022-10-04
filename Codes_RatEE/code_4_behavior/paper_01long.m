fn = '../../data_processed/versions_cleaned/final_between_all.csv';
data = W.readtable(fn);
%% within/guide 0-1-3
data = data(data.n_guided <= 1, :);
data = data(data.n_free >= 15,:);
% data = data(~ismember(data.n_free, [3 8]),:);
% data = filter_longRT(data, 0.9);
%% preprocess
sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'n_guided'});
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
%% ac
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
data = W_sub.preprocess_subxgame(data, sessions, 'performance_RatEE');
% %% exclude sessions based accuracy
% tac = W_sub.analysis_group(data, {'rat', 'foldername','cond_horizon'});
% tac = tac(tac.av_cond_horizon > 1,:);
%% basic analysis
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
tsub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(tsub);
%% group
gp = W_sub.analysis_group(sub, {'cond_horizon','n_guided'});
% sort
[~, od] = sort(gp.av_cond_horizon, 'descend');
gp = gp(od,:);
save('../../data_processed/output/gp_long01.mat','sub','gp');
%% get bayes
bayesname = '../../data_processed/bayesdata/bayes_long01';
get_bayesdata(data, bayesname);

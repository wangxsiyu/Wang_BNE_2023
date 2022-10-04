fn = '../../data_processed/versions_cleaned/final_within_all.csv';
data = W.readtable(fn);
% fn2 = '../../data_processed/versions_cleaned/within_3lights.csv';
% data2 = W.readtable(fn2);
% data2 = W.tab_squeeze(data2);
%% include only horizon 3
data = data(ismember(data.n_guided,[0, 1, 3]), :);
%%
data = data(data.is_consistent_nguided == 1,:);
%% within/guide 0-1-3
% data = W.tab_vertcat(data, data2);
% data = data(data.n_guided < 4, :);
% data = data(~ismember(data.n_free, [3 8]),:);
% data = filter_longRT(data, 0.9);
%% preprocess
sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'n_guided'});
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
%% ac
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
data = W_sub.preprocess_subxgame(data, sessions, 'performance_RatEE');
%% exclude sessions based accuracy
tac = W_sub.analysis_group(data, {'rat', 'foldername','cond_horizon'});
tac = tac(tac.av_cond_horizon > 1,:);
%%
figure;
cols = {'AZblue', 'AZred', 'AZcactus', 'AZsand','AZbrick'};
syms = strcat('-', {'o','+','+','+','x','d','^','-'});
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
tid = find(tac.av_cc_best(:,end) < 0.3);
ses_exclude = tac(tid,:).foldername;
mean(~contains(data.foldername, ses_exclude))
data = data(~contains(data.foldername, ses_exclude),:);
data = data(~isnan(data.c_guided),:);

% % %% session plot
% % tses = W_sub.selectsubject(tac, {'rat', 'foldername'});
% % tac_ses =  W_sub.tab_trial2game(tac, tses);
% % %%
% tac = tac(tac.av_n_free > 1,:);
% data = data(contains(data.foldername, tac.foldername(tac.av_cc_best_smoothed > 0.5)),:);
%%
% idx = ismember(data.str_guidefree,{'(0,2)(0,7)','(1,1)(1,6)','(3,1)(3,6)'});
% disp(sprintf('%.2f kept', mean(idx)));
% data = data(idx,:);
%% exclude trials in which horizon can not be identified (first games of each session)
idx = (data.gameID <= 2)| excludeearlydate(data.rat, data.date, 1);
data = data(~idx,:);
%% basic analysis
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
tsub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(tsub);
%% group
gp = W_sub.analysis_group(sub, {'cond_horizon','n_guided'});
% sort
[~, od] = sort(gp.av_cond_horizon, 'descend');
gp = gp(od,:);
%% save
save('../../data_processed/output/gp_within', 'gp', 'sub');
%% get bayes
bayesname = replace(fn, 'final', 'bayes');
bayesname = replace(bayesname, '.csv', '');
bayesname = replace(bayesname, 'versions_cleaned', 'bayesdata');
get_bayesdata(data, bayesname);
%% control
fn = '../../data_processed/versions_cleaned/final_within_all.csv';
data = W.readtable(fn);
data = data(data.n_guided < 4, :);
data = data(data.is_consistent_nguided == 1,:); 
data = data(data.is_consistent_nfree == 0, :);

sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'n_guided'});
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
data = W_sub.preprocess_subxgame(data, sessions, 'performance_RatEE');
tac = W_sub.analysis_group(data, {'rat', 'foldername','cond_horizon'});
tac = tac(tac.av_cond_horizon > 1,:);
tid = find(tac.av_cc_best(:,end) < 0.3);
ses_exclude = tac(tid,:).foldername;
mean(~contains(data.foldername, ses_exclude))
data = data(~contains(data.foldername, ses_exclude),:);
%% basic analysis
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
tsub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
sub = W.tab_squeeze(tsub);
%% group
gp = W_sub.analysis_group(sub, {'cond_horizon','n_guided'});
% sort
[~, od] = sort(gp.av_cond_horizon, 'descend');
gp = gp(od,:);
%% save
save('../../data_processed/output/gp_sound', 'gp', 'sub');
%% get bayes
bayesname = '../../data_processed/bayesdata/bayes_within_sound';
get_bayesdata(data, bayesname);

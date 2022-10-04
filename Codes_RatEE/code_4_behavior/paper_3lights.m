fn = '../../data_processed/versions/gameversion_3lights';
data = W.readtable(fn);
%% 3 lights
id = any(ismember(data.feeders,[3 7]),2);
d1 = data(id, :);
d2 = data(~id, :);
%% preprocess
% sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'n_guided','is_random'});
% data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE_3lights');
% %% basic analysis
sessions = W_sub.selectsubject(d1, {'rat', 'n_guided','n_free'});
tsub = W_sub.analysis_sub(d1, sessions, 'behavior_3lights');
sub = W.tab_squeeze(tsub);
% %% group
% gp = W_sub.analysis_group(sub, {'is_random'});
% % sort
% [~, od] = sort(gp.av_cond_horizon, 'descend');
% gp = gp(od,:);
% %%
% save('../../data_processed/output/gp_3lights.mat', 'sub','gp');
%% GIVE UP THIS DATASET, NOT ENOUGH TRIALS WITH 3 LIGHTS



%% 
d2 = d2(strcmp(d2.str_guidefree,'(0,1)(3,1)(3,6)'),:);
writetable(d2,'/Users/wang/WANG/Fellous_Siyu_RatEE/data_processed/versions_cleaned/within_3lights.csv');
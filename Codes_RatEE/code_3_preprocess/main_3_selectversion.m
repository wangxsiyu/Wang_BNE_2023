%% load datadir
datadir = '../../data_processed/versions';
outputdir = '../../data_processed/versions_cleaned';
[~,versions] = W.dir(fullfile(datadir, '*version*'))
%% between
% data = W.readtable(fullfile(datadir, 'gameversion_G3_between'));
% data2 = W.readtable(fullfile(datadir, 'gameversion_mixed_long_between'));
% data2 = data2(data2.n_guided == 3, :);
% data = W.tab_vertcat(data, data2);
% sessions = W_sub.selectsubject(data, {'foldername', 'filename'});
% addpath('../code_behavior/');
% tdata = W_sub.preprocess_subxgame(data, sessions, {'func_cond_drop', 'preprocess_RatEE'});
% % exclude 17
% tid = tdata.cond_drop ~= '17';
% disp(sprintf('%.5f %% of the trials kept', 100 * mean(tid)));
% data = data(tid, :);
% % use only 012345 and 0135
% % tid = contains(tdata.cond_drop, ["012345", "0135"]);
% % disp(sprintf('%.5f %% of the trials kept', 100 * mean(tid)));
% % data = data(tid,:);
% W.writetable(data, fullfile(outputdir, 'final_between.csv'));
%% between all
data = W.readtable(fullfile(datadir, 'gameversion_G3_between'));
data2 = W.readtable(fullfile(datadir, 'gameversion_long_between'));
data = W.tab_vertcat(data, data2);
data3 = W.readtable(fullfile(datadir, 'gameversion_G4F6_between'));
data = W.tab_vertcat(data, data3);
W.writetable(data, fullfile(outputdir, 'final_between_all.csv'));
%% within
% data = W.readtable(fullfile(datadir, 'gameversion_G34_within'));
% data = data(data.rat ~= "Bobo",:);
% data = data(data.n_guided == 3,:);
% data = data(~(data.str_date == 20200809 & data.rat == "Gerald"),:);% exclude one session for Gerald
% W.writetable(data, fullfile(outputdir, 'final_within.csv'));
%% sound
% data = W.readtable(fullfile(datadir, 'gameversion_RandH_control_G3F16'));
% W.writetable(data, fullfile(outputdir, 'final_sound.csv'));
%% within-all
data = W.readtable(fullfile(datadir, 'gameversion_within'));
data2 = W.readtable(fullfile(datadir, 'gameversion_RandH_G3F16'));
data = W.tab_vertcat(data, data2);
data3 = W.readtable(fullfile(datadir, 'gameversion_RandH_G0123F16_within'));
data = W.tab_vertcat(data, data3);
data4 = W.readtable(fullfile(datadir, 'gameversion_G0F38_within'));
data = W.tab_vertcat(data, data4);
data = data(data.rat ~= "Bobo",:);
W.writetable(data, fullfile(outputdir, 'final_within_all.csv'));
% %% control - random
% data = W.readtable(fullfile(datadir, 'gameversion_control_G3F6_random'));
% % d2 = W.readtable(fullfile(datadir, 'gameversion_G3_between'));
% % d2 = d2(d2.n_free == 6 & d2.n_guided == 3,:);
% % data = W.tab_vertcat(data,d2);
% W.writetable(data, fullfile(outputdir, 'final_random.csv'));
% %% guide vs free
% data = W.readtable(fullfile(datadir, 'gameversion_G01_within'));
% W.writetable(data, fullfile(outputdir, 'final_guidefree.csv'));

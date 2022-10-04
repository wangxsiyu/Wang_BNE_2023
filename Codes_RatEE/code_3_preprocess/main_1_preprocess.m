data = W.readtable('../../data_processed/cleaned/cleaned_games_EE.csv');
data = data(~strcmp(data.rat, 'Bobo'),:);
data = addhistory(data);
W.writetable(data, '../../data_processed/cleaned/cleaned_games_EE_withhistory.csv');
%% human - reformat
datadir = '../../data_processed/versions';
outputdir = '../../data_processed/versions_cleaned/';
data = W.readtable(fullfile(datadir, 'gameversion_human')');
sub = W_sub.tab_unique(data, W_sub.selectsubject(data, 'filename'));
idxage = (sub.demo_age >= 18);
disp(sprintf('%d excluded for age, gender count %d Male, %d female', ...
    sum(~idxage), sum(strcmp(sub(idxage,:).demo_gender, 'male')), sum(strcmp(sub(idxage,:).demo_gender, 'female'))));
data = data(data.demo_age >= 18,:);
data = W.tab_fill(data, 'foldername', 'human');
data.rat = data.filename;
data.n_guided(:,1) = 1;
data.n_free = sum(~isnan(data.choice),2)-1;
data.is_guided = [ones(size(data,1),1), zeros(size(data,1), size(data.choice,2)-1).*data.choice(:,2:end)];
data.r = data.reward;
data.c = data.choice;
data.feeders = repmat([1 2], size(data,1),1);
data.drop = data.trueMean;
data.gameID = data.gameNumber;
data.foldername = data.filename;
data = addhistory(data);
W.writetable(data, fullfile(outputdir, 'final_human.csv'));
%% human full - reformat
data = W.readtable(fullfile(datadir, 'gameversion_human_full')');
sub = W_sub.tab_unique(data, W_sub.selectsubject(data, 'filename'));
idxage = (sub.demo_age >= 18);
disp(sprintf('%d excluded for age, gender count %d Male, %d female', ...
    sum(~idxage), sum(strcmp(sub(idxage,:).demo_gender, 'male')), sum(strcmp(sub(idxage,:).demo_gender, 'female'))));
data = data(data.demo_age >= 18,:);
data = W.tab_fill(data, 'foldername', 'human');
data.rat = data.filename;
data.n_guided(:,1) = 1;
data.n_free = sum(~isnan(data.choice),2)-1;
data.is_guided = [ones(size(data,1),1), zeros(size(data,1), size(data.choice,2)-1).*data.choice(:,2:end)];
data.r = data.reward;
data.c = data.choice;
data.feeders = repmat([1 2], size(data,1),1);
data.drop = data.trueMean;
data.gameID = data.gameNumber;
data.foldername = data.filename;
data = addhistory(data);
W.writetable(data, fullfile(outputdir, 'final_human_full.csv'));


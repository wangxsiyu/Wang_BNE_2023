clear
datadir = '/Volumes/WANGSIYU/Lab_Fellous/Data/Data_Imported';
data = readtable(fullfile(datadir, 'ratEE.csv'));
data = table_autofieldcombine(data);
data.r_best = max(data.r_side')';
data.nvisit = sum(~isnan(data.r)')';
data.iscomplete = data.nvisit == data.nGuided +  data.nFree;
data =  data(data.iscomplete,:);
data.c_ac = (data.r == data.r_best) + 0 * data.r;
data.r_guided = arrayfun(@(x)mean(data.r(x, 1:data.nGuided(x))), 1:size(data,1))';
data.side_guided = arrayfun(@(x)mean(data.fd_side(x, 1:data.nGuided(x))), 1:size(data,1))';
data.c_explore = (data.side_guided ~= data.fd_side) + data.fd_side * 0;
data.c_repeat = [NaN(size(data,1),1),data.c_ac(:,2:end) == data.c_ac(:,1:end-1)] +  data.c_ac * 0;
data.rpairID = sort(data.r_side')' * [10  1]';
%
option_sub = {'rat', 'date', 'time'};
idxsub = selectsubject(data, option_sub);
sub = ANALYSIS_sub(data, idxsub, 'basic', {'basic'}, 'Rat_basic');
%
option_subR = {'rat', 'date', 'time', 'r_guided'};
idxsubR = selectsubject(data, option_subR);
subR = ANALYSIS_sub(data, idxsubR, 'basic', {'basic'}, 'Rat_basic');
%
option_sub05 = {'rat', 'date', 'time', 'r_guided', 'rpairID'};
idxsub05 = selectsubject(data, option_sub05);
sub05 = ANALYSIS_sub(data, idxsub05, 'basic', {'basic'}, 'Rat_basic');
%
gp = table;
idxrat = selectsubject(sub, {'rat','nFree'});
for i = 1:length(idxrat)
    gp(i,:) = ANALYSIS_group(sub(idxrat{i},:));   
end
%
gpR = table;
idxrat = selectsubject(subR, {'rat','nFree','r_guided'});
for i = 1:length(idxrat)
    gpR(i,:) = ANALYSIS_group(subR(idxrat{i},:));   
end
%
gp05 = table;
idxrat = selectsubject(sub05, {'rat','nFree','r_guided', 'rpairID'});
for i = 1:length(idxrat)
    gp05(i,:) = ANALYSIS_group(sub05(idxrat{i},:));   
end
%%
gpL = gp(gp.av_nFree == 6,:);
gpS = gp(gp.av_nFree == 1,:);
% colrat2 = {'AZred', 'AZred50', 'AZsky', 'AZsky50', 'AZcactus', 'AZcactus50', 'AZsand', 'AZsand50'};
ratnames = gpL.rat;
colrat = {'AZred', 'AZsky', 'AZcactus', 'AZsand'};
%% overall accuracy
legs =  arrayfun(@(x)sprintf('%s, H = %d', ratnames{x}, 6), 1:length(ratnames), 'UniformOutput', false);
plt_initialize;
plt_figure;
plt_setfig('legend', legs, 'legloc', 'SouthEast', 'color', colrat, ...
    'xlabel', 'trial number', 'ylabel', 'p(better feeder)');
plt_new;
plt_lineplot(gpL.av_c_ac, gpL.ste_c_ac);
plt_update;
%% exploration 
legs =  arrayfun(@(x)sprintf('%s, H = %d', ratnames{x}, 6), 1:length(ratnames), 'UniformOutput', false);
plt_figure;
plt_setfig('legend', legs, 'legloc', 'SouthEast', 'color', colrat, ...
    'xlabel', 'trial number', 'ylabel', 'p(explore)');
plt_new;
plt_lineplot(gpL.av_c_explore, gpL.ste_c_explore);
plt_update;
%% repeat 
legs =  arrayfun(@(x)sprintf('%s, H = %d', ratnames{x}, 6), 1:length(ratnames), 'UniformOutput', false);
plt_figure;
plt_setfig('legend', legs, 'legloc', 'SouthEast', 'color', colrat, ...
    'xlabel', 'trial number', 'ylabel', 'p(repeat)');
plt_new;
plt_lineplot(gpL.av_c_repeat, gpL.ste_c_repeat);
plt_update;
%% horizon contrast in exploration
nGuided = mean(gp.av_nGuided);
av = [gpS.av_c_explore(:,nGuided+1), gpL.av_c_explore(:,nGuided+1)];
ste = [gpS.ste_c_explore(:,nGuided+1), gpL.ste_c_explore(:,nGuided+1)];
plt_figure;
plt_setfig('legend', legs, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(explore)','xlim', [0.5 2.5],...
    'xtick',[1 2], 'xticklabel', {'S','L'});
plt_new;
plt_lineplot(av, ste);
plt_update;
%%
gpRL = gpR(gpR.av_nFree == 6,:);
gpRS = gpR(gpR.av_nFree == 1,:);
% colrat2 = {'AZred', 'AZred50', 'AZsky', 'AZsky50', 'AZcactus', 'AZcactus50', 'AZsand', 'AZsand50'};
ratnames = gpRL.rat;
colrat = {'AZred', 'AZsky', 'AZcactus', 'AZsand'};
%% split by guided reward
plt_figure(1,3);
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(best feeder)', 'ylim', [0 1]);
r0 = [0  1  5];
for i = 1:3
    tgp = gpRL(gpRL.av_r_guided == r0(i),:);
    plt_new;
    plt_lineplot(tgp.av_c_ac, tgp.ste_c_ac);
    plt_update;
end
%% split by guided reward
plt_figure(1,3);
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(explore)', 'ylim', [0 1]);
r0 = [0  1  5];
for i = 1:3
    tgp = gpRL(gpRL.av_r_guided == r0(i),:);
    plt_new;
    plt_lineplot(tgp.av_c_explore, tgp.ste_c_explore);
    plt_update;
end
%% split by guided reward
plt_figure(1,3);
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(repeat)', 'ylim', [0 1]);
r0 = [0  1  5];
for i = 1:3
    tgp = gpRL(gpRL.av_r_guided == r0(i),:);
    plt_new;
    plt_lineplot(tgp.av_c_repeat, tgp.ste_c_repeat);
    plt_update;
end
%% compare [1 0]  and [1 5]
tgp0 = gp05(gp05.av_nFree == 6  &  gp05.av_r_guided ==1,:);
ratnames = tgp0(tgp0.av_rpairID == 1,:).rat;
colrat = {'AZred', 'AZsky', 'AZcactus', 'AZsand'};
plt_figure(1,2);
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(best feeder)', 'ylim', [0 1], ...
    'title',  {'0 vs 1', '1 vs 5'});
r0 = [1 15];
for i = 1:2
    tgp = tgp0(tgp0.av_rpairID == r0(i),:);
    plt_new;
    plt_lineplot(tgp.av_c_ac, tgp.ste_c_ac);
    plt_update;
end
plt_figure(1,2);
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(explore)', 'ylim', [0 1],...
    'title',  {'0 vs 1', '1 vs 5'});
r0 = [1 15];
for i = 1:2
    tgp = tgp0(tgp0.av_rpairID == r0(i),:);
    plt_new;
    plt_lineplot(tgp.av_c_explore, tgp.ste_c_explore);
    plt_update;
end
%% horizon change split by guided reward
plt_figure(1,3);
nGuided = mean(gp.av_nGuided);
r0 = [0  1  5];
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(explore)','xlim', [0.5 2.5],...
    'xtick',[1 2], 'xticklabel', {'S','L'}, 'ylim', [0 1]);
for i = 1:3
    tgpL = gpRL(gpRL.av_r_guided == r0(i),:);
    tgpS = gpRS(gpRS.av_r_guided == r0(i),:);
    av = [tgpS.av_c_explore(:,nGuided+1), tgpL.av_c_explore(:,nGuided+1)];
    ste = [tgpS.ste_c_explore(:,nGuided+1), tgpL.ste_c_explore(:,nGuided+1)];
    plt_new;
    plt_lineplot(av, ste);
    plt_update;
end
%% 

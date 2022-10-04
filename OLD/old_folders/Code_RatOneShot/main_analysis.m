clear
datadir = './';
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
%%
addpath('./RatRLModels');
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
%%
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
%% figure 1 
gpL = gp(gp.av_nFree == 6,:);
gpS = gp(gp.av_nFree == 1,:);
subL = sub(sub.nFree == 6,:);
ratnames = {'Hachi', 'Tianqi'};
colrat = {'AZred', 'AZblue'};

legs =  arrayfun(@(x)sprintf('%s, H = %d', ratnames{x}, 6), 1:length(ratnames), 'UniformOutput', false);
plt_initialize;
plt_figure;
plt_setfig('legend', legs, 'legloc', 'SouthEast', 'color', colrat, ...
    'xlabel', 'trial number', 'ylabel', 'p(better feeder)');
plt_new;
plt_lineplot(subL.c_ac, []);
plt_update;

%%
plt_figure(1,2,'istitle',1);
nGuided = mean(gp.av_nGuided);
ratnames = {'Hachi','Tianqi'};
gpRL = gpR(gpR.av_nFree == 6,:);
gpRS = gpR(gpR.av_nFree == 1,:);
r0 = [0  1  3 5];
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'Guided Reward', 'ylabel', 'p(explore)','xlim', [0.5 4.5],...
    'xtick',[1:4], 'xticklabel',r0,...%arrayfun(@(x)"R_{guided} = " + num2str(x), r0, 'UniformOutput', false) 
    'ylim', [0 1]);
for idxrat = 1:2
    plt_new;
    plt_setfig_ax('color', {'AZblue', 'AZred'},'legend', {'S', 'L'},...
      'title', ratnames{idxrat});
     tgpL = gpRL(strcmp(gpRL.rat, ratnames{idxrat}),:);
     tgpS = gpRS(strcmp(gpRS.rat, ratnames{idxrat}),:);
     av = [tgpS.av_c_explore(:,nGuided+1), tgpL.av_c_explore(:,nGuided+1)]';
     ste = [tgpS.ste_c_explore(:,nGuided+1), tgpL.ste_c_explore(:,nGuided+1)]';
     plt_lineplot(av, ste);
end
plt_update;
%% guided to 0, 1, 3, 5, split by reward of the other feeder
td = data(strcmp(data.rat,'Tianqi') &  data.nFree == 6,:);
rguided = td.r_guided;
re = sum(td.r_side')' - rguided;
ce =  1-td.c_repeat;
rs = [0  1 3 5];
pe = {};sepe = {};
for i = 1:4
    idxi = rguided == rs(i);
    for j = 1:9
       [pe{i}(:, j) sepe{i}(:,j)] = tool_bin_average(ce(idxi,j),  re(idxi,:), [-0.5 0.5 2 4 6]);
    end
end
plt_figure(2,2);
cols = {'AZred', 'AZsand', 'AZcactus', 'AZblue'};
for i  = 1:4
    plt_new;
    plt_setfig_ax('color', cols,'ylim',[0 1],'legend',{'0','1','3','5'},...
        'legloc', 'NorthWest','xlabel','trial number', 'ylabel', 'p(switch)', ...
        'xlim', [0 10]);
    plt_lineplot(pe{i}, sepe{i},[],'line');
end
plt_update;
%%
plt_figure(1,2,'istitle',1);
ratnames = {'Hachi','Tianqi'};
r0 = [0  1  3 5];
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'Guided Reward', 'ylabel', 'p(explore)','xlim', [0.5 4.5],...
    'xtick',[1:4], 'xticklabel',r0,...%arrayfun(@(x)"R_{guided} = " + num2str(x), r0, 'UniformOutput', false) 
    'ylim', [0 1]);
for idxrat = 1:2
    
    pe = [];sepe = [];
    for hi = 1:2
        td = data(strcmp(data.rat,ratnames{idxrat}) &  (data.nFree == hi*5 - 4),:);
        rguided = td.r_guided;
        ce =  td.c_explore(:,4);
        rs = [0  1 3 5];
        for i = 1:4
            idxi = rguided == rs(i);
            [pe(hi,  i),sepe(hi,  i)] = tool_bin_average(ce(idxi),ce(idxi), [-Inf Inf]);
        end
    end
    plt_new;
    plt_setfig_ax('color', {'AZblue', 'AZred'},'legend', {'S', 'L'},...
      'title', ratnames{idxrat});
     plt_lineplot(pe, sepe);
end
plt_update;
%%
% colrat2 = {'AZred', 'AZred50', 'AZsky', 'AZsky50', 'AZcactus', 'AZcactus50', 'AZsand', 'AZsand50'};
ratnames = gpL.rat;

%% exploration 
legs =  arrayfun(@(x)sprintf('%s, H = %d', ratnames{x}, 6), 1:length(ratnames), 'UniformOutput', false);
plt_figure;
plt_setfig('legend', legs, 'legloc', 'SouthEast', 'color', {'AZcactus', 'AZsand'}, ...
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
plt_figure(2,2);
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(best feeder)', 'ylim', [0 1]);
r0 = [0  1  3 5];
for i = 1:4
    tgp = gpRL(gpRL.av_r_guided == r0(i),:);
    plt_new;
    plt_lineplot(tgp.av_c_ac, tgp.ste_c_ac);
    plt_update;
end
%% split by guided reward
plt_figure(2,2);
plt_setfig('legend', {'Hachi','Tianqi'}, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(explore)', 'ylim', [0 1]);
r0 = [0  1  3 5];
for i = 1:4
    tgp = gpRL(gpRL.av_r_guided == r0(i),:);
    plt_new;
    plt_lineplot(tgp.av_c_explore, tgp.ste_c_explore);
    plt_update;
end
%% split by guided reward
plt_figure(2,2);
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(repeat)', 'ylim', [0 1]);
r0 = [0  1 3 5];
for i = 1:4
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
plt_figure(1,2);
nGuided = mean(gp.av_nGuided);
r0 = [0  1  3 5];
plt_setfig('legend', ratnames, 'legloc', 'SouthWest', 'color', colrat, ...
    'xlabel', 'horizon', 'ylabel', 'p(explore)','xlim', [0.5 2.5],...
    'xtick',[1 2], 'ylim', [0 1]);
for idxrat = 1:2
    plt_new;
    plt_setfig_ax('legend', arrayfun(@(x)"R_{guided} = " + num2str(x), r0, 'UniformOutput', false));
    plt_setfig_ax('color', {'AZred10', 'AZred30', 'AZred60', 'AZred'},...
     'xticklabel', {'S','L'}, 'title', tgpS.rat{idxrat});
    for i = 1:4
        tgpL = gpRL(gpRL.av_r_guided == r0(i),:);
        tgpS = gpRS(gpRS.av_r_guided == r0(i),:);
        av = [tgpS.av_c_explore(idxrat,nGuided+1), tgpL.av_c_explore(idxrat,nGuided+1)];
        ste = [tgpS.ste_c_explore(idxrat,nGuided+1), tgpL.ste_c_explore(idxrat,nGuided+1)];
        plt_lineplot(av, ste);
    end
end
plt_update;

%% 

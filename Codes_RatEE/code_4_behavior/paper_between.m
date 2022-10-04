fn = '../../data_processed/versions_cleaned/final_between_all.csv';
data = W.readtable(fn);
%% preprocess
sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'n_guided'});
data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
%% ac
sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
data = W_sub.preprocess_subxgame(data, sessions, 'performance_RatEE');
%% get func_cond_drop
sessions = W_sub.selectsubject(data, {'foldername', 'filename'});
tdata = W_sub.preprocess_subxgame(data, sessions, {'func_cond_drop'});
tid = tdata.cond_drop ~= '17';% & tdata.cond_drop ~= '015';
% tid = tdata.cond_drop == '012345' | tdata.cond_drop == '0135';
data = tdata(tid,:);
%% exclude sessions based accuracy
tac = W_sub.analysis_group(data, {'rat', 'foldername','cond_horizon'});
%%
cols = {'AZblue', 'AZred', 'AZcactus', 'AZsand','AZbrick','AZsky'};
syms = strcat('-', {'o','o','+','^','^','x','d'});
ww = W_colors;
rats = unique(tac.rat);
nrat = length(rats);
conds = unique(tac.str_guidefree);
ncond = length(conds);
for i = 1:nrat
    for j = 1:ncond
        tid = strcmp(tac.rat, rats(i)) & strcmp(tac.str_guidefree, conds(j));
        if any(tid)
            td = tac(tid,:);
            plot(td.datetime, nanmean(td.av_cc_best,2), syms{j}, 'color', ww.(cols{i}));
            hold on;
        end
    end
end
%%
acs = nanmean(tac.av_cc_best,2);
% tid = find(acs < 0.4);
tid1 = find(tac.datetime < datetime(2020, 10, 30) & ismember(tac.rat,{'Gerald','Twenty'}) & tac.av_n_free >= 15);
tid2 = [];%find(acs < 0.4 & tac.av_n_free == 6 & ismember(tac.rat,{'Ratzo','Rizzo'}))
tid = [tid1; tid2];
ses_exclude = tac(tid,:).foldername;
mean(~contains(data.foldername, ses_exclude))
data = data(~contains(data.foldername, ses_exclude),:);
% %% session plot
% tses = W_sub.selectsubject(tac, {'rat', 'foldername'});
% tac_ses =  W_sub.tab_trial2game(tac, tses);
% %%
% tac = tac(tac.av_n_free > 1,:);
% data = data(contains(data.foldername, tac.foldername(tac.av_cc_best_smoothed > 0.5)),:);
%% include only horizon 3
data = data(ismember(data.cond_guided, [3]), :);
%%
id = data.cond_horizon == 15;
sum(id)/length(unique(data(id,:).rat))
sum(id)/length(unique(data(id,:).foldername))
sum(data(id,:).n_free + data(id,:).n_guided)/length(unique(data(id,:).foldername))
%% exclude transition sessions (for each rat)
rats = {'Hachi','Tianqi','Ratzo','Rizzo','Twenty','Gerald'};
id = {}; rd= {};
for i = 1:length(rats)
    id{i} = find(strcmp(data.rat, rats{i})); % H = 1 first, H = 6  next
    rd{i} = data(id{i},:);
%     rd{i} = sortrows(rd{i}, {'date','time'});
end
%%
plt = W_plt;
plt.figure(2,3); 
plt.setfig('title', rats);
for i = 1:6
    x = rd{i};
    x = sortrows(x, {'date','time'});
    xid = W_sub.selectsubject(x, {'date','time','cond_horizon'});
    pe = cellfun(@(t)nanmean(x.ce_cc_best(t)),xid);
    xcd = cellfun(@(t)mean(x.cond_horizon(t)),xid);
    out = [pe';xcd'/15];
    plt.new; plt.lineplot(out);
end
plt.update;
%%
i = 1;
unique([rd{i}.date,rd{i}.time rd{i}.cond_horizon],'rows')
%%
i = 1;
tid = ~(ismember(rd{i}.date, [20200324:20200330]) | ...
    ismember(rd{i}.date * 1000000+rd{i}.time, ...
    [20200414112950]));
trd{i} = data(id{i}(tid),:);

i = 2;
tid = ~(ismember(rd{i}.date, [20200324:20200330]) | ...
    ismember(rd{i}.date * 1000000+rd{i}.time, ...
    [20200413100428]));
trd{i} = data(id{i}(tid),:);

i = 3;
tid = ~(ismember(rd{i}.date, [20200330 20200413 20200803, 20201217]) | ...
    ismember(rd{i}.date * 1000000+rd{i}.time, ...
    [0]));%20200726165318
trd{i} = data(id{i}(tid),:);

i = 4;
tid = ~(ismember(rd{i}.date, [20200330 20200413 20200803 20201215]) | ...
    ismember(rd{i}.date * 1000000+rd{i}.time, ...
    [0])); %20200726153400
trd{i} = data(id{i}(tid),:);

i = 5;
tid = ~(ismember(rd{i}.date, [20201030 20201118 20201215 20210203]) | ...
    ismember(rd{i}.date * 1000000+rd{i}.time, ...
    [0]));
trd{i} = data(id{i}(tid),:);

i = 6;
tid = ~(ismember(rd{i}.date, [20201030 20201215 20210203]) | ...
    ismember(rd{i}.date * 1000000+rd{i}.time, ...
    [0]));
trd{i} = data(id{i}(tid),:);
%%
for i = 1:length(rats)
    if i == 1
        data = trd{1};
    else
        data = [data; trd{i}];
    end
end
%% quickly calculate p(explore)
tpb = [];
for i = 1:length(rats)
    ttt = trd{i};
%     ttt = ttt(ttt.gameID > 1,:);
    tpb(i,1) = mean(ttt.c1_cc_explore(ttt.cond_horizon == 1));
    tpb(i,2) = mean(ttt.c1_cc_explore(ttt.cond_horizon == 6));
    tpb(i,3) = mean(ttt.c1_cc_explore(ttt.cond_horizon >=15));
end
tpb
nanmean(tpb)
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
save('../../data_processed/output/gp_between', 'gp', 'sub');
%% get bayes
bayesname = replace(fn, 'final', 'bayes');
bayesname = replace(bayesname, '.csv', '');
bayesname = replace(bayesname, 'versions_cleaned', 'bayesdata');
get_bayesdata(data, bayesname);



%% preprocess
tt(1) = 0; cpb(1) = NaN; cpc(1) = NaN;
tt(5) = 0; cpb(5) = NaN; cpc(5) = NaN;
for i = 1:height(data)
    te = data.feeders(i,data.drop(i,:) == data.r_best(i));
    data.fd_best(i) = tool_iif(length(te) == 1, te, NaN);
    data.side_best(i) = nan_extend(find(data.feeders(i,:) == data.fd_best(i)),1);
    thb = data.homebase(i);
    data.c_lastbest(i) = cpb(thb);
    data.c_lastself(i) = cpc(thb);
    cpb(thb) = data.fd_best(i);
    cpc(thb) = data.choice(i, data.nGuided(i)+ data.nFree(i));
    data.timefrom_lasthomebase(i) = min(data.timestamp_visit_choice(i,:)) - tt(thb);
    tt(thb) = max(data.timestamp_visit_choice(i,:));
    data.c_sameaslastbest(i) = data.choice(i,data.nGuided(i)+1) == data.c_lastbest(i);
    data.c_sameaslastself(i) = data.choice(i,data.nGuided(i)+1) == data.c_lastself(i);
end
%%
idxsub = selectsubject(data, {'rat','nFree','nGuided'});
nidxsub = cellfun(@(x)length(x), idxsub);
idxsub = idxsub(nidxsub > 20);
sub = ANALYSIS_sub(data, idxsub, 'basic', 'basic', 'RatEE_analysis');
%%
nG = sub.nGuided;
nF = sub.nFree;
gp06 = ANALYSIS_group(sub(nG == 0 & nF == 7,:));
gp01 = ANALYSIS_group(sub(nG == 0 & nF == 2,:));
gp3 = ANALYSIS_group(sub(nG == 3 & nF == 1,:));
gp1 = ANALYSIS_group(sub(nG == 1 & nF == 1,:));
gp36 = ANALYSIS_group(sub(nG == 3 & nF == 6,:));
gp16 = ANALYSIS_group(sub(nG == 1 & nF == 6,:));
gp = tool_vertcat(gp01, gp1, gp3, gp06, gp16, gp36);
tleg = {'h = 1, nG = 0','h = 1, nG = 1','h = 1, nG = 3','h = 6, nG = 0','h = 6, nG = 1','h = 6, nG = 3'}
%%
gp00 = ANALYSIS_group(sub(nG == 0,:));
gp33 = ANALYSIS_group(sub(nG == 3,:));
gp11 = ANALYSIS_group(sub(nG == 1,:));
gp = tool_vertcat(gp00, gp11, gp33);
tleg = {'nG = 0','nG = 1','nG = 3'}
%% previous game
plt_figure;
plt_new;
plt_setfig('xlim', [0.5, 6.5], 'xtick', [1:6], 'xticklabel', tleg, ...
    'ylabel', 'p(repeat chocie from previous games)', 'legend', {'best', 'self'});
plt_lineplot(gp.av_temp_clastgamebest(:,1)', gp.ste_temp_clastgamebest(:,1)')
plt_lineplot(gp.av_temp_clastgameself(:,1)', gp.ste_temp_clastgameself(:,1)')
plt_update;
xtickangle(45)
%% feeder bias
plt_figure;
plt_new;
plt_setfig('xlim', [0.5, 4.5], 'xtick', [1:4], 'xticklabel', [2 4 6 8], ...
    'ylabel', 'p(feeder)', 'legend', tleg);
plt_lineplot(gp.av_percfeeder, gp.ste_percfeeder)
plt_update;
xtickangle(45)
%%

gp1 = ANALYSIS_group(sub(sub.cond_horizon == 6 &  sub.nGuided ==0,:));
gp2 = ANALYSIS_group(sub(sub.cond_horizon == 6 &  sub.nGuided ==1,:));
gp3 = ANALYSIS_group(sub(sub.cond_horizon == 6 &  sub.nGuided ==3,:));
gp = tool_vertcat(gp1, gp2, gp3);
%%
plt_figure;
plt_new;
plt_setfig('xlim', [0.5, 6.5], 'xtick', [1:6], ...
    'ylabel', 'p(correct)', 'legend', tleg);
plt_lineplot(gp.av_trialn_ac, gp.ste_trialn_ac)
plt_update;
xtickangle(45)
%%
plt_figure;
plt_new;
plt_setfig('xlim', [0.5, 6.5], 'xtick', [1:6],'xticklabel',[0:5], ...
    'ylabel', 'p(switch)', 'legend', tleg,'ylim', [0 1], 'ytick',[0:0.2:1],'xlabel','r guided');
plt_lineplot(1-gp.av_rcurve_ee, gp.ste_rcurve_ee)
plt_update;
xtickangle(45)
%%
plt_figure;
plt_new;
plt_setfig('xlim', [0.5, 6.5], 'xtick', [1:6],'xticklabel',[0:5], ...
    'ylabel', 'p(ac)', 'legend', tleg,'ylim', [0 1], 'ytick',[0:0.2:1],'xlabel','r guided');
plt_lineplot(gp.av_rcurve_ac, gp.ste_rcurve_ac)
plt_update;
xtickangle(45)
%% first vs second session

%% first games of the day

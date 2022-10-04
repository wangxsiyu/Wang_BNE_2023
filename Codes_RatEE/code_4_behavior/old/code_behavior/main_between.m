
%% get performance by day
%%
dt = datetime(sub.date, 'ConvertFrom', 'YYYYMMDD');
ac = sub.accuracy;
num = sub.n_trials;
rats = string(unique(sub.rat));
conds =unique(sub.cond_horizon);
vv = sub.vv;
nf = sub.n_free;
figure;
for ri = 1:length(rats)
    subplot(2,3,ri);
    rid = sub.rat == rats(ri);
    for ci = 1:length(conds)
        cid = sub.cond_horizon == conds(ci);
        tid = find(rid & cid);
        hold on;
        plot(dt(tid), vr(tid),'*');
    end
end
%% display condition
disp_cond_ratEE(data);
%% save bayesian data
get_bayesdata(data, fullfile(datadir, 'bayesdata', 'gameversion_between'));
%%
%%
gp = gp([3 2 1],:);
%%


    %% by good/bad guide


    %% by R guided
% %%
% %% plot - by group
% plt = ratfig_behavior_gp(plt, gp);
% %% plot - by rat

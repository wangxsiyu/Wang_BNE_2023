rat = importdata('../../data_processed/output/gp_between.mat');
human = importdata('../../data_processed/output/gp_human.mat');
humanf = importdata('../../data_processed/output/gp_human_full.mat');
%% figure
plt = W_plt('fig_dir', '../../figures','fig_projectname', 'between','fig_saveformat','emf');
plt.setuserparam('param_setting', 'isshow', 1);
%% colors
col_rat = {'AZcactus', 'AZred', 'AZblue'};
leg_rat = strcat("H = ",rat.gp.group_analysis.cond_horizon);
col_human = {'AZcactus', 'AZred', 'AZsky','AZblue'};
leg_human = strcat("H = ",human.gp.group_analysis.cond_horizon);
%% contrast - behavior
figure4_basic(plt, rat, human);
%% split by good/bad
figure5_split(plt,rat,human);
%% split by towards/away
figureS2_split_awaytowards(plt,rat,human);
%% stat - behavior
xx = rat;
rt = xx.sub.rat;
rt = cellfun(@(x)find(strcmp(x, unique(rt))),rt);
hh = xx.sub.cond_horizon;
% 
for i = 1:max(hh)
    aa = xx.sub.av_cc_best(:, i);
    aa = aa(~isnan(aa));
    [~,pp(i)] = ttest(aa-0.5);
end
pp

pp = [];
hs =unique(hh);
for i = 1:6
te = xx.sub.bin_all_ce_cc_explore(:,2) - xx.sub.bin_all_c1_cc_best;
te = te(:,i);
te = te(te ~= 0);
[~,pp(i)] = ttest(te)
%     for j =1:length(hs)
%         [~,pp(i, j)] = ttest(te(hh == hs(j)));
%     end
% anovan(te, hh)
end
% 
% aa = xx.sub.av_cc_best;
% aa = arrayfun(@(x)aa(x, hh(x)) - aa(x,1), 1:length(hh));
% aa = [aa', rt, hh];
% aa = aa(~isnan(aa(:,1)),:);
% [~,pp] = ttest(aa(:,1))
% 
% mean(xx.sub.av_cc_switch(hh == 6,1))
% nanmean(xx.sub.av_cc_switch(hh == 6,2:end),'all')
% mean(xx.sub.av_cc_switch(hh == max(hh),1))
% nanmean(xx.sub.av_cc_switch(hh == max(hh),2:end),'all')
% 
% nanmean(xx.sub.av_cc_switch(hh == 2,1))
% nanmean(xx.sub.av_cc_switch(hh == 5,1))
% nanmean(xx.sub.av_cc_switch(hh == 10,1))
% nanmean(xx.sub.av_cc_switch(hh == 2,2))
% nanmean(xx.sub.av_cc_switch(hh == 5,2))
% nanmean(xx.sub.av_cc_switch(hh == 10,2))
% 
x1 = reshape(xx.sub.av_cc_switch(hh == 6,2:6),[],1)
x2 = reshape(xx.sub.av_cc_switch(hh == 15,11:15),[],1)
[~,pp] = ttest2(x1,x2)

anovan([x1;x2],[[ceil((1:30)/6)';ceil((1:20)/4)'], [ones(30,1); ones(20,1)*2]])
aa = [xx.sub.av_cc_switch(:,2) - xx.sub.av_cc_switch(:,1), rt, hh];
aa = aa(~isnan(aa(:,1)),:);
[~,pp] = ttest(aa(:,1))
%% R curve
figure6_rcurve(plt, rat, human)
%%
figure7_rcurve_switch(plt, rat, human)
%% load samples
hbidir = '../../result_bayes';
file = fullfile(hbidir, 'HBI_model_simple_between_all_samples.mat');
file = fullfile(hbidir, 'HBI_model_simple_history_between_all_samples.mat');
sp1 = importdata(file);
file = fullfile(hbidir, 'HBI_model_simple_human_samples.mat');
file = fullfile(hbidir, 'HBI_model_simple_history_human_samples.mat');
sp2 = importdata(file);
file = fullfile(hbidir, 'HBI_model_simple_between_all_stat.mat');
file = fullfile(hbidir, 'HBI_model_simple_history_between_all_stat.mat');
st1 = importdata(file).stats;
file = fullfile(hbidir, 'HBI_model_simple_human_stat.mat');
file = fullfile(hbidir, 'HBI_model_simple_history_human_stat.mat');
st2 = importdata(file).stats;
%%
figure8_bayes_exp1(plt,sp1,sp2,st1,st2);
%%
figureS3_otherpos_exp1(plt,sp1,sp2);
%%
figureS4_past_exp1(plt, human, rat);
%%
% hh = rat.sub.cond_horizon;
% cc = rat.sub.LG_bin_all_c1_cc_explore;
% cc = reshape(cc,[],1);
% rid = arrayfun(@(x) find(ismember(unique(rat.sub.rat), x)),rat.sub.rat);
% tt = [cc, repmat(hh, 7,1),reshape(repmat(-1:5, length(hh),1),[],1), repmat(rid, 7,1)];
% tt = tt(~isnan(cc),:);
% anovan(tt(:,1), tt(:,2:4),'random',3,'model','interaction')

%%
% hh = rat.sub.cond_horizon;
% cc = rat.sub.LS_bin_all_c1_cc_explore;
% cc = reshape(cc,[],1);
% rid = arrayfun(@(x) find(ismember(unique(rat.sub.rat), x)),rat.sub.rat);
% tt = [cc, repmat(hh, 7,1),reshape(repmat(-1:5, length(hh),1),[],1), repmat(rid, 7,1)];
% tt = tt(~isnan(cc),:);
% anovan(tt(:,1), tt(:,2:4),'random',3,'model','interaction')
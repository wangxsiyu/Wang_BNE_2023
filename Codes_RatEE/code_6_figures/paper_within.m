dat = importdata('../../data_processed/output/gp_within.mat');
gp = dat.gp;
sub = dat.sub;
%%
hbidir = '../../result_bayes';
file = fullfile(hbidir, 'HBI_model_rat_within_all_samples.mat');
file = fullfile(hbidir, 'HBI_model_rat_history_within_all_samples.mat');
sp = importdata(file);
file = fullfile(hbidir, 'HBI_model_rat_within_all_stat.mat');
file = fullfile(hbidir, 'HBI_model_rat_history_within_all_stat.mat');
st = importdata(file);
%%
plt = W_plt('fig_dir', '../../figures','fig_projectname', 'within','fig_saveformat','emf');
%% horizon difference
figure9_exp2(plt, gp, sub, sp, st);
%% effect guide vs free
figure11_exp2(plt, gp, sub)
%%
figure12_exp2(plt, sp, st);
%% test
hh = sub.cond_horizon;
gg = sub.cond_guided;
cc = sub.av_cc_switch;
cc(:,1) = NaN;
id = hh == 6;
tc = reshape(cc(id,:),[],1);
tid = repmat(1:4,1,12)';
th = ceil((1:48)/8)';
tg = repmat([0 0 0 0 1 1 1 1],1,6)';
anovan(tc, [tid, th, tg],'random',2)
%% other parameters
figureS6_bayesother_exp2(plt, sp, st)
%% barplot
figureS6b_history(plt, sp, st)
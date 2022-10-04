datadir = '../../data_processed/bayesdata';
[~,datalists] = W.dir(fullfile(datadir, '*.mat'));
%% 
d = fullfile(datalists.folder_path(1), datalists.folder_name(6));
d = importdata(d);
% d.bayesdata.h = d.bayesdata.h * 0 + 1;
% d.bayesdata.nH = 1;
%%
fullpt = 'W:/Projects_Wang/Projects_submitted/Fellous_Siyu_RatEE_InRevision/Codes_RatEE/code_5_bayesian/models';
outputdir = 'W:/Projects_Wang/Projects_submitted/Fellous_Siyu_RatEE_InRevision/result_bayes/simu_simple';
%%
mi = 0;
mi = mi + 1;
modelname{mi} = 'model_simple_history.txt';
% params{mi} = {'noise_k','noise_lambda', 'noise', ...
%     'thres_mu', 'thres_sigma', ...
%     'tnoise','tthres'};
params{mi} = {'noise_k','noise_lambda', 'noise', ...
    'thres_a', 'thres_b', 'thres', ...
    'bias_mu','bias_sigma', 'bias', ...
    'lr_last','lr_last_a','lr_last_b', ...
    'lr_lastgs','lr_lastgs_a','lr_lastgs_b', ...
    'tlrlast', 'tlrlastgs', ...
    'tnoise','tthres','tbias'};
init0{mi} = struct;
%%
wj = W_JAGS();
wj.isoverwrite = true;
wj.setup_params(4, 1000, 1000);
%%
paramtruth = {};
%%
for repi = 1:100
    %% load data
    bayesdata = simulateMD(d);
    paramtruth{repi} = bayesdata.paramtruth;
    wj.setup_data_dir(bayesdata.bayesdata, outputdir);
    %% run
    mmi = 1;
    disp(sprintf('running dataset %d, model %d: %s', repi, mmi,modelname{mmi}));
    outfile = strcat('simu_','model_simple', num2str(repi));
    wj.setup(fullfile(fullpt, modelname{mmi}), params{mmi}, init0{mmi}, outfile);
    wj.run;
    save('W:\Projects_Wang\Projects_submitted\Fellous_Siyu_RatEE_InRevision\Codes_RatEE\code_5_bayesian\param_simu_simple.mat','paramtruth');
end
%% compare
filedir = ('W:\Projects_Wang\Projects_submitted\Fellous_Siyu_RatEE_InRevision\result_bayes\simu_simple');
% dirs = W.dir(filedir);
x = [];
y = [];
z = [];
vars = {'thres','noise','lr_last','lr_lastgs','bias'};
% vars = {'thres','noise','bias'};
paramtruth = importdata('W:\Projects_Wang\Projects_submitted\Fellous_Siyu_RatEE_InRevision\Codes_RatEE\code_5_bayesian\param_simu_simple.mat');
for i = 1:length(paramtruth)
    tst = importdata(fullfile(filedir, sprintf('HBI_simu_model_simple%d_stat.mat', i)));
    tsp = importdata(fullfile(filedir, sprintf('HBI_simu_model_simple%d_samples.mat', i)));
    tst = tst.stats.mean;
%     y(i,:) = cellfun(@(x)mean(tst.(x)), vars);
    z(i,:) = cellfun(@(x)getmap(tsp.(x),0.01), vars);
    x(i,:) = cellfun(@(x)x,paramtruth{i});
end
% x = x(:,[1 2 5]);
%%
plt = W_plt('fig_dir', '../../figures','fig_projectname', 'param','fig_saveformat','emf');
plt.setuserparam('param_setting', 'isshow', 1);
plt.figure(2,3,'istitle','matrix_hole',[1 1 1;1 1 0], ...
    'gap',[0.2 0.1]);
plt.param_figsetting.islegbox = false;
tlts = {'threshold','noise','\alpha_{LG}','\alpha_{LS}','bias'};
plt.setfig('title',tlts,'legloc','SouthEast');
llmm = {[-1 6],[-1 11],[-0.1 0.6],[-0.1,0.6],[-3 3]};
plt.setfig('xlim', llmm, ...
    'ylim', llmm);
for i = 1:5
    plt.new;
    str = plt.scatter(x(:,i), z(:,i),'diag');
    plt.setfig_ax('legend',str,...
        'xlabel',sprintf('simulated %s', ''),...
        'ylabel',sprintf('recovered %s', ''));
end
plt.update;
plt.save('param_recover')
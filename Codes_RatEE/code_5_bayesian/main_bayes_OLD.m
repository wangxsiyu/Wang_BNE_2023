%% load datadir
datadir = '../../data_processed/bayesdata';
[~,datalists] = W.dir(fullfile(datadir, '*.mat'));
%% setup full path
fullpt = 'W:/Projects_Wang/Projects_submitted/Fellous_Siyu_RatEE_InRevision/Codes_RatEE/code_5_bayesian/models';
outputdir = 'W:/Projects_Wang/Projects_submitted/Fellous_Siyu_RatEE_InRevision/result_bayes';
%%
mi = 0;
mi = mi + 1;
modelname{mi} = 'model_simple.txt';
params{mi} = {'noise_k','noise_lambda', 'noise', ...
    'thres_a', 'thres_b', 'thres', ...
    'tnoise','tthres','bias_mu','bias_sigma','tbias'};
init0{mi} = struct;

mi = mi + 1;
modelname{mi} = 'model_rat.txt';
params{mi} = {'noise_k','noise_lambda', 'noise', ...
    'thres_a', 'thres_b', 'thres', ...
    'tnoise','tthres','dthres', 'dnoise',...
    'tbias','dbias','bias_mu','bias_sigma'};
init0{mi} = struct;

mi = mi + 1;
modelname{mi} = 'model_human_full.txt';
params{mi} = {'noise_k','noise_lambda', 'noise', ...
    'thres_a', 'thres_b', 'thres', ...
    'tnoise','tthres','bias_mu','bias_sigma','tbias'};
%     'thres_mu', 'thres_sigma', ...
init0{mi} = struct;

mi = mi + 1;
modelname{mi} = 'model_long01.txt';
params{mi} = {'noise_k','noise_lambda', 'noise', ...
    'thres_a', 'thres_b', 'thres', ...
    'tnoise','tthres',...
    'tbias','bias_mu','bias_sigma'};
init0{mi} = struct;


mi = mi + 1;
modelname{mi} = 'model_simple_1H.txt';
% params{mi} = {'noise_k','noise_lambda', 'noise', ...
%     'thres_mu', 'thres_sigma', ...
%     'tnoise','tthres'};
params{mi} = {'noise_k','noise_lambda', 'noise', ...
    'thres_a', 'thres_b', 'thres', ...
    'tnoise','tthres','bias_mu','bias_sigma','tbias'};
init0{mi} = struct;


mi = mi + 1;
modelname{mi} = 'model_rat_history.txt';
params{mi} = {'noise_k','noise_lambda', 'noise', ...
    'thres_a', 'thres_b', 'thres', ...
    'bias_mu','bias_sigma', 'bias', ...
    'lr_last','lr_last_a','lr_last_b', ...
    'lr_lastgs','lr_lastgs_a','lr_lastgs_b', ...
    'tlrlast', 'tlrlastgs', ...
    'dbias','dthres', 'dnoise',...
    'tnoise','tthres','tbias'};
init0{mi} = struct;


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

mi = mi + 1;
modelname{mi} = 'model_human_full_history.txt';
params{mi} = {'noise_k','noise_lambda', 'noise', ...
    'thres_a', 'thres_b', 'thres', ...
    'bias_mu','bias_sigma', 'bias', ...
    'lr_last','lr_last_a','lr_last_b', ...
    'lr_lastgs','lr_lastgs_a','lr_lastgs_b', ...
    'tlrlast', 'tlrlastgs', ...
    'tnoise','tthres','tbias'};
%     'thres_mu', 'thres_sigma', ...
init0{mi} = struct;




mi = mi + 1;
modelname{mi} = 'model_simple_1H_history.txt';
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


% mi = mi + 1;
% modelname{mi} = 'model_within_diff.txt';
% params{mi} = {'noise_k','noise_lambda', 'noise', ...
%     'thres_mu', 'thres_sigma', ...
%     'dQ', 'P','tnoise','tthres','dthres_mu', 'dnoise_mu','dthres_sigma','dnoise_sigma',...
%     'tdthres','tdnoise'};
% init0{mi} = struct;
% 
% mi = mi + 1;
% modelname{mi} = 'model_lapse_2x2.txt';
% params{mi} = {'noise_k','noise_lambda', 'noise', ...
%     'thres_mu', 'thres_sigma', ...
%     'dQ', 'P','tnoise','tthres','dthres', 'dnoise', ...
%     'u','v','a','b','tlapse','dlapse'};
% init0{mi} = struct;
% 
% mi = mi + 1;
% modelname{mi} = 'model_within_H.txt';
% params{mi} = {'noise_k','noise_lambda', 'noise', ...
%     'thres_mu', 'thres_sigma', 'prior_a', 'prior_b', 'prior', 'a0', 'b0','alpha', ...
%     'tnoise','tthres', 'tprior', 'talpha' ...
%     'dnoise','dthres','dalpha'};
% init0{mi} = struct;
%%
datalists.modeli(:,1) = 1;
datalists(datalists.folder_name == "bayes_within_all.mat",:).modeli = 2;
datalists(datalists.folder_name == "bayes_long01.mat",:).modeli = 4;
datalists(datalists.folder_name == "bayes_human_full.mat",:).modeli = 3;
datalists(datalists.folder_name == "bayes_control.mat",:).modeli = 5;
datalists(end+1,:) = datalists(datalists.folder_name == "bayes_within_all.mat",:);
datalists(end,:).modeli = 6;
datalists(end+1,:) = datalists(datalists.folder_name == "bayes_between_all.mat",:);
datalists(end,:).modeli = 7;
datalists(end+1,:) = datalists(datalists.folder_name == "bayes_human.mat",:);
datalists(end,:).modeli = 7;
datalists(end+1,:) = datalists(datalists.folder_name == "bayes_human_full.mat",:);
datalists(end,:).modeli = 8;
datalists(end+1,:) = datalists(datalists.folder_name == "bayes_within_sound.mat",:);
datalists(end,:).modeli = 7;
datalists(end+1,:) = datalists(datalists.folder_name == "bayes_control.mat",:);
datalists(end,:).modeli = 9;


%% setup JAGS/params
wj = W_JAGS();
wj.isoverwrite = true;
% wj.setup_params;
wj.setup_params(4, 10000, 10000);
%% run select
% wselect = 2; %mi;%1:mi;
%% run models
for di = [size(datalists,1)]
    %% load data
    bayesdata = importdata(fullfile(datalists.folder_path(di), datalists.folder_name(di)));
    wj.setup_data_dir(bayesdata.bayesdata, outputdir);
    %% run
    mmi = datalists.modeli(di);
%     for mmi = wselect
%         try
            disp(sprintf('running dataset %d, model %d: %s', di, mmi,modelname{mmi}));
            outfile = W.file_deext(datalists.folder_name(di));
            outfile = replace(outfile, 'bayes_', replace(modelname{mmi},'.txt','_'));
            wj.setup(fullfile(fullpt, modelname{mmi}), params{mmi}, init0{mmi}, outfile);
            wj.run;
%         catch
%             warning('!!!!!!!!!!!!!!!!!!failed');
%         end
%     end
end
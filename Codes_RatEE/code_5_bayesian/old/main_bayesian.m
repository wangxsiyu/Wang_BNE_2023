%% load datadir
datadir = '../../data_processed/bayesdata';
[~,datalists] = W.dir(fullfile(datadir, '*.mat'));
%% setup full path
fullpt = '/Users/wang/WANG/Fellous_Siyu_RatEE/Codes_RatEE/code_bayesian/models';
outputdir = '/Users/wang/WANG/Fellous_Siyu_RatEE/result_bayes';
%%
mi = 0;
% mi = mi + 1;
% modelname{mi} = 'model_simple_1rat.txt';
% params{mi} = {'noise_k','noise_lambda', 'noise', ...
%      'thres_mu', 'thres_sigma', ...
%     'dQ', 'P','tnoise','tthres'};
% init0{mi} = struct;


mi = mi + 1;
modelname{mi} = 'model_simple.txt';
params{mi} = {'noise_k','noise_lambda', 'noise', ...
    'thres_mu', 'thres_sigma', ...
    'dQ', 'P','tnoise','tthres'};
init0{mi} = struct;

% mi = mi + 1;
% modelname{mi} = 'model_lapse.txt';
% params{mi} = {'noise_k','noise_lambda', 'noise', ...
%     'thres_mu', 'thres_sigma', ...
%     'dQ', 'P','tnoise','tthres', 'u','v','a','b','tlapse'};
% init0{mi} = struct;
%% setup JAGS/params
wj = W_JAGS();
wj.isoverwrite = true;
% wj.setup_params;
wj.setup_params(4, 4000, 6000);
%% run select
wselect = 1:mi;
%% run models
for di = 1:size(datalists,1)
    %% load data
    bayesdata = importdata(fullfile(datalists.folder_path(di), datalists.folder_name(di)));
    wj.setup_data_dir(bayesdata.bayesdata, outputdir);
    %% run
    for mmi = wselect
        try
            disp(sprintf('running dataset %d, model %d/%d: %s', di, mmi,mi,modelname{mmi}));
            outfile = W.file_deext(datalists.folder_name(di));
            outfile = replace(outfile, 'bayes_', replace(modelname{mmi},'.txt','_'));
            wj.setup(fullfile(fullpt, modelname{mmi}), params{mmi}, init0{mmi}, outfile);
            wj.run;
        catch
            warning('!!!!!!!!!!!!!!!!!!failed');
        end
    end
end
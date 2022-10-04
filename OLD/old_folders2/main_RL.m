addpath(genpath('./Code_MATLAB'));
%% load data
data = readtable('ratEE.csv');
%% preprocess
data = RatEE_preprocess(data);
%%
nFrees = unique(data.nFree);
nFrees = nFrees(arrayfun(@(x)sum(data.nFree == x), nFrees) > 100);
data = data(ismember(data.nFree, nFrees) & data.cond_alternatehomebase == 1 & data.cond_3light == 0,:);
%% select condition
cc = (data.isguided.*data.choice)';
cc(cc ==  0) = NaN;
idx = cellfun(@(x)length(x)  ==  1, nan_unique_col(cc));
data = data(idx,:);
data = table_squeeze(data);
%% basic analysis
idxsub = selectsubject(data, {'rat','nFree','nGuided'});
nidxsub = cellfun(@(x)length(x), idxsub);
idxsub = idxsub(nidxsub > 20);
sub = ANALYSIS_sub(data, idxsub, 'basic', 'basic', 'RatEE_analysis');
sub = table_squeeze(sub);
%% group
clear gp
gp1 = ANALYSIS_group(sub(sub.cond_horizon == 1  &  sub.nGuided ==3,:));
gp2 = ANALYSIS_group(sub(sub.cond_horizon == 6 &  sub.nGuided ==3,:));
gp3 = ANALYSIS_group(sub(sub.cond_horizon == 20 &  sub.nGuided ==3,:));
gp = table_vertcat(gp1, gp2, gp3);
%%
data = data(ismember(data.nFree,[1 6 20]) & data.nGuided == 3,:);
%%
data = data(~strcmp(data.rat, 'Gerald'),:);
%% get previous game result
for gi = 1:height(data)
    if gi-2>=1 && data.date_start(gi) == data.date_start(gi-2) && ...
            data.time_start(gi) == data.time_start(gi-2) && ...
            strcmp(data.rat{gi}, data.rat{gi-2}) && ...
            all(data.feeders(gi,:) == data.feeders(gi-2,:))
        data.dR_pre(gi) = diff(data.drop(gi-2,:));
    else
        data.dR_pre(gi) = 0;
    end
end
%%
bayesdata = [];
rats = unique(data.rat);
bayesdata.nHorizon = 3;
bayesdata.nSubject = length(rats);
nT = cellfun(@(x)sum(strcmp(data.rat,x)), rats);
LEN = max(nT);
% bayesdata.nForcedTrial = 3;
for si = 1:bayesdata.nSubject
    gd = data(strcmp(data.rat,rats{si}),:);
    nT = min(size(gd,1), LEN);
    bayesdata.nTrial(si,1) = nT;
    bayesdata.side(si,:) = nan_extend(sign(gd.c_side(:,1) - 1.5)', LEN);
    bayesdata.dRpre(si,:) = nan_extend(sign(gd.c_side(:,1) - 1.5)'.*gd.dR_pre', LEN);
    bayesdata.horizon(si,:) = nan_extend(round(gd.nFree/10)'+1, LEN); % 1 is short, 2 is long
    bayesdata.choice(si,:) = nan_extend((gd.c_side(:,4)' == gd.c_side(:,3)') , LEN); % 1 is right, 0 is left
    bayesdata.dR(si,:) = nan_extend(gd.reward(:,1)',LEN);
end
save('bayesdata', 'bayesdata');
%%
global poolobj;
poolobj = gcp('nocreate'); % If no pool, do not create new one.
if isempty(poolobj)
    poolsize = 0;
else
    poolsize = poolobj.NumWorkers;
end
if poolsize == 0
    parpool;
end
%%
bayes_params.nchains = 4; % How Many Chains?
bayes_params.nburnin = 1000; % How Many Burn-in Samples?
bayes_params.nsamples = 2000; % How Many Recorded Samples?
%%
params = {'NoiseRan_k_p', 'NoiseRan_lambda_p','NoiseRan', ...
    'bias_mu_n','bias_sigma_p', ...
    'apre_mu_n','apre_sigma_p', ...
    'aside_mu_n','aside_sigma_p',...
    'NoiseRan_sub','bias_sub',...
    'apre_sub','aside_sub',...
        'p'};

%     'dbias','dNoiseRan','dNoiseRan_sub',...

% params = {'NoiseRan_k_p', 'NoiseRan_lambda_p','NoiseRan', ...
%     'bias_mu_n','bias_sigma_p', ...
%     'apre_mu_n','apre_sigma_p', ...
%     'aside_mu_n','aside_sigma_p',...
%     'p'};
%    'dInfoBonus', 'InfoBonus_mu_n','InfoBonus_sigma_p','Infobonus_sub',...
nchains = 4;
clear init0;
for i=1:nchains
    S = [];
    for j = 1:length(params)
        str = params{j};
        if ~isempty(strfind(str,'_p'))
            S.(str) = ones([1 1]);
        elseif ~isempty(strfind(str,'_n'))
            S.(str) = zeros([1 1]);
        end
    end
    init0(i) = S;
end
%%
% load('temp.mat');
doparallel = 0; % use parallelization
fprintf( 'Running JAGS...\n' );
tic
[samples, stats, structArray] = matjags( ...
    bayesdata, ...                     % Observed data
    '/Volumes/Wang/TemporaryFiles/modelZZB.txt', ...    % File that contains model definition
    init0, ...                          % Initial values for latent variables
    'doparallel' , doparallel, ...      % Parallelization flag
    'nchains', bayes_params.nchains,...              % Number of MCMC chains
    'nburnin', bayes_params.nburnin,...              % Number of burnin steps
    'nsamples', bayes_params.nsamples, ...           % Number of samples to extract
    'thin', 1, ...                      % Thinning parameter
    'monitorparams', params, ...     % List of latent variables to monitor
    'savejagsoutput' , 0 , ...          % Save command line output produced by JAGS?
    'verbosity' ,1 , ...               % 0=do not produce any output; 1=minimal text output; 2=maximum text output
    'cleanup' , 1 );                    % clean up of temporary files?
tictoc = toc
%%
plt_initialize('fig_dir', './figs', 'fig_projectname', 'RatEE','fig_suffix','bayesian');
%%
plt_figure(2,2);
plt_setfig('new','xlabel',{'threshold','noise','\alpha_{pre}','\alpha_{side}'},'ylabel',{'Posterior','','Posterior',''});
plt_new;
plt_setfig_ax('legend',{'1','6','20'},'color',{'AZred','AZblue','AZsand'}, ...
    'ylim', [0 5], 'ytick', [], 'xlim', [0 4],'xtick', 0:1:4);
plt_hold('on');
stepsize = 0.02;
xbins = [-30:stepsize:30];
for hi = 1:3
    plt_new;
    td = samples.bias_mu_n;
    td = squeeze(td(:,:,hi));
    td = reshape(td, 1, []);
    tl = hist(td, xbins)/(length(td)*stepsize);
    plt_lineplot(tl, [],xbins);
end
plt_hold('off');

plt_new;
plt_setfig_ax('legend',{'1','6','20'},'color',{'AZred','AZblue','AZsand'}, ...
    'ylim', [0 15], 'ytick', [], 'xlim', [0 2]);
plt_hold('on');
stepsize = 0.02;
xbins = [0:stepsize:50];
for hi = 1:3
    plt_new;
    td = samples.NoiseRan;
    td = squeeze(td(:,:,hi));
    td = reshape(td, 1, []);
    tl = hist(td, xbins)/(length(td)*stepsize);
    plt_lineplot(tl, [],xbins);
end
plt_hold('off');

plt_new;
plt_setfig_ax('legend',{'1','6','20'},'color',{'AZred','AZblue','AZsand'}, ...
    'ylim', [0 15], 'ytick', [], 'xlim', [-1 1]);
plt_hold('on');
stepsize = 0.02;
xbins = [-50:stepsize:50];
for hi = 1:3
    plt_new;
    td = samples.apre_mu_n;
    td = squeeze(td(:,:,hi));
    td = reshape(td, 1, []);
    tl = hist(td, xbins)/(length(td)*stepsize);
    plt_lineplot(tl, [],xbins);
end

plt_hold('off');

plt_new;
plt_setfig_ax('legend',{'1','6','20'},'color',{'AZred','AZblue','AZsand'}, ...
    'ylim', [0 15], 'ytick', [], 'xlim', [-2 0]);
plt_hold('on');
stepsize = 0.02;
xbins = [-50:stepsize:50];
for hi = 1:3
    plt_new;
    td = samples.aside_mu_n;
    td = squeeze(td(:,:,hi));
    td = reshape(td, 1, []);
    tl = hist(td, xbins)/(length(td)*stepsize);
    plt_lineplot(tl, [],xbins);
end
plt_update;
% plt_save('hyperposterior');
plt_save('posterior');

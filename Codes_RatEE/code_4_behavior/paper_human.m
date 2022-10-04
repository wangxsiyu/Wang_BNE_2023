fns = {'../../data_processed/versions_cleaned/final_human.csv','../../data_processed/versions_cleaned/final_human_full.csv'};
ots = {'../../data_processed/output/gp_human.mat','../../data_processed/output/gp_human_full.mat'};
for fi = 1:length(fns)
    fn = fns{fi};
    data = W.readtable(fn);
    %% preprocess
    sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'n_guided'});
    data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
    %% exclude sessions based accuracy
    tac = W_sub.analysis_group(data, {'rat', 'foldername'});
    % %% session plot
    % tses = W_sub.selectsubject(tac, {'rat', 'foldername'});
    % tac_ses =  W_sub.tab_trial2game(tac, tses);
    % %%
    % tac = tac(tac.av_n_free > 1,:);
    data = data(contains(data.filename, tac.filename(nanmean(tac.av_cc_best,2) > 0.6)),:);
    %% basic analysis
    sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon'});
    tsub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
    sub = W.tab_squeeze(tsub);
    %% group
    gp = W_sub.analysis_group(sub, {'cond_horizon','n_guided'});
    % sort
    [~, od] = sort(gp.av_cond_horizon, 'descend');
    gp = gp(od,:);
    %%
    save(ots{fi}, 'sub','gp');
    %% get bayes
    bayesname = replace(fn, 'final', 'bayes');
    bayesname = replace(bayesname, '.csv', '');
    bayesname = replace(bayesname, 'versions_cleaned', 'bayesdata');
    get_bayesdata(data, bayesname);
end



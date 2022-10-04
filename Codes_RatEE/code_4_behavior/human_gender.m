fn = '../../data_processed/versions_cleaned/final_human.csv';
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
%     data = data(contains(data.filename, tac.filename(nanmean(tac.av_cc_best,2) > 0.6)),:);
    %% basic analysis
    sessions = W_sub.selectsubject(data, {'rat', 'n_guided','cond_horizon','demo_gender'});
    tsub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
    sub = W.tab_squeeze(tsub);
    %% stat
    cc =sub.av_cc_explore(:,1);
    gd = sub.demo_gender;
    hh = sub.cond_horizon;
    sid = sub.filename;
    anovan(cc, {hh, gd, sid}, 'continuous', 1,'nested',[0 0 0;0 0 0;0 1 0],'random',3)
    %% group
    gp = W_sub.analysis_group(sub, {'cond_horizon','n_guided','demo_gender'});
    % sort
    [~, od] = sort(gp.av_cond_horizon, 'descend');
    gp = gp(od,:);
    %%
    plt.figure;
    plt.new;
    plt.setfig_ax('color', col_human(end:-1:1),'xlabel', 'horizon', 'ylabel', 'p(explore)', 'xtick',1:4, 'xticklabel', [1 2 5 10],...
    'xlim', [],'ylim',[0 1]);
    
    id1 = gp.demo_gender == "female";
    id2 = gp.demo_gender == "male";
    tav = [gp(id1,:).av_av_cc_explore(end:-1:1,1)';gp(id2,:).av_av_cc_explore(end:-1:1,1)'];
    tse = [gp(id1,:).ste_av_cc_explore(end:-1:1,1)';gp(id2,:).ste_av_cc_explore(end:-1:1,1)'];
    plt.lineplot(tav,tse);
    plt.update;





datadir = '../../data_processed/versions_cleaned';
files = W.dir(datadir);
nfile = length(files);
%% process each 
sub = {};
gp = {};
if ~exist('../../data_processed/bayesdata')
    mkdir('../../data_processed/bayesdata');
end
for fi = 1:nfile
    fn = fullfile(files(fi).folder, files(fi).name);
    disp(sprintf("load - %s", files(fi).name));
    data = W.readtable(fn);
    % preprocess
    sessions = W_sub.selectsubject(data, {'rat', 'n_free', 'n_guided'});
    data = W_sub.preprocess_subxgame(data, sessions, 'preprocess_RatEE');
    % basic analysis
    sessions = W_sub.selectsubject(data, {'rat', 'cond_horizon', 'n_guided'});
    tsub = W_sub.analysis_sub(data, sessions, 'behavior_RatEE');
    sub{fi} = W.tab_squeeze(tsub);
    % group
    tgp = W_sub.analysis_group(tsub, {'n_guided','cond_horizon'});
    % sort
    [~, od] = sort(tgp.av_n_free, 'descend');
    gp{fi} = tgp(od,:);
    % get bayes
    bayesname = replace(files(fi).name, 'final', 'bayes');
    bayesname = replace(bayesname, '.csv', '');
    get_bayesdata(data, fullfile('../../data_processed/bayesdata', bayesname));
end
%% figure
plt = W_plt('fig_dir', '../../figures','fig_projectname', 'RatEE');
plt.setuserparam('param_setting', 'isshow', 0);
%% color/legend
cols = {'AZblue', 'AZsky','AZred','AZcactus'};
t50s = {'','50'};
for fi = 1:nfile
    sfx = replace(W.file_deext(files(fi).name),'final_', '');
    plt.setuserparam('param_setting', 'fig_suffix', strcat('_', sfx));
    tgp = gp{fi};
    horizons = tgp.av_cond_horizon;
    xlm = [0, max(horizons)] + 0.5;
    leg = arrayfun(@(x)sprintf('h = %.0f', x), horizons, 'UniformOutput',false);
    leg2 = {};
    leg2(:,1) = arrayfun(@(x)sprintf('h = %.0f, bad', x), horizons, 'UniformOutput',false);
    leg2(:,2) = arrayfun(@(x)sprintf('h = %.0f, good', x), horizons, 'UniformOutput',false);
    leg2 = reshape(leg2',1,[]);
    th = horizons;
    th(horizons >= 10) = 4;
    th(horizons >= 5 & horizons <=6) = 3;
    t50 = W.arrayfun(@(x)t50s(x), W.horz(1+ tgp.av_is_free1stchoice));
    col = W.arrayfun(@(x) cols(x), W.horz(th));
    col = strcat(col, t50);
    col2 = {};
    col2(:,1) = col;
    col2(:,2) = strcat(col, '50');
    col2 = reshape(col2', 1,[]);
    col2 = replace(col2, '5050', '25');
    %% by trial number
    plt.setfig_new;
    plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0.5 1], [0 1]} , ...
        'ytick', {0.5:0.1:1, 0:0.2:1}, 'legloc', {'SouthEast', 'NorthEast'});
    plt = fig_behavior_gp(plt, tgp, 'av', 'trial number', col, ...
        leg, ['gp_av']);
    %% split by good/bad
    plt.setfig_loc(2,'xlim', xlm, 'ylim', {[0.4 1], [0 1]},'legloc', {'NorthWest', 'NorthEast'});
    plt = fig_behavior_gp(plt, tgp, 'gp_av', 'trial number', col2, ...
        leg2, ['gp_acG']);
    %% R curve
    plt.setfig_new;
    plt.setfig_loc(2,'xlim', [0.5 6.5], 'xtick', 1:6, 'xticklabel', 0:5, ...
        'ylim', {[0 1],[0 1]}, 'ytick', {0:0.2:1, 0:0.2:1}, 'legloc', 'SouthWest');
    plt = fig_behavior_gp(plt, tgp, 'bin_all', 'R guided', col , ...
        leg, ['gp_rG']);
end

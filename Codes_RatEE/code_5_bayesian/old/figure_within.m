bayesdir0 = '../../result_bayes/*';
[~,files] = W.dir(bayesdir0);
files = files(~contains(files.folder_name, 'test'),:);
file_sts = files(contains(files.folder_name, 'stat'),:);
file_sps = files(contains(files.folder_name, 'samples'),:);
%%
%% load samples
fi = 4;
tfile = fullfile(file_sps.folder_path(fi), file_sps.folder_name(fi));
sp = importdata(tfile);
%%
%%
%%
plt.figure(4,2);
rgr = {[0 7], [0 20],[0 7], [0 20],[0 7], [0 20],[0 7], [0 20]};
rgr2 = -1:.01:21;
plt.setfig('color', {'AZblue','AZsky', 'AZred','AZcactus'}, ...
    'legend',{'H = 1','H = 2','H = 3', 'H = 4'}, 'xlim', rgr);
for i = 1:4
plt.new;
[ty, tm] = W_plt_JAGS.density(reshape(sp.tthres, [4 5000 4 8]), rgr2)
plt.lineplot(ty{i} ,[],tm);
plt.new;
[ty, tm] = W_plt_JAGS.density(reshape(sp.tnoise, [4 5000 4 8]), rgr2)
plt.lineplot(ty{i},[],tm);
end
plt.update;
%%
plt.figure(2,3);
rgr = {[0 7], [0 20],[0 1],[0 7], [0 20],[0 1]};
rgr2 = -1:.01:21;
plt.setfig('color', {'AZblue','AZsky', 'AZred','AZcactus'}, ...
    'legend',{'H = 1','H = 6'}, 'xlim', rgr);
for i = 1:2
plt.new;
[ty, tm] = W_plt_JAGS.density(sp.thres_mu, rgr2)
plt.lineplot(ty{i} ,[],tm);
plt.new;
[ty, tm] = W_plt_JAGS.density(sp.noise, rgr2)
plt.lineplot(ty{i},[],tm);
plt.new;
% [ty, tm] = W_plt_JAGS.density(sp.u, rgr2)
% plt.lineplot(ty{i},[],tm);
end
%     [ty, tm] = W_plt_JAGS.density(sp.u, -1:0.01:2)
%     plt.lineplot(ty,[],tm);
plt.update;
    %%
    plt.figure(3,2);
    rgr = [0 5];
    plt.setfig('color', repmat({'AZblue','AZsky', 'AZred','AZcactus'},1,6), ...
        'legend', repmat({{'H = 1','H = 6'}},1,6), 'xlim', rgr);
    [ty, tm] = W_plt_JAGS.density(sp.tnoise, rgr2)

    for j = 1:size(ty,2)
        plt.new;
        a = vertcat(ty{:,j});
        plt.lineplot(a ,[],tm);
    end
    plt.update;
%% subject-level
for fi = 1:size(file_sts,1)
    tfile = fullfile(file_sts.folder_path(fi), file_sts.folder_name(fi));
    st = importdata(tfile);
    st = st.stats;
    %%
    plt.figure(1,3);
    rgr = {[0 5], [0 5], [0 1]};
    rgr2 = -1:.01:6;
%     rgr = {[0 210], [0 210], [0 1]};
%     rgr2 = -1:0.2:211;
    plt.setfig('color', repmat({'AZblue','AZsky', 'AZred','AZcactus'},1,2), ...
        'legend', repmat({{'H = 1','H = 6'}},1,2), 'xlim', rgr);
    plt.new;
    [ty, tm] = W_plt_JAGS.density(sp.thres_mu, rgr2)
    plt.lineplot(ty ,[],tm);
    plt.new;
    [ty, tm] = W_plt_JAGS.density(sp.noise, rgr2)
    plt.lineplot(ty,[],tm);
    plt.new;
    [ty, tm] = W_plt_JAGS.density(sp.u, -1:0.01:2)
    plt.lineplot(ty,[],tm);
    plt.update;
end
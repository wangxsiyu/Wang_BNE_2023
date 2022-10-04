bayesdir0 = '../../result_bayes';
[~,files] = W.dir(bayesdir0);
files = files(~contains(files.folder_name, 'test'),:);
file_sts = files(contains(files.folder_name, 'stat'),:);
file_sps = files(contains(files.folder_name, 'samples'),:);
% file_sts = file_sts(~contains(file_sts.folder_name, 'lapse'),:);
% file_sps = file_sps(~contains(file_sps.folder_name, 'lapse'),:);
%%
plt = W_plt('fig_dir', '../../figures/bayes','fig_projectname', 'RatEE');
%%
for fi = 1:size(file_sps,1)
    tfile = fullfile(file_sps.folder_path(fi), file_sps.folder_name(fi));
    sp = importdata(tfile);
    %%
    plt.figure(1,3);
    rgr = {[-5 5], [-5 5], [0 1]};
    rgr2 = -6:.01:6;
%     rgr = {[0 210], [0 210], [0 1]};
%     rgr2 = -1:0.2:211;
    plt.setfig('color', repmat({'AZblue','AZsky', 'AZred','AZcactus'},1,2), ...
        'legend', repmat({{'H = 1','H = 6'}},1,2), 'xlim', rgr);
    plt.new;
    [ty, tm] = W_plt_JAGS.density(sp.dthres_mu, rgr2)
    plt.lineplot(ty ,[],tm);
    plt.new;
    [ty, tm] = W_plt_JAGS.density(sp.dnoise_mu, rgr2)
    plt.lineplot(ty,[],tm);
    plt.new;
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
end
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
% %% 01
% plt = W_plt;
% plt.figure(1,3, 'title','margin',[0.22,0.1,0.1,0.05]);
% plt.setfig('color', repmat({{'AZblue','AZred','AZblue50','AZred50'}},1,3), ...
%     'legend', repmat({{'H = 1, guided','H = 6, guided','H = 1, free','H = 6, free'}},1,3), ...
%     'title', {'threshold','noise','bias'}, 'ylabel', {'posterior','',''},...
%     'xlabel',{'\theta','\sigma','b_{spatial}'});
% [ty, tm] = W_plt_JAGS.density(sp.tthres, -2:.01:7);
% for i = 1:size(ty,2)
%     plt.ax(i, 1);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% [ty, tm] = W_plt_JAGS.density(sp.tnoise, 0:.01:20)
% for i = 1:size(ty,2)
%     plt.ax(i, 2);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% [ty, tm] = W_plt_JAGS.density(sp.tbias, -5:.01:20)
% for i = 1:size(ty,2)
%     plt.ax(i, 3);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.update;
% 

%%
% plt.new;
% [ty, tm] = W_plt_JAGS.density(sp.tbias, -1:.01:1)
%     plt.lineplot(ty,[],tm);
% %% sub
% plt = W_plt;
% plt.figure(1,3, 'title','margin',[0.22,0.1,0.1,0.05]);
% plt.setfig('color', repmat({{'AZblue','AZred','AZcactus'}},1,3), ...
%     'legend', repmat({{'H = 1','H = 6','H = 15'}},1,3), ...
%     'title', {'threshold','noise','bias'}, 'ylabel', {'posterior','',''},...
%     'xlabel',{'\theta','\sigma','b_{spatial}'});
% [ty, tm] = W_plt_JAGS.density(sp.tthres, 0:.01:5);
% for i = 1:size(ty,2)
%     plt.ax(i, 1);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% [ty, tm] = W_plt_JAGS.density(sp.tnoise, 0:.01:5)
% for i = 1:size(ty,2)
%     plt.ax(i, 2);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% [ty, tm] = W_plt_JAGS.density(sp.tbias, -3:.01:3)
% for i = 1:size(ty,2)
%     plt.ax(i, 3);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.update;
% %% random
% 
% plt = W_plt;
% plt.figure(1,3, 'title','margin',[0.22,0.1,0.1,0.05]);
% plt.setfig('color', repmat({{'AZred','AZsand'}},1,3), ...
%     'legend', repmat({{'fixed','random'}},1,3), ...
%     'title', {'threshold','noise','bias'}, 'ylabel', {'posterior','',''},...
%     'xlabel',{'\theta','\sigma','b_{spatial}'});
% [ty, tm] = W_plt_JAGS.density(sp.tthres, -50:.01:50);
% for i = 1:size(ty,2)
%     plt.ax(i, 1);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.setfig_ax('xlim', [0 5]);
% [ty, tm] = W_plt_JAGS.density(sp.tnoise, 0:.01:100)
% for i = 1:size(ty,2)
%     plt.ax(i, 2);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.setfig_ax('xlim', [0 5]);
% [ty, tm] = W_plt_JAGS.density(sp.tbias, -30:.01:30)
% for i = 1:size(ty,2)
%     plt.ax(i, 3);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.setfig_ax('xlim', [-2 2]);
% plt.update;
% %%
% 
% %% random
% 
% plt = W_plt;
% plt.figure(1,3, 'title','margin',[0.22,0.1,0.1,0.05]);
% plt.setfig('color', repmat({{'AZblue','AZred'}},1,3), ...
%     'legend', repmat({{'H = 1', 'H = 6'}},1,3), ...
%     'title', {'threshold','noise','bias'}, 'ylabel', {'posterior','',''},...
%     'xlabel',{'\theta','\sigma','b_{spatial}'});
% [ty, tm] = W_plt_JAGS.density(sp.tthres, -3:.01:5);
% for i = 1:size(ty,2)
%     plt.ax(i, 1);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.setfig_ax('xlim', [0 5]);
% [ty, tm] = W_plt_JAGS.density(sp.tnoise, 0:.01:10)
% for i = 1:size(ty,2)
%     plt.ax(i, 2);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.setfig_ax('xlim', [0 5]);
% [ty, tm] = W_plt_JAGS.density(sp.tbias, -3:.01:3)
% for i = 1:size(ty,2)
%     plt.ax(i, 3);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.setfig_ax('xlim', [-2 2]);
% plt.update;
% %%
% 
% %% human
% plt = W_plt;
% plt.figure(1,3, 'title','margin',[0.22,0.1,0.1,0.05]);
% plt.setfig('color', repmat({{'AZblue','AZsky','AZred','AZcactus'}},1,3), ...
%     'legend', repmat({{'H = 1', 'H = 2','H = 5','H = 9'}},1,3), ...
%     'title', {'threshold','noise','bias'}, 'ylabel', {'posterior','',''},...
%     'xlabel',{'\theta','\sigma','b_{spatial}'});
% [ty, tm] = W_plt_JAGS.density(sp.tthres, -3:.01:5);
% for i = 1:size(ty,2)
%     plt.ax(i, 1);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.setfig_ax('xlim', [1 5]);
% [ty, tm] = W_plt_JAGS.density(sp.tnoise, 0:.01:10)
% for i = 1:size(ty,2)
%     plt.ax(i, 2);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.setfig_ax('xlim', [0 2]);
% [ty, tm] = W_plt_JAGS.density(sp.tbias, -3:.01:3)
% for i = 1:size(ty,2)
%     plt.ax(i, 3);
%     te = ty(:, i);
%     te = vertcat(te{:});
%     plt.lineplot(te,[],tm);
% end
% plt.setfig_ax('xlim', [-4 4]);
% plt.update;
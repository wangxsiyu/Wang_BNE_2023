datadir = '../../data_processed/bayesdata';
[~,datalists] = W.dir(fullfile(datadir, '*.mat'));
%% 
d = fullfile(datalists.folder_path(1), datalists.folder_name(6));
d = importdata(d);
paramtruth = {};
%%
for repi = 1:50
    %% load data
    bayesdata = simulateMD(d);
    paramtruth{repi} = bayesdata.paramtruth;
    %% MLE-fit
    % thres noise alg als bias
    X0 = [2.5 1 0.5 0.5 0];
    LB = [0 0 0 0 -5];
    UB = [5 20 1 1 5];
    %%
    out = fmincon(@(x)fitMLE(bayesdata.bayesdata, x(1),x(2),x(3),x(4),x(5)), X0, [],[],[],[],LB, UB);
    xfit(repi,:) = out;
end
%% compare
x = [];
y = [];
z = [];
vars = {'thres','noise','lr_last','lr_lastgs','bias'};
for i = 1:length(paramtruth)
    y(i,:) = xfit(i,:);
    x(i,:) = cellfun(@(x)x, paramtruth{i});
end
%%
plt = W_plt('fig_dir', '../../figures','fig_projectname', 'param','fig_saveformat','emf');
plt.setuserparam('param_setting', 'isshow', 1);
plt.figure(2,3,'istitle','matrix_hole',[1 1 1;1 1 0], ...
    'gap',[0.2 0.1]);
tlts = {'threshold','noise','\alpha_{LG}','\alpha_{LS}','bias'};
plt.setfig('title',tlts);
for i = 1:5
    plt.new;
    str = plt.scatter(x(:,i), y(:,i),'diag');
    plt.setfig_ax('legend',str,...
        'xlabel',sprintf('simulated %s', ''),...
        'ylabel',sprintf('recovered %s', ''));
end
plt.update;
plt.save('param_recoverMLE')
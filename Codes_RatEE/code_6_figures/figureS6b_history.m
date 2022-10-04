function figureS6b_history(plt, sp, st)
plt.figure(1,2)
ratio = 1;
plt.new;
tall = [];
tall2 = [];
tav = [];
tav2 = [];
for i = 1:3
    [tav([2*i-1 2*i]),tse([2*i-1 2*i])] = W.avse(squeeze(st.stats.mean.tlrlast(i,:,:))');
    [tav2([2*i-1 2*i]),tse2([2*i-1 2*i])] = W.avse(squeeze(st.stats.mean.tlrlastgs(i,:,:))');
    ttee = [reshape(squeeze(st.stats.mean.tlrlast(i,:,:))',[],1),[ones(4,1);zeros(4,1)], ones(8,1)*i, [1:4,1:4]'];
    tall = vertcat(tall, ttee);
    ttee2 = [reshape(squeeze(st.stats.mean.tlrlastgs(i,:,:))',[],1),[ones(4,1);zeros(4,1)], ones(8,1)*i, [1:4,1:4]'];
    tall2 = vertcat(tall2, ttee2);
end
anovan(tall(:,1), tall(:,2:4), 'random', 3)
anovan(tall2(:,1), tall2(:,2:4), 'random', 3)
x = [1 2 4 5 7 8];
plt.setfig('xlabel','nGuided','ylabel',{'\alpha_{LG}','\alpha_{LS}'},...
    'color',{'AZblue','AZred','AZblue','AZred','AZblue','AZred'}, ...
    'xtick',[1.5 4.5 7.5],'xticklabel', [0 1 3],'ylim', [0 1]);
plt.barplot(tav, tse, x);
plt.new;
plt.barplot(tav2*ratio, tse2*ratio, x);
plt.update;
plt.save('pastgame')
% %%
% file = fullfile(hbidir, 'HBI_model_simple_between_all_stat.mat');
% st1 = importdata(file);
% file = fullfile(hbidir, 'HBI_model_simple_human_stat.mat');
% st2 = importdata(file);
end
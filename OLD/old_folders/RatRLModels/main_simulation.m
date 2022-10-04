file = '/Volumes/WANG/Lab_Fellous/Data/Data_Imported/ratEE.csv';
data = readtable(file, 'Delimiter', ',');
data = table_autofieldcombine(data);
data = data(~any(isnan(data.r_side)')',:);
rat = 'Hachi';
d =  data(strcmp(data.rat, rat) & data.nFree == 6,:);
ng = size(d,1);
fd = arrayfun(@(x)vertcat(nan_extend(repmat(d(x,:).fd(1), 3,1),2), ...
    repmat(d(x,:).feederID, 6,1)), 1:ng, 'UniformOutput', false);
fd =  vertcat(fd{:});
rs = arrayfun(@(x)vertcat(nan_extend(repmat(d(x,:).r(1), 3,1),2), ...
    repmat(d(x,:).r_side, 6,1)), 1:ng, 'UniformOutput', false);
rs =  vertcat(rs{:});
plt_initialize('new','fig_dir', './Figs');
%%
as = [0.01, 0.1, 0.5];
for j = 1:length(as)
    gpR{j} = models(fd, rs, as(j), 'A',  d);
end
plt_setfig('legend', {'0.01','0.1','0.5','guided'}, 'legloc', 'SouthWest');
figure_model(gpR);
plt_save('modelA');
%%
as = [0.01, 0.1, 0.5];
for j = 1:length(as)
    gpR{j} = models(fd, rs, as(j), 'B',  d);
end
plt_setfig('legend', {'0.01','0.1','0.5','guided'}, 'legloc', 'SouthWest');
figure_model(gpR);
plt_save('modelB');
%%
as = [0.5 0.1;
    0.5 1;
    0.5 3];
for j = 1:size(as,1)
    gpR{j} = models(fd, rs, as(j,:), 'C',  d);
end
plt_setfig('legend', {'0.1','1','3','guided'}, 'legloc', 'SouthWest');
figure_model(gpR);
plt_save('modelC');

%%
as = [0.5 1;
    0.5 5;
    0.5 10];
for j = 1:size(as,1)
    gpR{j} = models(fd, rs, as(j,:), 'D',  d);
end
plt_setfig('legend', {'1','5','10','guided'}, 'legloc', 'SouthWest');
figure_model(gpR);
plt_save('modelD');
%%
as = [0.5 1;
    0.5 5;
    0.5 10];
for j = 1:size(as,1)
    gpR{j} = models(fd, rs, as(j,:), 'E',  d);
end
plt_setfig('legend', {'.01','.1','.5','guided'}, 'legloc', 'SouthWest');
figure_model(gpR);
plt_save('modelE');


function [gp, gpR, sub, subR] = Rat_default(data)
    data.r_best = max(data.r_side')';
    data.nvisit = sum(~isnan(data.r)')';
    data.iscomplete = data.nvisit == data.nGuided +  data.nFree;
    data =  data(data.iscomplete,:);
    data.c_ac = (data.r == data.r_best) + 0 * data.r;
    data.r_guided = arrayfun(@(x)mean(data.r(x, 1:data.nGuided(x))), 1:size(data,1))';
    data.side_guided = arrayfun(@(x)mean(data.fd_side(x, 1:data.nGuided(x))), 1:size(data,1))';
    data.c_explore = (data.side_guided ~= data.fd_side) + data.fd_side * 0;
    data.c_repeat = [NaN(size(data,1),1),data.c_ac(:,2:end) == data.c_ac(:,1:end-1)] +  data.c_ac * 0;
    data.rpairID = sort(data.r_side')' * [10  1]';
    option_sub = {'rat', 'date', 'time'};
    idxsub = selectsubject(data, option_sub);
    sub = ANALYSIS_sub(data, idxsub, 'basic', {'basic'}, 'Rat_basic');
    option_subR = {'rat', 'date', 'time', 'r_guided'};
    idxsubR = selectsubject(data, option_subR);
    subR = ANALYSIS_sub(data, idxsubR, 'basic', {'basic'}, 'Rat_basic');
    
    gp = table;
    idxrat = selectsubject(sub, {'rat','nFree'});
    for i = 1:length(idxrat)
        gp(i,:) = ANALYSIS_group(sub(idxrat{i},:));
    end
    %
    gpR = table;
    idxrat = selectsubject(subR, {'rat','nFree','r_guided'});
    for i = 1:length(idxrat)
        gpR(i,:) = ANALYSIS_group(subR(idxrat{i},:));
    end
end
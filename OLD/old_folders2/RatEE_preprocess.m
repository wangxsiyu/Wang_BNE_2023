function data = RatEE_preprocess(data)
    data = table_autofieldcombine(data);
    for i = 1:height(data)
        if all(data.feeders(i,1:2) == [8 2]) || all(data.feeders(i,1:2) == [4 6])
            idx = [1 2];
        else
            idx = [2,1];
        end
        data.feeders(i,1:2) = data.feeders(i, idx);
        data.drop(i,1:2) = data.drop(i, idx);
    end
    data.c_side = abs(sign(data.choice - data.feeders(:,1))) + 1;
%     te = arrayfun(@(x)arrayfun(@(y)nan_select(data.drop(x,:), y), data.c_side(x,:)), 1:size(data,1), 'UniformOutput', false);
    for x = 1:height(data)
%         disp(x)
        for y = 1:length(data.c_side(x,:))
            if isnan(data.c_side(x,y))
                te(x,y) = NaN;
            else
                te(x,y) = data.drop(x,data.c_side(x,y));
            end
        end
    end
    
    data.reward = te;
    data.r_best = max(data.drop')';
    data.c_ac = (data.reward == data.r_best) + 0 * data.reward;
    data.c_rp = [NaN(size(data,1),1) (data.c_side(:,2:end) == data.c_side(:,1:end-1))] + 0 * data.c_side;
    data.dR = data.drop(:,2) - data.drop(:,1);
    data.nGuided = nansum(data.isguided')';
    data.nFree = nansum(data.isguided' == 0)';
    data = data(data.nFree ~= 0, :);
%     data.r_guided = arrayfun(@(x)mean(data.r(x, 1:data.nGuided(x))), 1:size(data,1))';
    %
    % data.side_guided = arrayfun(@(x)mean(data.fd_side(x, 1:data.nGuided(x))), 1:size(data,1))';
    % data.c_explore = (data.side_guided ~= data.fd_side) + data.fd_side * 0;
    % % data.c_repeat = [NaN(size(data,1),1),data.c_ac(:,2:end) == data.c_ac(:,1:end-1)] +  data.c_ac * 0;
    % data.rpairID = sort(data.r_side')' * [10  1]';
end
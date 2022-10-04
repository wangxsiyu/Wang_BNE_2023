function [feeders, rewards] = generate_horizon_v8(N, homebases, cond_horizon, steplevel, guidelevel, levels, folder)
    %   N - number of trials
    %   releasetime - a constant feeder release time
    %   manually set homebase...
    if ~exist('folder')
        folder = './';
    end
    rand('seed', sum(clock()));
    outputfile = strcat('taskset_horizonv8_', datestr(now,30));

    s0 = ceil(rand*2);
    for i = 1:N
        homebase(i) = homebases(s0);
        s0 = 3-s0;
    end

    for i = 1:N
        feeders(i,:) = findbandit(homebase(i));
        rewards(i,:) = getreward(levels);
    end
    str = 'file generation complete - task horizon v8';
    newd = fullfile(folder, [outputfile]);
    mkdir(newd);
    for i = 1:N
        fileID = fopen(fullfile(newd, ['GameNumber', num2str(i),'.txt']),'w');
        fprintf(fileID, '1\t1\t%d\n', steplevel);
        ris = [ones(floor(cond_horizon(1)/2),1); ones(floor(cond_horizon(1)/2),1)*2];
        ris = ris(randperm(length(ris)));
        for hi = 1:cond_horizon(1)
            fprintf(fileID,'%d\t%d\t1\t0\n', homebase(i), guidelevel);
            ri = ris(hi);
            fprintf(fileID,'%d\t%d\t1\t0\n', feeders(i,ri), guidelevel);
        end
        for hi = 1:cond_horizon(2)
            fprintf(fileID,'%d\t%d\t1\t0\n', homebase(i), guidelevel);
            fprintf(fileID,'%d%d\t%d%d\t1\t0\n', feeders(i,1), feeders(i,2), rewards(i,1), rewards(i,2));
        end
        fclose(fileID);
    end
    disp(str);
end
function y = findbandit(x)
    y(1) = x + 3;
    y(2) = x - 3;
    y = mod(y,8);
    y(y == 0) = 8;
    y = y(randperm(2));
end
function y = getreward(levels)
    tl = levels(randperm(length(levels)));
    y = tl(1:2);
end
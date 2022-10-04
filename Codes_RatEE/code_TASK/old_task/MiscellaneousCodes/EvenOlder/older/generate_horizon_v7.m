function [feeders, rewards] = generate_horizon_v7(N, homebases, cond_horizon, phomebase, steplevel, levels, folder)
    %   N - number of trials
    %   releasetime - a constant feeder release time
    %   manually set homebase...
    if ~exist('folder')
        folder = './';
    end
    rand('seed', sum(clock()));
    outputfile = strcat('taskset_horizonv7_h', num2str(cond_horizon(1)),'_',num2str(cond_horizon(2)), '_', datestr(now,30),'.txt');

    s0 = ceil(rand*2);
    for i = 1:N
        homebase(i) = homebases(s0);
        s0 = 3-s0;
    end

    for i = 1:N
        feeders(i,:) = findbandit(homebase(i));
        rewards(i,:) = getreward(levels);
    end
    str = 'file generation complete - task horizon v7 - tutorial probabilistic rewarded homebase';

    fileID = fopen(fullfile(folder, outputfile),'w');
    fprintf(fileID, '1\t1\t%d\n', steplevel);
    for i = 1:N
        ris = [ones(floor(cond_horizon(1)/2),1); ones(floor(cond_horizon(1)/2),1)*2];
        ris = ris(randperm(length(ris)));
        for hi = 1:cond_horizon(1)
            fprintf(fileID,'%d\t%d\t%.1f\t0\n', homebase(i), 1, phomebase);
            ri = ris(hi);
            fprintf(fileID,'%d\t%d\t1\t0\n', feeders(i,ri), rewards(i,ri));
        end
        for hi = 1:cond_horizon(2)
            fprintf(fileID,'%d\t%d\t%.1f\t0\n', homebase(i), 1, phomebase);
            fprintf(fileID,'%d%d\t%d%d\t1\t0\n', feeders(i,1), feeders(i,2), rewards(i,1), rewards(i,2));
        end
    end
    fclose(fileID);
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
function [feeders, rewards] = generate_horizon_v5(N, cond_horizon, steplevel, levels, folder)
%   N - number of trials
%   releasetime - a constant feeder release time
%   1 3 5 7 are always homebase, and 2 4 6 8 are always rewarded site
if ~exist('folder')
    folder = './';
end
rand('seed', sum(clock()));
outputfile = strcat('taskset_horizonv5_h', num2str(cond_horizon), '_', datestr(now,30),'.txt');

if size(N,1) == 1 && size(N,2) == 1
    homebase(1) = ceil(rand(1,1)*4) * 2 - 1;
    for i = 2:N
        homebase(i) = homebase(i-1);
        while homebase(i) == homebase(i-1)
            homebase(i) = ceil(rand(1,1)*4) * 2 - 1;
        end
    end
    
    for i = 1:N
        feeders(i,:) = findbandit(homebase(i));
        rewards(i,:) = getreward(levels);
    end
    str = 'file generation complete - task horizon v5 - tutorial rewarded homebase';
else
    homebase = N(:,1);
    feeders = N(:,2:3);
    rewards = N(:,4:5);
    N = size(N,1);
    str = 'file generation complete - task horizon v5b(hard code) - tutorial rewarded homebase';
end
fileID = fopen(fullfile(folder, outputfile),'w');
fprintf(fileID, '1\t1\t%d\n', steplevel);
for i = 1:N
    ris = [ones(floor(cond_horizon/2),1); ones(floor(cond_horizon/2),1)*2];
    ris = ris(randperm(length(ris)));
    for hi = 1:cond_horizon
        fprintf(fileID,'%d\t%d\t1\t0\n', homebase(i), 1);
        ri = ris(hi);
        fprintf(fileID,'%d\t%d\t1\t0\n', feeders(i,ri), rewards(i,ri));
    end
    for hi = 1:cond_horizon
        fprintf(fileID,'%d\t%d\t1\t0\n', homebase(i), 1);
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
function [feeders, rewards] = generate_horizon_v1(N, cond_horizon, Nrandom, feedertime, folder)
%   N - number of trials
%   releasetime - a constant feeder release time
if ~exist('folder')
    folder = './';
end
rand('seed', sum(clock()));
outputfile = strcat('taskset_horizonv1_h', num2str(cond_horizon), '_', datestr(now,30),'.txt');

homebase(1) = ceil(rand(1,1)*8);
for i = 2:N
    homebase(i) = homebase(i-1);
    while homebase(i) == homebase(i-1)
        homebase(i) = ceil(rand(1,1)*8);
    end
end

feederids = repmat(1:8, Nrandom);
feederids = feederids(randperm(length(feederids)));
while feederids(end) == homebase(1) || sum(diff(feederids) == 0) > 0
    feederids = repmat(1:8, Nrandom);
    feederids = feederids(randperm(length(feederids)));
end

for i = 1:N
    feeders(i,:) = findbandit(homebase(i));
    rewards(i,:) = getreward159;
end

fileID = fopen(fullfile(folder, outputfile),'w');
fprintf(fileID, '1\t1\t15\n');
for i = 1:length(feederids)
    fprintf(fileID,'%d\t%d\t1\t0\n', feederids(i), feedertime);
end
for i = 1:N
    for hi = 1:cond_horizon
        fprintf(fileID,'%d\t%d\t0\t0\n', homebase(i), 1);
        fprintf(fileID,'%d%d\t%d%d\t1\t0\n', feeders(i,1), feeders(i,2), rewards(i,1), rewards(i,2));
    end
end
fclose(fileID);
disp('file generation complete - task horizon v1');
end
function y = findbandit(x)
    y(1) = x + 3;
    y(2) = x - 3;
    y = mod(y,8);
    y(y == 0) = 8;
    y = y(randperm(2));
end
function y = getreward159()
    y = 1+4*(floor(rand(1,2)*3));
    while y(1) == y(2)
        y = 1+4*(floor(rand(1,2)*3));
    end
end
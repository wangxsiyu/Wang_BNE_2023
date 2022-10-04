function [feederids, feedertimes] = generate_random(N, releasetime, folder)
%   N - number of trials
%   releasetime - a constant feeder release time
rand('seed', sum(clock()));
if ~exist('folder')
    folder = './';
end
outputfile = strcat('taskset_random', num2str(releasetime),'_', datestr(now,30),'.txt');
feederids(1) = ceil(rand(1,1)*8);
for i = 2:N
    feederids(i) = feederids(i-1);
    while feederids(i) == feederids(i-1)
        feederids(i) = ceil(rand(1,1)*8);
    end
end
feedertimes = ones(N,1)*releasetime;
fileID = fopen(fullfile(folder, outputfile),'w');
fprintf(fileID, '1\t1\n');
for i = 1:N
    fprintf(fileID,'%d\t%d\t1\t0\n', feederids(i), feedertimes(i));
end
fclose(fileID);
disp('file generation complete - task random');
end
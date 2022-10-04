function [out]= Import_taskset(Filename, outputmode)
%	by sywangr at email.arizona.edu
if ~exist('outputmode')
    outputmode = 0;
end
if exist(Filename,'file')
    fp= fopen(Filename);
    hd= split(fgetl(fp));		% first line is header
    step_reward = str2num(hd{3});
    lines=textscan(fp,'%f %f %f %f');
    probability=lines{3};
    rewards=lines{2};
    feeders=lines{1};
    delaytime=lines{4};
    n_event = length(feeders);
    if outputmode>0
        fprintf('...: %d %d %d\n',hd{1}, hd{2}, hd{3});
        for i=1:n_event
            fprintf('%f %f %f %f\n',feeders(i), rewards(i), probability(i), delaytime(i))
        end
    end
    fprintf('...: %d non empty taskset events found\n', n_event)
    fclose(fp);    
    step_reward = repmat(step_reward, n_event, 1);
    out = table(feeders, rewards, probability, delaytime, step_reward);
else
    fprintf('***: ERROR. Taskset File %s not found\n',Filename)
    out = [];
end

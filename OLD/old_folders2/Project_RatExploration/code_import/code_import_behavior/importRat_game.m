function [out]= importRat_game(Filename)
    if ~exist(Filename,'file')
        fprintf('***: ERROR. Taskset File %s not found\n', Filename)
        out = [];
    end
    fp= fopen(Filename);
    hd= split(fgetl(fp));		% first line is header
    lines=textscan(fp,'%s %f %f %f %s');
    probability=lines{3};
    releasetime=lines{2};
    feeders=lines{1};
    delaytime=lines{4};
    drops = lines{5};
    fclose(fp);
    if strcmp(feeders{end}, 'cued')
        feeders = feeders(1:end-1);
    end
    [~,filename] = fileparts(Filename);
    filename = repmat(string(filename), size(feeders,1),1);
    if any(releasetime < 10 & releasetime > 0)
        drops = arrayfun(@(x)num2str(x), releasetime, 'UniformOutput', false);
        releasetime = arrayfun(@(x)str2num(hd{3}), releasetime);
    end
    out = table(filename, feeders, releasetime, probability, delaytime, drops);
end

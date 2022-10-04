function out = formatRat_trackerBehavior(raw, labelexclude, maze)
    if ~exist('labelexclude')
        labelexclude = '';
    end
    raw = raw(~contains(raw.events, labelexclude), :);
    if any(contains(raw.feeders,','))
        fds = cellfun(@(x) cellfun(@(y)W.iif(isempty(str2num(y)),NaN,str2num(y)), strsplit(x, ',')), raw.feeders, 'UniformOutput', false);
    else
        fds = cellfun(@(x)arrayfun(@(t)str2num(x(t)), find(W.funcout('W.str_select',2,x))'), raw.feeders, 'UniformOutput', false);
    end
    dt = unique(raw.date);
    tm = unique(raw.time);
    filename = string(unique(raw.filename));
    lb1 = find(strcmp(raw.events, 'BlinkStart')); % each trial starts with a blink
    lb2 = [lb1(2:end)-1; length(raw.events)]; % end label is whatever before the next BlinkStart
    nev = length(lb1); % number of events
    nlb = max(lb2-lb1+1);
    out = table(repmat(filename, nev, 1), repmat(dt, nev, 1), repmat(tm, nev, 1), (1:nev)', ...
        cell(nev,nlb),NaN(nev,nlb),repmat({''}, nev, nlb), ...
        'VariableNames', {'filename', 'date','time','trialID', ...
        'feeder_lists', 'timestamp_lists', 'label_lists', ...
        });
    for ni = 1:nev
        tidx = lb1(ni):lb2(ni);
        out.feeder_lists(ni, 1:length(tidx)) = fds(tidx);
        out.timestamp_lists(ni, 1:length(tidx)) = raw.eventtimes(tidx);
        out.label_lists(ni, 1:length(tidx)) = raw.events(tidx);
    end
    out.sound_lists = cellfun(@(x)x(~ismember(x, maze.number(maze.isfeeder))), out.feeder_lists,'UniformOutput', false);
    out.feeder_lists = cellfun(@(x)x(ismember(x, maze.number(maze.isfeeder))), out.feeder_lists,'UniformOutput', false);
end
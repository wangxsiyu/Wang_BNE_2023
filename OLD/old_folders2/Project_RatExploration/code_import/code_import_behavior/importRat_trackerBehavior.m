function [raw]= importRat_trackerBehavior(Filename)
    if ~exist(Filename,'file')
        fprintf('***: ERROR. Lick-and-Run File %s not found\n',Filename)
        raw = table;
        return;
    end
    fp=fopen(Filename);
    hd=fgetl(fp);		% first line is header
    hdparts = split(hd);
    filename = hdparts{7};
    initialtimestamp = hdparts{8};
    datetime = datestr([hdparts{2:4}, ' ' hdparts{5:6}], 30);
    date = str2num(datetime(1:8));
    time = str2num(datetime(10:15));
    lines=textscan(fp,'%s %s %f');
    eventtimes=lines{3};
    events=lines{2};
    feeders=lines{1};
    n_event = length(eventtimes);
    fclose(fp);    
    filename = repmat({filename}, n_event, 1);
    date = repmat(date, n_event, 1);
    time = repmat(time, n_event, 1);
    raw = table(date, time, filename, events, eventtimes, feeders);
end

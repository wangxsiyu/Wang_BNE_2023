function [out]= Import_LREvents(Filename, outputmode)
%	[out]= Import_LREvents(Filename, outputmode)
%
%	Wrapper function to read a Lick and Run event file
%		Filename: name of the event file (including path). 
%		outputmode: 0 (silent), 1(prints events and times on screen)
%
%		events: cell array of events (access with events{k})
%		eventtimes: time stamp array of the events (microsecs)
%		feeders: feeders at which the event occured
%
%
%		fellous at email.arizona.edu
%       adapted by sywangr at email.arizona.edu
if ~exist('outputmode')
    outputmode = 0;
end
eventtimes=[]; events=[]; feeders=[];
if exist(Filename,'file')
    fp=fopen(Filename);
    hd=fgetl(fp);		% first line is header
    fprintf('...: %s\n',hd);
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
    if outputmode>0
        for i=1:n_event
            fprintf('%d: %s at %s\n',eventtimes(i),char(events(i)),char(feeders(i)))
        end
    end
    fprintf('...: %d non empty Lick-and-run events found\n', length(eventtimes))
    fclose(fp);    
    filename = repmat({filename}, n_event, 1);
    date = repmat(date, n_event, 1);
    time = repmat(time, n_event, 1);
    out = table(date, time, filename, events, eventtimes, feeders);
else
    fprintf('***: ERROR. Lick-and-Run File %s not found\n',Filename)
    out = [];
end

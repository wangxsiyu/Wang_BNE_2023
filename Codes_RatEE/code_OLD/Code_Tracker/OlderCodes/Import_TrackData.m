function [trackdata] = Import_TrackData(filename)
    Win = 7;		% number of frames used to smooth the track data
    MinDuration = 200;
    trackdata=[];
    i=0;
    try
        if ~exist(filename,'file')
            disp(sprintf('red','ERROR: track file %s does not exist\n',TrackFile));
            return
        end
        fp = fopen(filename);
        content=textscan(fp,'%s','delimiter','\n');
        fclose(fp);
        content=content{1};
        header=content{1};
        tracks=zeros(length(content)-1,3);
        for i=1:length(content)-1
            tracks(i,:)=sscanf(content{i+1},'%f %f %f')';
        end
    catch me
        fprintf('ERROR: Line %d in %s \n %s \n',i,filename,me.message)
        return
    end
   
    ts = tracks(:,1);  % time
    if any(ts == 0)
        fprintf('.**: Warning: There are time stamps of 0s in the file\n');
    end
    tstart = ts(1);
    tend = ts(end);
    x = tracks(:,2);
    y = tracks(:,3);
    dts = diff(ts);
    frate=1000/mean(dts); % frame rate in Hz
    duration=(tend-tstart)/6e4;	% in minutes
    dists=sqrt(diff(x).^2+diff(y).^2);
    
    % dealing with jumps
    
    edges=0:0.1:100;
    counts = histc(dists, edges);
    counts(1) = 0;
    idx = find(counts>mean(counts)); % only include bigger bins (assume jumps are in smaller bins)
    maxjump = 10 * sum(counts(idx).*edges(idx)')/sum(counts(idx));		
    npoints = length(ts);
    
    jidx=find(dists>maxjump);
    
    if length(jidx)>1
        djidx=diff(jidx);
        ids=find(djidx>floor(3*frate));		% find the jumps that are at least 3 x frate away from eachother
        if ~isempty(ids)
            jumps=jidx(ids);
            lims=[jidx(1) jumps(1)];
            if length(jumps)>1
                for k=1:length(jumps)-1
                    a=find(jumps(k)==jidx);
                    lims=[lims; [jidx(a+1) jumps(k+1)]];
                end
                a=find(jumps(end)==jidx);
                lims=[lims; [jidx(a+1) jidx(end)]];
            end
        else
            lims=[min(jidx) max(jidx)];
        end
    else
        lims=[jidx jidx];
    end
    
    goodidx=[]; start=1;
    chunks={};
    if size(lims,1)>0
        for k=1:size(lims,1)
            duration=ts(lims(k,1))-ts(start);
            if duration > MinDuration													%at least MinDuration msec long
                goodidx=[goodidx ;[start lims(k,1)]];
                idx=start:lims(k,1);
                chunks{size(goodidx,1)}=[ts(idx) x(idx)  y(idx)];
            end
            start=lims(k,2)+1;
        end
        duration=ts(npoints)-ts(start);
        if duration >MinDuration															%at least MinDuration msec long
            goodidx=[goodidx ;[start npoints]];
            idx=start:npoints;
            chunks{size(goodidx,1)}=[ts(idx) x(idx)  y(idx)];
        end
    else
        chunks{1}=[ts x y];
    end
    
    trackdata={}; tk=1;
    rawtrackdata={}; rawtk=1;
    for k=1:length(chunks)
        a=chunks{k};
        ts2= a(:,1); x2=a(:,2); y2=a(:,3);
        dts2=diff(ts2);
        bdidx=find(dts2<=0);
        if length(bdidx)>=1 && gmode >=0
            fprintf('.**: WARNING. %d points have the same or decreasing time stamp in chunk %d... Linearizing in 10 steps\n', length(bdidx),k)
            tempts=[];lts2=length(ts2);fracts2=floor(lts2/10);
            for ii=1:10
                tempts=[tempts; linspace(ts2(1 + (ii-1)*fracts2),ts2(ii*fracts2),fracts2)'];
            end
            if length(tempts)<length(ts2)
                tempts=[tempts; linspace(ts2(1 + 10*fracts2),ts2(end),length(ts2)-length(tempts))'];
            end
            ts2=tempts;
        end
        resolution=2;						% makes it prettier
        win=Win*resolution;
        ts3=linspace(min(ts2),max(ts2),resolution*length(ts2));
        x3=interp1(ts2,x2,ts3,'linear'); % interpolate time to even steps
        y3=interp1(ts2,y2,ts3,'linear');

        if (win>0 && length(ts3)>3*win) % smoothing
            gauss_i = -win/2:win/2;
            b = gaussian(gauss_i, 0, win/4)/sum(gaussian(gauss_i, 0, win/4));
            
            x4 = filtfilt( b, 1, x3 );           % x position
            y4 = filtfilt( b, 1, y3 );           % y position
            ts4=ts3;
        else
            x4=x3; y4=y3; ts4=ts3;
        end
        
        rawtrackdata{rawtk}=[ts2'; x2'; y2']';%' returns the raw track data, with no filtering, no interpolation and no smooting
        rawtk=rawtk+1;
        trackdata{tk}=[ts4; x4; y4]';           %'
        tk=tk+1;        
    end
    
    trackdata  = vertcat(trackdata{:});
        
end
function [y] = gaussian(x, mean, std)
    if nargin == 1 
        mean = 0; 
        std = 1; 
    end
    y = exp( (-1/2)*((x-mean)./std).^2  );
end

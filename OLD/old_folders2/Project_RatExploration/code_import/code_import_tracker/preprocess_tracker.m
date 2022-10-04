function [trackdata, chunks] = preprocess_tracker(tracks, optionsIn)
    options.analysis_stuck = true;
    options.thres_stuck = 15; % (min) number of minutes during which absolutely no movement may be considered 'tracker stuck'
    options.analysis_skipclosepoint = true;
    options.thres_skipclosepoint = 2;
    options.minchunkduration = 1e4; % 10s
    options.outputstr = false;
    options.smoothingwindow = 7;
    options.resolution = 2;
    if exist('optionsIn')
        options = struct_merge(options, optionsIn);
    end
    ts = tracks(:,1); % timestamp
    xs = tracks(:,2);
    ys = tracks(:,3);
    
    dts = diff(ts);
    dists = sqrt(diff(xs).^2+diff(ys).^2);
    
    if any(dts < 0) % whether timestamp is in the ascending order
        cprintf('Red', 'timestamp not in ascending order\n');
    end
    
    frate = 1000/mean(dts);		% frame rate in Hz
    info.frate = frate;
    info.duration = (ts(end)-ts(1))/60000;	% in minutes
    % Stuck Tracker analysis
    if options.analysis_stuck
        [t0] = W.get_consecutive0(dists);
        stuck = find(t0.duration > options.thres_stuck * 60 * frate); % stuck if immobile for X consecutive minutes
        if ~isempty(stuck)
            info.stuckdurs = t0.duration(stuck)/frate/60;       %in minutes
            info.stucktimes = t0.start(stuck)/1000;       %in secs
            cprintf('Red','Warning: Tracker possibly stuck at %.2f sec for %.2f mins \n', [info.stucktimes,info.stuckdurs]')
        elseif options.outputstr
            info.stuckdurs = [];
            info.stucktimes = [];
            cprintf('Green','Report: No tracker stuck was found \n')
        end
    end
    
    % Downsample points that are closed to each other
    if options.analysis_skipclosepoint
        bidx = [1; dists > options.thres_skipclosepoint];
        bidx = W.get_consecutive0(bidx);
        bidx = arrayfun(@(x)bidx.start(x):2:bidx.end(x), 1:size(bidx,1), 'UniformOutput', false);
        bidx = horzcat(bidx{:})';
        idx = setdiff(1:length(xs), bidx);
        while length(bidx) > 10
            xs = xs(idx);
            ys = ys(idx);
            ts = ts(idx);
            dts = diff(ts);
            dists = sqrt(diff(xs).^2+diff(ys).^2);
            
            bidx = [1; dists > options.thres_skipclosepoint];
            bidx = W.get_consecutive0(bidx);
            bidx = arrayfun(@(x)bidx.start(x):2:bidx.end(x), 1:size(bidx,1), 'UniformOutput', false);
            bidx = horzcat(bidx{:})';
            idx = setdiff(1:length(xs), bidx);
        end
        textrate = length(xs)/size(tracks,1);
        if textrate < 0.20 % if more than 80% closepoint were erased... warn the user
            cprintf('Red', 'Warning: large amount of skipping of close points. Original track contained %d points. \n ...processing %.1f%% points after close-point cleanup.\n', length(xs),100*textrate);
        elseif options.outputstr
            cprintf('Green', 'Complete skipping of close points. Original track contained %d points. \n ...processing %.1f%% points after close-point cleanup.\n', length(xs),100*textrate);
        end
    end
    
    %fprintf('...: Found %d jumps in the data.\n',length(Jumps));

    if isempty(xs) 	% if there does not exist trackdata after cleanup
        cprintf('Red', 'Error : This time span does not contain meaningful trackdata\n')
        trackdata = {};
    else
        edges = linspace(0,max(dists),1000);
        counts = histc(dists, edges);
        idx = find(counts>mean(counts));
        maxjump = 10 * sum(counts(idx).*edges(idx)')/sum(counts(idx));	
        jidx = dists <= maxjump;
        jidx = W.get_consecutive0(jidx);
        tlims = W.join_intervals([jidx.start, jidx.end], floor(3*frate));
        lims = [[0; tlims(:,2)]+1, [tlims(:,1); length(ts)]];
        tdurations = ts(lims(:,2)) - ts(lims(:,1));
        lims = lims(tdurations > options.minchunkduration, :);
        if size(lims, 1) == 0
            cprintf('Red', 'Warning: No chunks are longer than minchuckduration, including the whole trace.\n')
            lims = [0 length(ts)];
        end
        chunks={};
        for k = 1:size(lims,1)
            idx = lims(k,1):lims(k,2);
            chunks{k} = [ts(idx) xs(idx)  ys(idx) repmat(k,length(idx),1)];
        end
        
        trackdata={}; 
        for k = 1:length(chunks)
            a = chunks{k};
            tt = a(:,1); tx = a(:,2); ty = a(:,3);
           
            dtt = diff(tt);
            if any(dtt <= 0)
                cprintf('Red', 'Warning: %d points have the same or decreasing time stamp in chunk %d... Needs more work\n', sum(dtt <= 0), k)
            end
            Win = options.smoothingwindow;
            resolution = options.resolution;						% makes it prettier
            win = Win*resolution;
            % interpolation of data...
            ttt = linspace(min(tt),max(tt),resolution*length(tt));
            ttx = interp1(tt,tx,ttt,'linear');
            tty = interp1(tt,ty,ttt,'linear');

            if (win>0 && length(tt)>3*win)
                % b = ones(1,win)/(win);  % this is a simple running average
                gauss_i = -win/2:win/2;
                b = gaussmf(gauss_i, [win/4, 0])/sum(gaussmf(gauss_i, [win/4, 0]));
                
                ttx = filtfilt( b, 1, ttx );           % x position
                tty = filtfilt( b, 1, tty );           % y position
            else
                cprintf('Red', 'Warning: Chunk %d (%d points, %.2f s) was not filtered\n', k,length(ttt),(ttt(end)-ttt(1))/1e3)
            end
            trackdata{k} = [ttt; ttx; tty; repmat(k,1,length(ttt))]';    
        end
        
        if options.outputstr
             cprintf('Green', '...: Found %d continuous sections. \n',length(chunks))
        end
    end
    chunks = vertcat(chunks{:});
    trackdata = vertcat(trackdata{:});
    
    info = struct2table(info);
    chunks = table(chunks);
    chunks = splitvars(chunks, 'chunks', 'NewVariableNames', {'time', 'x', 'y', 'chuckID'});
    chunks = W.tab_fill(chunks, info);
    trackdata = table(trackdata);
    trackdata = splitvars(trackdata, 'trackdata', 'NewVariableNames', {'time', 'x', 'y', 'chuckID'});
    trackdata = W.tab_fill(trackdata, info);
end
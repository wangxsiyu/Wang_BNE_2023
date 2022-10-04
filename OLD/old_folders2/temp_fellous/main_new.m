clear, clc;
ratname = 'Hachi';
maindir = fullfile('C:\Users\Siyu\Desktop\temp_fellous\', ratname);
datadir = fullfile(maindir, '081*');
files = dir(fullfile(datadir));
files = files(arrayfun(@(x)length(x.name)==6, files));
nfile = length(files);
for i_file = 1:nfile
    filedir = fullfile(files(i_file).folder, files(i_file).name);
    %% load Lick-and-Run file
    tfile = dir(fullfile(filedir, 'horizon*.txt'));
    nf = length(tfile);
    for fi = 1:nf
    filename = fullfile(tfile(fi).folder, tfile(fi).name);
    LREvents{fi} = Import_LREvents(filename);
    end
    %% load taskset file
    tfile = dir(fullfile(filedir, 'Game*.txt'));
    tfile = tfile(1:nf);
    for fi = 1:nf
    filename = fullfile(tfile(fi).folder, tfile(fi).name);
    taskset{fi} = Import_taskset(filename);
    end
    %% analyze LR file only
    for fi = 1:nf
        d1 = LREvents{fi};
        d2 = taskset{fi};
        idx_feed = strcmp(d1.events, {'Feed'}) |strcmp(d1.events, {'NoFeed'}) | strcmp(d1.events, {'NoFeedLowProb'});
        feeders_feed = cellfun(@(x)str2num(x), d1.feeders(idx_feed));
        feeders_feed(feeders_feed == 0) = NaN;
        i0 = find(isnan(feeders_feed))-1;
        i0 = i0(end);
        if i_file > 1
        i0 = min(i0(end),48);
        end
        feeders_feed = feeders_feed(1:(i0-1));
        d1 = d1(1:i0,:);
        idx_blinkstart = strcmp(d1.events, 'BlinkStart');
        feeders_blink = cellfun(@(x)str2num(x), d1.feeders(idx_blinkstart));
        n_tot = length(feeders_feed);
        nfc = sum(d2.feeders > 10);
        ngc = size(d2,1)/2 - nfc;
        cpair = unique(d2.feeders(d2.feeders > 10));
        cc = feeders_feed(2:2:length(feeders_feed));
        rpair = unique(d2.rewards(d2.rewards>10));
        choice = 2 - (cc == floor(cpair/10));
        cpairs = [floor(cpair/10), mod(cpair,10)]';
        binarychoice = double([choice == 1, choice == 2]);
        rmtx = [floor(rpair/10), mod(rpair,10)]';
        reward = binarychoice*rmtx;
        data{fi} = [choice, reward];
        [~,rk] = sort(rmtx, 'descend');
        fds{fi} = cpairs(rk);
    end
    %% subject level analysis
    %   this part needs more work... hardcoded some parameters
    binsize = 6;    
    sub{i_file,2}= ceil(ngc/binsize);
    sub{i_file,3} = fds;
    for fi = 1:nf
        td = data{fi};
        ntrial(fi) = ceil(size(td,1) /binsize);    
    end
    p_hm = NaN(nf, max(ntrial));
    for fi = 1:nf
        td = data{fi};
        for bini = 1:ntrial(fi)
            x0 = (bini-1)* binsize + 1;
            x1 = min(bini* binsize, size(td,1));
            tdata = td(x0: x1, :);
            p_hm(fi, bini) = mean(tdata(:,2) == 9);
        end
    end
    sub{i_file,1} = p_hm;
end
%%
figure('Renderer', 'painters', 'Position', [10 10 900 600])
set(gca, 'Position', [0.5, 0.3, 0.4, 0.2]);
nG = 4;
nsub = length(sub);
for li = 1:nG
    for si = 1:nsub
        td = sub{si, 1};
        nex = sub{si, 2};
        fds = sub{si, 3};
        if size(td,1) < li
            continue;
        end
        if all(isnan(td(li,:)))
            continue;
        end
        subplot(nG,nsub,(li-1)*nsub + si);
        if (nex >0)
        pt = plot(1:nex, td(li,1:nex), '-*b');
        pt.LineWidth = 2;
        hold on;
        end
        nB = size(td,2);
        pt = plot(nex+1:nB, td(li,nex+1:nB), '-*r');
        pt.LineWidth = 2;
        ylim([0 1]);
        xlim([0.5 nB + 0.5]);
        set(gca, 'XTick', 1:nB);
%         xlabel(sprintf('game#%d', li))
        if (li == 1)
            title(sprintf('day = %d', si));
        end
                fd = fds{li};
        xlabel(sprintf('H = %d, L = %d', fd(1), fd(2)))
    end
end
suptitle(ratname);
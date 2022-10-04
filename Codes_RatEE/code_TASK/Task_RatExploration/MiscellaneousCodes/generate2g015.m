function game = generate2g015(Nguided, Nfree, T, rlist, rlistfreq, hbs, R, folder, rndsd, ratname)
    rand('seed', rndsd);
    if ~exist('folder')
        folder = './';
    end
    outputfile = strcat(ratname, '_', 'alter17c_',num2str(rndsd));
    fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    if ~exist('hbs')
        hbs = [1 5];
    end
    fds = [4 6; 8 2];
    var(1).x = [1 2]; % which side is to exploit
    var(1).type = 1;
    var(2).x = [rlistfreq]; % exploit value
    var(2).type = 1;
    [g1 N] = TASK_counterBalancer(var, R);
    [g2 N] = TASK_counterBalancer(var, R);
    hbi(1:2:(2*N-1)) = ceil(rand * 2);
    hbi(2:2:(2*N)) = 3 - hbi(1:2:(2*N-1));
    FDexploit(1:2:(2*N-1)) = g1(1).x_cb;
    FDexploit(2:2:(2*N)) = g2(1).x_cb;
    rlistx(1:2:(2*N-1),1) = g1(2).x_cb;
    rlistx(2:2:(2*N),1) = g2(2).x_cb;
    for ri = 1:size(rlistx,1)
        if rlistx(ri,1) == 1
            idxx = rlist(rlistx(ri,1) ~= rlist);
            idxx = idxx(randperm(length(idxx)));
            rlistx(ri, 2) = idxx(1);
        else
            rlistx(ri, 2) = 1;
        end
    end
    rk = floor(rand*2);
    for i = 1:(2*N)
        ii = rand < 0.5;
        tk(i) = ii;
        if i >= 5 && all(tk([i-4 i-2]) == tk(i)) % forbids the same feeder being better more than 3 times in a row
            ii = 1- ii;
            tk(i) = ii;
        end
        Rexploit(i) = rlistx(i,getidx(FDexploit(i), ii));
        Rexplore(i) = rlistx(i,getidx(3-FDexploit(i), ii));
        hb(i) = hbs(hbi(i));
        fd(i,:) = fds(hbi(i), [FDexploit(i) 3-FDexploit(i)]);
    end
    game = [hb', fd, Rexploit', Rexplore'];
    ng = size(game,1);
    fprintf(fileID,'%d\t%d\t0\t0\t1\n', 7, 0);
%     halfNguided = round(Nguided/2);
    halfNfree = round(Nfree/2);
    for i = 1:ng
        thb = game(i,1);
        tfd = game(i,2:3);
        tr = game(i,4:5);
        od = [1 2];
        od = od(randperm(length(od)));
        od = [ones(1, Nguided)*od(1), ones(1,Nguided)*od(2)];
        for hi = 1:Nguided
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(od(hi)), T, tr(od(hi)));
        end
        for hi = 1:halfNfree
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            if tr(1) == 0
                fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(2), tfd(1), T, tr(2), tr(1));
            else
                fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(1), tfd(2), T, tr(1), tr(2));
            end
        end
        for hi = (1+Nguided):(Nguided*2)
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(od(hi)), T, tr(od(hi)));
        end
        for hi = (halfNfree+1):Nfree
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            if tr(1) == 0
                fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(2), tfd(1), T, tr(2), tr(1));
            else
                fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(1), tfd(2), T, tr(1), tr(2));
            end
        end
        
        fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
    end
    fclose(fileID);
    str = 'file generation complete - alternation';
    disp(str);
    disp(sprintf('total runs = %d', ng*(Nguided + Nfree)*2));
end
function out = getidx(idx, option)
    if option == 0
        out = idx;
    elseif option == 1;
        out = 3 - idx;
    end
end

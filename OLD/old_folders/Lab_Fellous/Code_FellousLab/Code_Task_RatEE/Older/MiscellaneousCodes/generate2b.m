function game = generate2b(Nguided, Nfree, T, rlist, hbs, R, folder, rndsd, ratname)
    rand('seed', rndsd);
    if ~exist('folder')
        folder = './';
    end
    outputfile = strcat(ratname, '_', 'alter17b_',num2str(rndsd));
    fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    if ~exist('hbs')
        hbs = [1 5];
    end
    fds = [4 6; 8 2];
    var(1).x = [1 2]; % which side is to exploit
    var(1).type = 1;
    [g1 N] = TASK_counterBalancer(var, R);
    [g2 N] = TASK_counterBalancer(var, R);
    hbi(1:2:(2*N-1)) = ceil(rand * 2);
    hbi(2:2:(2*N)) = 3 - hbi(1:2:(2*N-1));
    FDexploit(1:2:(2*N-1)) = g1(1).x_cb;
    FDexploit(2:2:(2*N)) = g2(1).x_cb;
    rk = floor(rand*2);
    for i = 1:(2*N)
        ii = floor((i+1)/2);
        ii = mod(ii+rk,2);
        Rexploit(i) = rlist(getidx(FDexploit(i), ii));
        Rexplore(i) = rlist(getidx(3-FDexploit(i), ii));
        hb(i) = hbs(hbi(i));
        fd(i,:) = fds(hbi(i), [FDexploit(i) 3-FDexploit(i)]);
    end
    game = [hb', fd, Rexploit', Rexplore'];
    ng = size(game,1);
    fprintf(fileID,'%d\t%d\t0\t0\t1\n', 7, 0);
    for i = 1:ng
        thb = game(i,1);
        tfd = game(i,2:3);
        tr = game(i,4:5);
        for hi = 1:Nguided
            if rand < 0.5
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(1), T, tr(1));
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(2), T, tr(2));
            else
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(1), T, tr(1));
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(2), T, tr(2));
            end
        end
        for hi = 1:Nfree
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(1), tfd(2), T, tr(1), tr(2));
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

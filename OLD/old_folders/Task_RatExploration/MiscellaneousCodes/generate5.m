function game = generate5(NGs, Nfrees, T, rlist, rlistfreq, hbs, R, folder, rndsd, dt, ratname)
    rand('seed', rndsd +sum(clock()) );
    if ~exist('folder')
        folder = './';
    end
    Nfrees = Nfrees(randperm(length(Nfrees)));
    outputfile = 'Game1';
    fdname = [ratname '_' datestr(now, 30)];
    mkdir(fullfile(folder, fdname));
    fileID = fopen(fullfile(folder, fdname, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    if ~exist('hbs')
        hbs = [1 5];
    end
    fds = [4 6; 8 2];
    var(1).x = [1 2]; % which side is to exploit
    var(1).type = 1;
    var(2).x = [rlistfreq]; % exploit value
    var(2).type = 1;
    var(3).x = [NGs];
    var(3).type = 1;
    [g1 N] = TASK_counterBalancer(var, R);
    [g2 N] = TASK_counterBalancer(var, R);
    hbi(1:2:(2*N-1)) = ceil(rand * 2);
    hbi(2:2:(2*N)) = 3 - hbi(1:2:(2*N-1));
    FDexploit(1:2:(2*N-1)) = g1(1).x_cb;
    FDexploit(2:2:(2*N)) = g2(1).x_cb;
    rlistx(1:2:(2*N-1),1) = g1(2).x_cb;
    rlistx(2:2:(2*N),1) = g2(2).x_cb;
    xGuided(1:2:(2*N-1),1) = g1(3).x_cb;
    xGuided(2:2:(2*N),1) = g2(3).x_cb;
    for ri = 1:size(rlistx,1)
%         if rlistx(ri,1) == 1
            idxx = rlist(rlistx(ri,1) ~= rlist);
            idxx = idxx(randperm(length(idxx)));
            rlistx(ri, 2) = idxx(1);
%         else
%             rlistx(ri, 2) = 1;
%         end
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
        nFree(i,1) = Nfrees( find(hb(i) == hbs));
    end
    game = [hb', fd, Rexploit', Rexplore', nFree, xGuided];
    ng = size(game,1);
    fprintf(fileID,'%d\t%d\t0\t0\t1\n', 9, 0);
%     halfNguided = round(Nguided/2);
    for i = 1:ng
        thb = game(i,1);
        tfd = game(i,2:3);
        tr = game(i,4:5);
        nF = game(i,6);
        Nguided = game(i,7);
        if Nguided == 0
            nF = nF + 1;
        end
        od = [1 2];
        od = od(randperm(length(od)));
        od = [ones(1, Nguided)*od(1), ones(1,Nguided)*od(2)];
        for hi = 1:Nguided
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(od(hi)), T, tr(od(hi)));
        end
        for hi = 1:nF
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
    fileID = fopen(fullfile(folder, fdname, ['Load_SoundMap', '.txt']),'w');
    fprintf(fileID, 'Header - Sound map - Version 2\n');
    fprintf(fileID, '0, Ignored, 2\n');
    fprintf(fileID, '2, NoSound, 2\n');
    fprintf(fileID, '3, Noisy Tone, 2\n');
    fprintf(fileID, '4, NoSound, 2\n');
    fprintf(fileID, '6, NoSound, 2\n');
    fprintf(fileID, '7, Noisy Tone, 2\n');
    fprintf(fileID, '8, NoSound, 2\n');
    
    
    fprintf(fileID, sprintf('%d, Modulated Tone, 2\n', hbs(find(Nfrees == 6))));
    fprintf(fileID, sprintf('%d, PureTone-5kHz, 2\n', hbs(find(Nfrees == 1))));

    
    fclose(fileID);
        fileID = fopen(fullfile(folder, fdname, ['Load_SoundSpecs', '.txt']),'w');
    fprintf(fileID, 'Set of Sample sounds (Vogt)\n');
    fprintf(fileID, 'NoSound, Null ,1,1,25\n');
    fprintf(fileID, 'PureTone-5kHz , a*sin(w*t) , 250, 5000, 25\n');
    fprintf(fileID, 'Modulated Tone , a*sin(w*t)*(3-sin(20*pi(1)*t)) , 250, 1000 , 25\n');
    fprintf(fileID, 'Noisy Tone 		, a*sin(w*t) + 2*(rand(-1)-0.5) , 250, 1000, 25\n');
        fclose(fileID);

    
    
    
    
    str = 'file generation complete - alternation';
    disp(str);
end
function out = getidx(idx, option)
    if option == 0
        out = idx;
    elseif option == 1;
        out = 3 - idx;
    end
end

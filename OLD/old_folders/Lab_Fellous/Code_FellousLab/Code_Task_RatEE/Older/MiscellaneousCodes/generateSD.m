function game = generateSD(NGs, Nfrees, T, rlist, rlistfreq, hbs, R, folder, dt, ratname)
    rand('seed', sum(clock())*1000 );
    if ~exist('folder')
        folder = './';
    end
    Nfrees = Nfrees(randperm(length(Nfrees)));
    outputfile = 'Game1';
    fdname = [ratname '_' datestr(now, 30)];
    mkdir(fullfile(folder, fdname));
    fileID = fopen(fullfile(folder, fdname, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    fds = [4 6; 8 2];
    var(1).x = [1 2]; % which side is to exploit
    var(1).type = 1;
    var(2).x = [rlist]; % exploit value
    var(2).type = 1;
    var(3).x = [0];
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
        idxx = rlist(rlistx(ri,1) ~= rlist);
        idxx = idxx(randperm(length(idxx)));
        rlistx(ri, 2) = idxx(1);
    end
    for i = 1:(2*N)
        Rexploit(i) = rlistx(i,1);
        Rexplore(i) = rlistx(i,2);
        hb(i) = hbs(hbi(i));
        fd(i,:) = fds(hbi(i), [FDexploit(i) 3-FDexploit(i)]);
        nFree(i,1) = Nfrees( find(hb(i) == hbs));
    end
    game = [hb', fd, Rexploit', Rexplore', nFree, xGuided];
    ng = size(game,1);
    horizons = unique(game(:,6));
    thb = game(2,1);
    fprintf(fileID,'%d\t%d\t0\t0\t0\n',  9, 0);
    if game(1,6) == horizons(1)
        fprintf(fileID,'%c%d\t%d\t1\t0\t00\n', gethbletter(thb, -1),thb, T);
    else
        fprintf(fileID,'%c%d\t%d\t1\t0\t00\n', gethbletter(thb, 0),thb, T);
    end
    for i = 1:ng
        thb = game(i,1);
        tfd = game(i,2:3);
        tr = game(i,4:5);
        nF = game(i,6);
        Nguided = game(i,7);
        if Nguided == 0
            nF = nF + 1;
        end
        for hi = 1:Nguided
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(1), T, tr(1));
        end
        for hi = 1:nF
            fprintf(fileID,'%c%d\t%d\t1\t0\t10\n', gethbletter(thb, nF + 1 - hi),thb, T);
            if tr(1) == 0
                    fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(2), tfd(1), T, tr(2), tr(1));
            else
                    fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(1), tfd(2), T, tr(1), tr(2));
            end
        end
        if i < ng
            tnext = game(i + 1,6);
        else
            tnext = game(1,6);
        end
        if tnext == horizons(1)
            fprintf(fileID,'%c%d\t%d\t1\t0\t00\n', gethbletter(thb, -1),thb, T);
        else
            fprintf(fileID,'%c%d\t%d\t1\t0\t00\n', gethbletter(thb, 0),thb, T);
        end
    end
    fclose(fileID);
    fileID = fopen(fullfile(folder, fdname, ['Load_SoundMap', '.txt']),'w');
    fprintf(fileID, 'Header - Sound map - Version 2\n');
    fprintf(fileID, '0, Ignored, 2\n');
    fprintf(fileID, '1, NoSound, 2\n');
    fprintf(fileID, '2, NoSound, 2\n');
    fprintf(fileID, '3, NoSound, 2\n');
    fprintf(fileID, '4, NoSound, 2\n');
    fprintf(fileID, '5, NoSound, 2\n');
    fprintf(fileID, '6, NoSound, 2\n');
    fprintf(fileID, '7, NoSound, 2\n');
    fprintf(fileID, '8, NoSound, 2\n');
    
    fprintf(fileID, '14, StopSoundShort, 2\n');
    fprintf(fileID, '15, StopSoundLong, 2\n');
    fprintf(fileID, '16, PureTone-1kHz, 2\n');
    fprintf(fileID, '17, PureTone-2kHz, 2\n');
    fprintf(fileID, '18, PureTone-3kHz, 2\n');
    fprintf(fileID, '19, PureTone-5kHz, 2\n');
    fprintf(fileID, '20, PureTone-7kHz, 2\n');
    fprintf(fileID, '21, PureTone-9kHz, 2\n');
    fprintf(fileID, '22, PureTone-11kHz, 2\n');
    
    fprintf(fileID, '23, StopSoundShort, 2\n');
    fprintf(fileID, '24, StopSoundLong, 2\n');
    fprintf(fileID, '25, PureTone-1kHz, 2\n');
    fprintf(fileID, '26, PureTone-2kHz, 2\n');
    fprintf(fileID, '27, PureTone-3kHz, 2\n');
    fprintf(fileID, '28, PureTone-5kHz, 2\n');
    fprintf(fileID, '29, PureTone-7kHz, 2\n');
    fprintf(fileID, '30, PureTone-9kHz, 2\n');
    fprintf(fileID, '31, PureTone-11kHz, 2\n');
    fclose(fileID);
    fileID = fopen(fullfile(folder, fdname, ['Load_SoundSpecs', '.txt']),'w');
    fprintf(fileID, 'Set of Sample sounds (Vogt)\n');
    volume = 40;
    fprintf(fileID, 'NoSound, Null ,1,1,%d\n', volume);
    fprintf(fileID, 'PureTone-1kHz , a*sin((w-w*t/2)*t) , 1000, 1000, %d\n', volume);
    fprintf(fileID, 'PureTone-2kHz , a*sin((w-w*t/2/2)*t) , 1000, 2000, %d\n', volume);
    fprintf(fileID, 'PureTone-3kHz , a*sin((w-w*t/3/2)*t) , 1000, 3000, %d\n', volume);
    fprintf(fileID, 'PureTone-5kHz , a*sin((w-w*t/5)*t) , 1000, 5000, %d\n', volume);
    fprintf(fileID, 'PureTone-7kHz , a*sin((w-w*t/7)*t) , 1000, 7000, %d\n', volume);
    fprintf(fileID, 'PureTone-9kHz , a*sin((w-w*t/9)*t) , 1000, 9000, %d\n', volume);
    fprintf(fileID, 'PureTone-11kHz , a*sin((w-w*t/11)*t) , 1000, 11000, %d\n', volume);
    fprintf(fileID, 'Wrong, 2*(rand(-1)-0.5) , 10000, 1000, %d\n', volume);
    fprintf(fileID, 'File_GuidedSound, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Guided.wav , 500, 1000, %d\n', volume);
    fprintf(fileID, 'File_StopSound, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 500, 1000, %d\n', volume);
    fprintf(fileID, 'StopSoundShort , a*sin(w*t/2*t/8) , 8000, 2000, %d\n', volume);
    fprintf(fileID, 'StopSoundLong , a*sin(w*t/2*t/8) , 8000, 11000, %d\n', volume);
    fclose(fileID);

    
    
    
    
    str = 'file generation complete - alternation';
    disp(str);
end
function c = gethbletter(hb, horizon)
    if hb == 1
        c = char('F' + horizon);
    else
        c = char('O' + horizon);
    end
end
% function out = getidx(idx, option)
%     if option == 0
%         out = idx;
%     elseif option == 1;
%         out = 3 - idx;
%     end
% end

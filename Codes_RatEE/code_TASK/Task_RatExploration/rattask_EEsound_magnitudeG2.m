function game = rattask_EEsound_magnitudeG2(folder, ratname, fdtime, fddrops, homebases, horizons, guideds, nRep)
    if ~exist('folder')
        folder = './';
    end
    fdname = [ratname '_' datestr(now, 30)];
    outputfile = 'Game1';
    mkdir(fullfile(folder, fdname));
    fileID = fopen(fullfile(folder, fdname, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    
    nFrees = horizons(randperm(length(horizons)));
    fds = findfeeders(homebases);

    var(1).x = [1 2]; % which side is to exploit
    var(1).type = 1;
    var(2).x = [fddrops]; % exploit value
    var(2).type = 1;
    var(3).x = [guideds]; % nGuided
    var(3).type = 1;
    var(4).x = [homebases];
    var(4).type = 3;
    [gs] = tool_counterBalancer(var, nRep, 1);
    
    fdside(:,1) = gs(1).x_cb;
    Rexploit(:,1) = gs(2).x_cb;
    nGuided(:,1) = gs(3).x_cb;
    hb(:,1) =  gs(4).x_cb;
    for i = 1:length(hb)
        trs = fddrops(~ismember(fddrops, Rexploit(i)));
        trs = trs(randperm(length(trs)));
        Rexplore(i,1) = trs(1);
        fd(i,:) = fds(find(homebases  == hb(i)), [fdside(i) 3-fdside(i)]);
        nFree(i,1) = nFrees( find(hb(i) == homebases));
    end
    game = table(hb, fd, Rexploit, Rexplore, nFree, nGuided);
    ng = size(game,1);
    
    hbpre = game.hb(2);
    fprintf(fileID,'%d\t%d\t0\t0\t0\n',  9, 0);
    if game.nFree(1) == min(nFrees)
        fprintf(fileID,'%c%d\t%d\t1\t0\t00\n', gethbletter(hbpre, -1),hbpre, fdtime);
    else
        fprintf(fileID,'%c%d\t%d\t1\t0\t00\n', gethbletter(hbpre, 0),hbpre, fdtime);
    end
    for i = 1:ng
        thb = game.hb(i);
        tfd = game.fd(i,:);
        tr = [game.Rexploit(i) game.Rexplore(i)];
        nF = game.nFree(i);
        nGuided = game.nGuided(i);
        if nGuided == 0
            nF = nF + 1;
        end
        for hi = 1:nGuided
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, fdtime);
            od = ceil(rand*2);
            if tr(od) == 0
                fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(od), fdtime, tr(od));
            else
                fprintf(fileID,'%d%s\t%d\t1\t0\t%d1\n', tfd(od), getlabel(tfd(od), tr(od)), fdtime, tr(od));
            end
        end
        for hi = 1:nF
            fprintf(fileID,'%c%d\t%d\t1\t0\t10\n', gethbletter(thb, nF + 1 - hi),thb, fdtime);
            if tr(1) == 0 && tr(2) == 0
                fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(2), tfd(1), fdtime, tr(2), tr(1));
            elseif tr(1) == 0 && tr(2) ~= 0
                    fprintf(fileID,'%d%s%d\t%d\t1\t0\t%d1%d\n', tfd(2), getlabel(tfd(2), tr(2)), tfd(1), fdtime, tr(2), tr(1));
            elseif tr(2) == 0 && tr(1) ~= 0
                    fprintf(fileID,'%d%s%d\t%d\t1\t0\t%d1%d\n', tfd(1), getlabel(tfd(1), tr(1)), tfd(2), fdtime, tr(1), tr(2));
            else
                fprintf(fileID,'%d%s%d%s\t%d\t1\t0\t%d1%d1\n', tfd(1), getlabel(tfd(1), tr(1)), tfd(2), getlabel(tfd(2), tr(2)), fdtime, tr(1), tr(2));
            end
        end
        if i < ng
            tnFnext = game.nFree(i + 1);
        else
            tnFnext = game.nFree(1);
        end
        if tnFnext == min(nFrees)
            fprintf(fileID,'%c%d\t%d\t1\t0\t00\n', gethbletter(thb, -1),thb, fdtime);
        else
            fprintf(fileID,'%c%d\t%d\t1\t0\t00\n', gethbletter(thb, 0),thb, fdtime);
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
    
    fprintf(fileID, '37, File_beep1, 2\n');
    fprintf(fileID, '38, File_beep2, 2\n');
    fprintf(fileID, '39, File_beep3, 2\n');
    fprintf(fileID, '40, File_beep4, 2\n');
    fprintf(fileID, '41, File_beep5, 2\n');
    fprintf(fileID, '42, File_beep1, 2\n');
    fprintf(fileID, '43, File_beep2, 2\n');
    fprintf(fileID, '44, File_beep3, 2\n');
    fprintf(fileID, '45, File_beep4, 2\n');
    fprintf(fileID, '46, File_beep5, 2\n');
    fprintf(fileID, '47, File_beep1, 2\n');
    fprintf(fileID, '48, File_beep2, 2\n');
    fprintf(fileID, '49, File_beep3, 2\n');
    fprintf(fileID, '50, File_beep4, 2\n');
    fprintf(fileID, '51, File_beep5, 2\n');
    fprintf(fileID, '52, File_beep1, 2\n');
    fprintf(fileID, '53, File_beep2, 2\n');
    fprintf(fileID, '54, File_beep3, 2\n');
    fprintf(fileID, '55, File_beep4, 2\n');
    fprintf(fileID, '56, File_beep5, 2\n');
    
    
    
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
    % fprintf(fileID, 'PureTone-11kHz , a*sin((w)*t) , 1000, 11000, %d\n', volume);
    fprintf(fileID, 'Noise, 2*(rand(-1)-0.5) , 10000, 1000, %d\n', volume);
    fprintf(fileID, 'File_GuidedSound, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Guided.wav , 500, 1000, %d\n', volume);
    fprintf(fileID, 'File_StopSound, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 500, 1000, %d\n', volume);
    fprintf(fileID, 'StopSoundShort , a*sin(w*t/2*t/8) , 8000, 2000, %d\n', volume);
    fprintf(fileID, 'StopSoundLong , a*sin(w*t/2*t/8) , 8000, 11000, %d\n', volume);
    fprintf(fileID, 'File_beep1, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 100, 1000, %d\n', volume);
    fprintf(fileID, 'File_beep2, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 200, 1000, %d\n', volume);
    fprintf(fileID, 'File_beep3, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 300, 1000, %d\n', volume);
    fprintf(fileID, 'File_beep4, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 400, 1000, %d\n', volume);
    fprintf(fileID, 'File_beep5, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 500, 1000, %d\n', volume);
    
    fclose(fileID);
    
    str = sprintf('file generation complete - EE sound, %d games', ng);
    disp(str);
end
function c = gethbletter(hb, horizon)
    if hb == 1
        c = char('F' + horizon);
    else
        c = char('O' + horizon);
    end
end
function fds = findfeeders(hbs)
    for i = 1:length(hbs)
        thb = hbs(i);
        tfd = 8 + [thb + 3, thb - 3];
        tfd = mod(tfd, 8);
        tfd(tfd == 0) = 8;
        fds(i,:) = tfd;
    end
end

function lb = getlabel(lt, dp)
    x0 = round(lt/2 * 5 + 'a' - 5);
    lb = char(dp + x0);
end
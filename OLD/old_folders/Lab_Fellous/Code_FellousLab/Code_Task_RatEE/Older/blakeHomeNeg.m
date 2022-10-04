function game = blakeHomeNeg(T, feeders, nf, R, nT, folder, rndsd, dt, ratname, probnext)
    rand('seed', rndsd +sum(clock()) );
    if ~exist('folder')
        folder = './';
    end
    side = [];
    while isempty(side)
        side = input('Which direction? W, E, S, N or C: ', 's');
        outputfile = strcat('NegativeZone',side);
        outputfile2 = strcat('HomebaseZone',side);
        switch side
            case 'S'
                side = 'C';
                sideH = 'Z';
            case 'N'
                side = 'A';
                sideH = 'X';
            case 'W'
                side = 'D';
                sideH = 'a';
            case 'E'
                side = 'B';
                sideH = 'Y';
            case 'C'
                side = '9';
                sideH = 'W';
            otherwise
                side = [];
        end
    end
    if ~exist('probnext') 
        probnext = [1 1 2 4 2 1 1];
    end
    probnext = cumsum(probnext)/sum(probnext);
    mkdir(fullfile(folder, [ratname '_' num2str(dt)]));
    fileID = fopen(fullfile(folder, [ratname '_' num2str(dt)], [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    fprintf(fileID,'%d\t%d\t0\t0\t1\n', 9, 0);
    dp = repmat(R, 1, nf);
    dp = str2num(arrayfun(@(x)num2str(x), dp));
    for i = 1:nT
        if nf == 1
            if i == 1
                rod = randperm(length(feeders));
                rod = rod(1);
            else
                ti = min(find(rand< probnext));
                rod = rod + ti;
                if rod > 8
                    rod = rod - 8;
                end
            end
        else
            rod = randperm(length(feeders));
            rod = rod(1:nf);
        end
        rodx(i) = str2num(arrayfun(@(x)num2str(x), rod));
        fprintf(fileID,'%d%s\t%d\t1\t0\t%d0\n', rodx(i), side,T, dp);
    end
    fclose(fileID);
    % control
    fileID = fopen(fullfile(folder, [ratname '_' num2str(dt)], [outputfile2, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    fprintf(fileID,'%d\t%d\t0\t0\t1\n', 9, 0);
    for i = 1:nT
        fprintf(fileID,'%s\t%d\t0\t0\t1\n', sideH, T);
        fprintf(fileID,'%d\t%d\t1\t0\t%d\n', rodx(i),T, dp);
    end
    fclose(fileID);
    str = 'file generation complete - Blake';
    
    
    fileID = fopen(fullfile(folder,  [ratname '_' num2str(dt)], ['Load_SoundMap', '.txt']),'w');
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
    
    fprintf(fileID, '32, File_StopSound, 2\n');
    fprintf(fileID, '33, File_StopSound, 2\n');
    fprintf(fileID, '34, File_StopSound, 2\n');
    fprintf(fileID, '35, File_StopSound, 2\n');
    fprintf(fileID, '36, File_StopSound, 2\n');
    fprintf(fileID, '9, NegativeTone, 2\n');
    fprintf(fileID, '10, NegativeTone, 2\n');
    fprintf(fileID, '11, NegativeTone, 2\n');
    fprintf(fileID, '12, NegativeTone, 2\n');
    fprintf(fileID, '13, NegativeTone, 2\n');
    fclose(fileID);
    fileID = fopen(fullfile(folder,  [ratname '_' num2str(dt)], ['Load_SoundSpecs', '.txt']),'w');
    fprintf(fileID, 'Set of Sample sounds (Vogt)\n');
    volume = 40;
    fprintf(fileID, 'NoSound, Null ,1,1,%d\n', volume);
    fprintf(fileID, 'File_StopSound, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 500, 1000, %d\n', volume);
    fprintf(fileID, 'NegativeTone , a*sin(w*sin(t)*t) , 250, 2000, %d\n', volume);
    fclose(fileID);

    
    
    
    
    disp(str);
    disp(sprintf('total runs = %d', nT*2));
end
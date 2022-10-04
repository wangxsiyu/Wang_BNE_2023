function game = blakeHomeNegv1(T, nf, R, nT, folder, rndsd, dt, ratname, probfd, isnext)
    rand('seed', rndsd +sum(clock()) );
    if ~exist('isnext')
        isnext = 0.5;
    end
    if ~exist('folder')
        folder = './';
    end
    if ~exist('probfd')
        probfd = 1/3;
    end
    side = [];
    sideN = [];
    sideH = 'W';
    while isempty(sideN)
        sideN = input('Which direction to block? 2, 4, 6, or 8: ');
        outputfile = strcat('BothZone',num2str(side));
        switch sideN
            case 6
                side = 'C';
                probfd = [(1-probfd)/3 (1-probfd)/3 probfd (1-probfd)/3];
                %                 sideH = 'Z';
            case 2
                side = 'A';
                probfd = [probfd (1-probfd)/3 (1-probfd)/3 (1-probfd)/3];
                %                 sideH = 'X';
            case 8
                side = 'D';
                probfd = [(1-probfd)/3 (1-probfd)/3 (1-probfd)/3 probfd];
                %                 sideH = 'a';
            case 4
                side = 'B';
                probfd = [(1-probfd)/3 probfd (1-probfd)/3 (1-probfd)/3];
                %                 sideH = 'Y';
            otherwise
                side = [];
        end
    end
    mkdir(fullfile(folder, [ratname '_' num2str(dt)]));
    fileID = fopen(fullfile(folder, [ratname '_' num2str(dt)], [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    fprintf(fileID,'%d\t%d\t0\t0\t1\n', 9, 0);
    dp = repmat(R, 1, nf);
    dp = str2num(arrayfun(@(x)num2str(x), dp));
    probfd = cumsum(probfd)/sum(probfd);
    for i = 1:nT
        rod = min(find(rand< probfd))*2;
        rodx(i) = str2num(arrayfun(@(x)num2str(x), rod));
    end
    rodx(nT+1) = 0;
    for i = 1:nT
        fprintf(fileID,'%s\t%d\t1\t0\t1\n', sideH, T);
        fprintf(fileID,'%d%s\t%d\t1\t0\t%d0\n', rodx(i), side,T, dp);
        if isnext ~= 0
            if rodx(i) ~= sideN && rand < isnext
                rnext = sideN;
            else
                rrest = setdiff([1 2 3 4 5 6 7 8], [rodx(i+1), rodx(i)-1, rodx(i),  rodx(i)+1,  rodx(i) -7,  rodx(i)+7]);
                rrest = rrest(randperm(length(rrest)));
                rnext = rrest(1);
            end
            rodnext(i) = rnext;
            fprintf(fileID,'%d%s\t%d\t1\t0\t%d0\n', rnext, side, T, dp);
        else
            rodnext(i) = NaN;
        end
    end
    str = 'file generation complete - Blake';
    fclose(fileID);
    outputfile2 = 'Control';
    fileID = fopen(fullfile(folder, [ratname '_' num2str(dt)], [outputfile2, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    fprintf(fileID,'%d\t%d\t0\t0\t1\n', 9, 0);
    for i = 1:nT
        fprintf(fileID,'%d\t%d\t1\t0\t%d\n', rodx(i),T, dp);
        if ~isnan(rodnext(i))
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', rodnext(i),T, dp);
        end
    end
    fclose(fileID);
    
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
    %     fprintf(fileID, '33, File_StopSound, 2\n');
    %     fprintf(fileID, '34, File_StopSound, 2\n');
    %     fprintf(fileID, '35, File_StopSound, 2\n');
    %     fprintf(fileID, '36, File_StopSound, 2\n');

    switch sideN
        case 6
            side = 'C';

            fprintf(fileID, '12, NegativeTone, 2\n');
        case 2
            side = 'A';
            fprintf(fileID, '10, NegativeTone, 2\n');
            %                 sideH = 'X';
        case 8
            side = 'D';

            fprintf(fileID, '13, NegativeTone, 2\n');
            %                 sideH = 'a';
        case 4
            side = 'B';
            fprintf(fileID, '11, NegativeTone, 2\n');
            %                 sideH = 'Y';
        otherwise
            side = [];
    end
    %     fprintf(fileID, '9, NegativeTone, 2\n');
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
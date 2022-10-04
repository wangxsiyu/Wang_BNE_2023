function game = rattask_randomlightssound(folder, ratname, lights, ngame, fdtime)
    if ~exist('folder')
        folder = './';
    end
    nlight = 1;
    fdname = [ratname '_' datestr(now, 30)];
    mkdir(fullfile(folder, fdname));
    outputfile = 'Game1';
    fileID = fopen(fullfile(folder, fdname, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    fprintf(fileID,'%d\t%d\t0\t0\t0\n',  9, 0);
    light0 = [];
    for i = 1:ngame
        fddrop = floor(3 * rand());
        tlights = lights(~ismember(lights, light0));
        tlights = tlights(randperm(length(tlights)));
        light0 = tlights(1:nlight);
        if fddrop == 0
            fstr = ['%d', '\t%d\t1\t0\t' '%d' '\n'];
            fprintf(fileID,fstr, light0, fdtime, fddrop);
        else
            fstr = ['%d%s', '\t%d\t1\t0\t' '%d1' '\n'];
            fprintf(fileID,fstr, light0, getlabel(light0, fddrop), fdtime, fddrop);
        end
    end
    fclose(fileID);
    str = sprintf('file generation complete - randomlights, nlight = %d, ngame = %d', nlight, ngame);
    disp(str);
    
    fileID = fopen(fullfile(folder,  fdname, ['Load_SoundMap', '.txt']),'w');
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
    fprintf(fileID, 'File_beep1, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 100, 1000, %d\n', volume);
    fprintf(fileID, 'File_beep2, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 200, 1000, %d\n', volume);
    fprintf(fileID, 'File_beep3, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 300, 1000, %d\n', volume);
    fprintf(fileID, 'File_beep4, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 400, 1000, %d\n', volume);
    fprintf(fileID, 'File_beep5, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , 500, 1000, %d\n', volume);
    fclose(fileID);

    
end
function lb = getlabel(lt, dp)
    x0 = round(lt/2 * 5 + 'a' - 5);
    lb = char(dp + x0);
end
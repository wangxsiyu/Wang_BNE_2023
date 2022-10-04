function game = rattask_randomlights(folder, ratname, lights, nlight, ngame, fdtime, fddrop)
    if ~exist('folder')
        folder = './';
    end
    if  nlight * 2 > length(lights)
        error('SiyuErr: total number of available lights must be at least 2 times of nlight');
    end
    fdname = [ratname '_' datestr(now, 30)];
    mkdir(fullfile(folder, fdname));
    outputfile = 'Game1';
    fileID = fopen(fullfile(folder, fdname, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    fprintf(fileID,'%d\t%d\t0\t0\t0\n',  9, 0);
    light0 = [];
    for i = 1:ngame
        tlights = lights(~ismember(lights, light0));
        tlights = tlights(randperm(length(tlights)));
        light0 = tlights(1:nlight);
        fstr = [repmat('%d', 1, nlight), '\t%d\t1\t0\t' repmat('%d', 1, nlight) '\n'];
        fprintf(fileID,fstr, light0, fdtime, repmat(fddrop, 1, nlight));  
    end
    fclose(fileID);
    str = sprintf('file generation complete - randomlights, nlight = %d, ngame = %d', nlight, ngame);
    disp(str);
    
    fileID = fopen(fullfile(folder,  fdname, ['Load_SoundMap', '.txt']),'w');
    fprintf(fileID, 'Header - Sound map - Version 2\n');
    fprintf(fileID, '0, Ignored, 2\n');
    fprintf(fileID, '1, NoSound, 2\n');
    fprintf(fileID, '2, File_beep1, 2\n');
    fprintf(fileID, '3, NoSound, 2\n');
    fprintf(fileID, '4, File_beep1, 2\n');
    fprintf(fileID, '5, NoSound, 2\n');
    fprintf(fileID, '6, File_beep1, 2\n');
    fprintf(fileID, '7, NoSound, 2\n');
    fprintf(fileID, '8, File_beep1, 2\n');
    fclose(fileID);
    fileID = fopen(fullfile(folder, fdname, ['Load_SoundSpecs', '.txt']),'w');
    fprintf(fileID, 'Set of Sample sounds (Vogt)\n');
    volume = 40;
    fprintf(fileID, 'NoSound, Null ,1,1,%d\n', volume);
    fprintf(fileID, 'File_beep1, D:\\BackupArea\\SoundPlayerConfigurationFiles\\SiyuSound\\Stop.wav , %d, 1000, %d\n', 100*fddrop, volume);
    fclose(fileID);
end

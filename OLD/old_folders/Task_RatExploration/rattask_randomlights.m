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
end

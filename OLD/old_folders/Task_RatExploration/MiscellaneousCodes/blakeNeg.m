function game = blakeNeg(T, feeders, nf, R, nT, folder, rndsd, dt, ratname, probnext)
    rand('seed', rndsd +sum(clock()) );
    if ~exist('folder')
        folder = './';
    end
    side = [];
    while isempty(side)
        side = input('Which direction? W, E, S, N or C: ', 's');
        outputfile = strcat('NegativeZone',side);
        outputfile2 = strcat('Control',side);
        switch side
            case 'S'
                side = 'C';
            case 'N'
                side = 'A';
            case 'W'
                side = 'D';
            case 'E'
                side = 'B';
            case 'C'
                side = '9';
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
        fprintf(fileID,'%d\t%d\t1\t0\t%d\n', rodx(i),T, dp);
    end
    fclose(fileID);
    str = 'file generation complete - Blake';
    disp(str);
    disp(sprintf('total runs = %d', nT*2));
end
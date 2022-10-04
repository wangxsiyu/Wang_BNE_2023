function game = blake(T, feeders, nf, R, nT, folder, rndsd, dt, ratname)
    rand('seed', rndsd +sum(clock()) );
    if ~exist('folder')
        folder = './';
    end
    outputfile = strcat(ratname, '_', 'blakeExp_',num2str(dt));
    fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    for i = 1:nT
        rod = randperm(length(feeders));
        rod = rod(1:nf);
        rod = str2num(arrayfun(@(x)num2str(x), rod));
        dp = repmat(R, 1, nf);
        dp = str2num(arrayfun(@(x)num2str(x), dp));
        fprintf(fileID,'%d\t%d\t0\t0\t1\n', 9, T);
        fprintf(fileID,'%d\t%d\t1\t0\t%d\n', rod, T, dp);
    end
    fclose(fileID);
    str = 'file generation complete - Blake';
    disp(str);
    disp(sprintf('total runs = %d', nT*2));
end
function generate_feedertest(N, steplevel, level, folder)
    if ~exist('folder')
        folder = './';
    end
    rand('seed', sum(clock()));
    outputfile = strcat('taskset_feedertest', '_level', num2str(level),'.txt');
    fileID = fopen(fullfile(folder, outputfile),'w');
    fprintf(fileID, '1\t1\t%d\n', steplevel);
    for i = 1:N
        for j = 1:8
            fprintf(fileID,'%d\t%d\t1\t0\n', j, level);
        end
    end
    for i = 1:N
        for j = 1:8
            fprintf(fileID,'%d\t%d\t0\t0\n', j, level);
        end
    end
    fclose(fileID);
    disp('file generation complete - feeder test');
end
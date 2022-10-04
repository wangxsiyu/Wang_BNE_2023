function [tracks, header] = import_tracker(TrackFile)
    % load track data
    try
        if ~exist(TrackFile,'file')
            cprintf('red','***: ERROR: track file %s does not exist\n',TrackFile);
            return
        end
        fp = fopen(TrackFile);
        content = textscan(fp,'%s','delimiter','\n');
        fclose(fp);
        allLines = content{1};
        header = allLines{1};
        footer = allLines{end}; % this is sometimes real data
        tracks=zeros(length(allLines)-2,3);
        for i=2:(length(allLines)-1)
            tracks(i-1,:) = sscanf(allLines{i},'%f %f %f')';
        end
        clear allLines content;
    catch me
        fprintf('*** ERROR: Line %d in %s \n %s \n', i, TrackFile, me.message)
        return
    end
end
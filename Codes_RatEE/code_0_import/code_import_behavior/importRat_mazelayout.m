function [maze] = importRat_mazelayout(MazeFile)
    if ~exist(MazeFile,'file')
        error('Error: MazeFile %s not Found\n', MazeFile)
        return
    end
    fid=fopen(MazeFile,'r');
    C=textscan(fid,'%f %f','CommentStyle','%');
    fclose(fid);
    xy=[C{1} C{2}];
   
    PixtoCMeter= xy(1,2)/xy(1,1);
    xy=xy(2:end,:);
    maze.pix2cm = repmat(PixtoCMeter, size(xy,1),1);
    maze.x = xy(:,1);
    maze.y = xy(:,2);
    maze = struct2table(maze);
    maze.number = [1:size(maze,1)]';
    maze.letter = arrayfun(@(x)getletter(x), 1:size(maze,1))';
    maze.locationID = arrayfun(@(x)getloc(x, xy), maze.number);
    maze.isfeeder = false(size(maze,1), 1);
    maze.isfeeder(1:8) = true;
%     maze.locationID = maze.locationID .* sign(maze.isfeeder - 0.5);
end
function a = getloc(x, xy)
    a = min(find(xy(:,1) == xy(x,1) & xy(:,2) == xy(x,2)));
end
function a = getletter(x)
    if x <= 9
        a = num2str(x);
    elseif x <= 35
        a = char('A' + x - 10);
    elseif x <= 61
        a = char('a' + x - 36);
    else
        a = '';
    end
    a = string(a);
end
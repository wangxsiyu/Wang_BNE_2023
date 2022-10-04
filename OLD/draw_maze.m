function [RewLocs, ScaleFactor]= draw_maze(varargin)
    LABELSHIFT = 3;       % in pixels. small shift to printf the labels of the feeders
    RewLocs=[];
    ScaleFactor = -1;
    ToScale=0;          % plots in pixels by default
%     if nargin > 1
        MazeLayout=varargin{1};
        FntSize = 10;
        if nargin > 2
            if ~isempty(varargin{2})
                FntSize = varargin{2}; % SIYU?
                if nargin > 3
                    ToScale = varargin{3}; % SIYU?
                end
            end
        end
%         if exist(MazeLayout,'file')        % load the feeder position, and compute the circular edges of the table
%             [MazeType, ScaleFactor, allfeeders]=ReadMazeLayout(MazeLayout,0);
%         else
            allfeeders = table2array(MazeLayout(:,2:3));
            ScaleFactor = unique(table2array(MazeLayout(:,1)));
%         end
            Plotfactor=1+ToScale*(ScaleFactor-1);
            feeders=Plotfactor*[allfeeders(:,1), 480-allfeeders(:,2)];    % adjust the coordinates
            hold on
            [xc,yc,R] = circfit(feeders(1:8,1), feeders(1:8,2));
            drawCircle(xc,yc,R,'g','LineWidth',2);
            
            plot(feeders(:,1),feeders(:,2),'k.','MarkerSize',8);
            text(feeders(1,1)+ LABELSHIFT*Plotfactor, feeders(1,2)+ LABELSHIFT*Plotfactor,'1','FontWeight','bold','FontSize',FntSize)
            text(feeders(2,1)+ LABELSHIFT*Plotfactor, feeders(2,2)+ LABELSHIFT*Plotfactor,'2','FontWeight','bold','FontSize',FntSize)
            RewLocs=[feeders(:,1), feeders(:,2)];
%         else
%             fprintf('...: Error. Could not find the Maze Layout file: %s\n',MazeLayout);
%             return
%         end
%     else
%         fprintf('...Maze drawing error: You must specify the Boatlocation Filename for maze %d\n',Maze)
%         return
%     end
    
end

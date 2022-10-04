classdef W_plt < W_plt_base
    properties
    end
    methods
        function obj = W_plt(varargin)
            obj.setup_W_plt(varargin{:});
        end
        function str = scatter(obj, x, y, option, colorl, colord,shaped) % needs check
            if ~exist('option') || isempty(option)
                option = 'corr';
            end
            if ~exist('colorl') || isempty(colorl)
                colorl = 'k';
            end
            if ~exist('colord') || ismepty(colord)
                colord =[];
            end
            if ~exist('shaped') || isempty(shaped)
                shaped = '.';
            end
            axi = obj.fig.indices(obj.fig.current(1), obj.fig.current(2));
%             if ~isempty(obj.param_fig.color) && length(obj.param_fig.color) >= axi
%                 color = obj.param_fig.color{axi};
%             else
%                 color = [];
%             end
%             color = W.encell(color);
%             if length(color) > 1 && obj.param_fig.colordelete == 1
%                 obj.param_fig.color{obj.axi} = color(2:end); % remove the used colors
%             end
%             if ~isempty(color)
%                 color = color{1};
%             end
            x = reshape(x, length(x), 1);
            y = reshape(y, length(x), 1);
            idnan = isnan(x) | isnan(y);
            x = x(~idnan);
            y = y(~idnan);
            [r, p] = corr(x,y);
            dotsize = obj.param_figsetting.dotsize;
            dotsize = 30;
            hold on;
%             if isempty(colord)
%                 st = plot(x, y, '.', 'MarkerSize', dotsize);
%             else
            if ~isempty(colord)
                for i = 1:length(x)
                    if i == 1
                        obj.figon;
                        plot(NaN, NaN, 'color', colorl);
                        obj.figoff;
                    end
                    plot(x(i), y(i), shaped, 'MarkerSize', dotsize,'Color', colord{i});
                    hold on;
                end
            else
                st = plot(x, y, shaped, 'MarkerSize', dotsize,'Color', 'k');
            end
%             end
            str = sprintf('R = %.2f, p = %g', r, p);
            if obj.param_fig.onoff
                obj.fig.leglist{axi}(end + 1) = st;
            end
            switch option
                case 'corr'
                    l = lsline;
                    set(l, 'linewidth', obj.param_figsetting.linewidth, 'color', colorl);
                   
                case 'diag'
                    xmin = min(min(x), min(y));
                    xmax = max(max(x), max(y));
                    dx = xmax - xmin;
                    xmin = xmin - dx * 0.2;
                    xmax = xmax + dx * 0.2;
                    plot([xmin,xmax], [xmin,xmax], '--k', 'linewidth', obj.param_figsetting.linewidth);
                    xlim([xmin xmax]);
                    ylim([xmin xmax]);
            end
            
        end
        function lineplot(obj, av, mbar, x, linestyle, stat)
            % av = array[line x points]
            av = W.decell(av);
            if exist('mbar')
                mbar = W.decell(mbar);
            end
            if (exist('x')~=1) || isempty(x)
                x = 1:size(av, 2);
            end
            if size(x,1) == 1 && size(av,1) > 1
                x = repmat(x, size(av,1), 1);
            end
            axi = obj.fig.indices(obj.fig.current(1), obj.fig.current(2));
            if ~isempty(obj.param_fig.color) % && obj.param_fig.onoff
                color = W_basic.encell(obj.param_fig.color{axi});
                obji = obj.param_fig.objecti;
                if isempty(color{1})
                    color = {};
                end
            else
                color = {};
                obji = NaN;
            end
            nls = size(av,1);
            if ~exist('linestyle') || isempty(linestyle)
                linestyle = '-';
            end
            linestyle = W_basic.encell(linestyle);
            if length(linestyle) == 1
                linestyle = repmat(linestyle, 1, nls);
            end
            if ~isnan(obji) && length(color) >= nls + obji
                color = color((1:nls) + obji);
                obj.param_fig.objecti = obji + nls;
            elseif isempty(color)
                warning('color not specified, use system colors');
            end
            hold on;
            c = 0;
%             nleg = length(obj.fig.legidx{axi});
            for li = 1:nls
                if all(isnan( av(li,:)))
                    c = c+ 1;
%                     obj.fig.legidx{axi}(nleg+li) = false;
                else
%                     obj.fig.legidx{axi}(nleg+li) = obj.param_fig.onoff;
                    if ~exist('mbar') || isempty(mbar)
                        eb = plot(x(li,:), av(li,:), linestyle{li}, ...
                            'LineWidth', obj.param_figsetting.linewidth);
                        eb.MarkerSize = obj.param_figsetting.dotsize;
                    else
                        mbar = W.decell(mbar);
                        eb = errorbar(x(li,:), av(li,:), mbar(li,:), linestyle{li}, ...
                            'LineWidth', obj.param_figsetting.linewidth);
                        eb.CapSize = obj.param_figsetting.capsize_errorbar;
                    end
                    if ~isempty(color) && c < length(color)
                        c = c+ 1;
                        eb.Color = color{c};
                        eb.MarkerFaceColor = color{c};
                    end
                    if obj.param_fig.onoff
                        obj.fig.leglist{axi}(end + 1) = eb;
                    end
                end
            end
            
            if exist('stat') && size(av,1) > 1% currently doesn't work for a single line
                ym = max(av+mbar);
                xm = mean(x);
                
                if isempty(obj.param_fig.gap_sigstary)
                    yl = 0.05*(max(ym)-min(ym));
                else
                    yl = obj.param_fig.gap_sigstary{axi};
                end
                if isempty(obj.param_fig.gap_sigstarx)
                    xl = 0;
                else
                    xl = obj.param_fig.gap_sigstarx{axi};
                end
                obj.sigstar(xm, ym, stat,xl, yl);
            end
            
            hold off;
        end
        function barplot(obj, av, mbar, x)
            % av = array[line x points]
            av = W.decell(av);
            if exist('mbar')
                mbar = W.decell(mbar);
            else
                mbar = [];
            end
            if (exist('x')~=1) || isempty(x)
                x = 1:size(av, 2);
            end
            if size(x,1) == 1 && size(av,1) > 1
                x = repmat(x, size(av,1), 1);
            end
            axi = obj.fig.indices(obj.fig.current(1), obj.fig.current(2));
            if ~isempty(obj.param_fig.color) % && obj.param_fig.onoff
                color = W_basic.encell(obj.param_fig.color{axi});
                obji = obj.param_fig.objecti;
                if isempty(color{1})
                    color = {};
                end
            else
                color = {};
                obji = NaN;
            end
            av = W.horz(av);
            mbar = W.horz(mbar);
            hold on;
            for i = 1:length(x)
                bb = bar(x(i), av(i));
                if ~isempty(color) 
                    if length(color) > 1
                        bb.FaceColor = color{i};
                    else
                        bb.FaceColor = color{1};
                    end
                end
                bb.FaceAlpha = 0.5;
                if ~exist('mbar') || isempty(mbar)
                    %                 eb = plot(x, av, ...
                    %                     'LineWidth', obj.param_figsetting.linewidth);
                    %                 eb.MarkerSize = obj.param_figsetting.dotsize;
                else
                    eb = errorbar(x(i), av(i), mbar(i),'.', ...
                        'LineWidth', obj.param_figsetting.linewidth);
                    eb.CapSize = obj.param_figsetting.capsize_errorbar;
                    if ~isempty(color)
                        if length(color) > 1
                            eb.MarkerFaceColor = color{i};
                            eb.Color = color{i};
                        else
                            eb.MarkerFaceColor = color{1};
                            eb.Color = color{1};
                        end
                    end
                end
            end
            
            hold off;
        end
        function shadeplot(obj, av, mbar, x)
            % av = array[line x points]
            av = W.decell(av);
            if exist('mbar')
                mbar = W.decell(mbar);
            end
            if (exist('x')~=1) || isempty(x)
                x = 1:size(av, 2);
            end
            if size(x,1) == 1 && size(av,1) > 1
                x = repmat(x, size(av,1), 1);
            end
            axi = obj.fig.indices(obj.fig.current(1), obj.fig.current(2));
            if ~isempty(obj.param_fig.color) % && obj.param_fig.onoff
                color = W_basic.encell(obj.param_fig.color{axi});
                obji = obj.param_fig.objecti;
                if isempty(color{1})
                    color = {};
                end
            else
                color = {};
                obji = NaN;
            end
            nls = size(av,1);
            if ~isnan(obji) && length(color) >= nls + obji
                color = color((1:nls) + obji);
                obj.param_fig.objecti = obji + nls;
            end
            hold on;
            c = 0;
            for li = 1:nls
                if all(isnan( av(li,:)))
                    c = c+ 1;
                else
                    y_sem = mbar(li,:);
                    top = av(li,:) + y_sem;
                    bot = av(li,:) - y_sem;
                    tx = x(li,:);
                    yy = [top bot(end:-1:1)];
                    xx = [tx   tx(end:-1:1)];
%                     range.x = [min(xx), max(xx)];
%                     range.y = [min(yy), max(yy)];
                    c = c+ 1;
                    col = color{c};
                    col = col * 0.5;
                    f = fill(xx, yy, col);
                    set(f, 'linestyle', 'none','facealpha',0.3)
                    
                    eb = plot(x(li,:), av(li,:),  ...
                        'LineWidth', obj.param_figsetting.linewidth);
                    eb.MarkerSize = obj.param_figsetting.dotsize;
%                     if ~isempty(color) && c < length(color)
                        eb.Color = color{c};
                        eb.MarkerFaceColor = color{c};
%                     end
                    if obj.param_fig.onoff
                        obj.fig.leglist{axi}(end + 1) = eb;
                    end
                end
            end
            hold off;
        end
        function sigstar(obj, x, y, p, dx, dy)
            if ~exist('dx') || isempty(dx)
                dx= 0;
            end
            if ~exist('dy') || isempty(dy)
                dy= 0;
            end
            strp = W.getstatstars(p);
            len = cellfun(@(x)length(x),strp);
            dx = dx * (len-1)/2;
            text(x + dx, y + dy, strp);
        end
%         function sigstar_y(obj, ylocs, xlocs, stats, side)
%             xlim('auto');
%             ylim('auto');
%             switch side
%                 case 'left'
%                     side = -1;
%                 case 'right'
%                     side = 1;
%             end
%             nosort = false;
%             if ~nosort
%                 [~,ind]=sort(ylocs(:,2)-ylocs(:,1),'ascend');
%                 ylocs = ylocs(ind,:);
%                 stats = stats(ind);
%             end
%             ntot = length(stats);
%             holdstate = ishold;
%             hold on
%             H = ones(ntot,2); %The handles will be stored here
%             dist = 0.05;
%             xrg = range(xlim);
%             yd = xrg*dist; %separate sig bars vertically by 5%
%             for ii = 1:ntot
%                 thisX = obj.getmax_xlim(ylocs(ii,:), side);
%                 thisX = thisX + side*yd;
%                 if ii == 1
%                     thisX = thisX + side*xrg*0.1;
%                 end
%                 % draw bar and star
%                 [H(ii,:), dist] = obj.makeSignificanceBar_y(thisX, ylocs(ii,:), side, stats(ii), ntot > 3);
%                 % dash line
%                 for yj = 1:size(xlocs,2)
%                     if ~isnan(dist) || ntot < 4
%                         XXX = sort([thisX,xlocs(yj)]);
%                         XXX = XXX(1):0.05:XXX(2);
%                         plot([XXX],repmat(ylocs(ii,yj),size(XXX,1),size(XXX,2)),'.k','LineWidth',0.5);
%                     end
%                 end
%             end
%             yd = range(xlim)*0.02; %Ticks are 2% of the y axis range
%             for ii = 1:ntot
%                 tx=get(H(ii,1),'XData');
%                 ty=get(H(ii,1),'YData');
%                 x = tx([1 3 2 4]);
%                 y = ty([1 3 2 4]);
%                 x(1)=x(1)-side*yd;
%                 x(4)=x(4)-side*yd;
%                 set(H(ii,1),'YData',y)
%                 set(H(ii,1),'XData',x)
%             end
%             %Be neat and return hold state to whatever it was before we started
%             if ~holdstate
%                 hold off
%             elseif holdstate
%                 hold on
%             end
%         end
%         function [H,dist]=makeSignificanceBar_y(obj, x,y,side,p, flag)
%             %makeSignificanceBar produces the bar and defines how many asterisks we get for a
%             %given p-value
%             if ~exist('flag')
%                 flag = false;
%             end
%             stars = W.getstatstars(p,[],obj.param_figsetting.stat_starorvalue);
%             x = repmat(x,1,4);
%             y = repmat(y,1,2);
%             
%             if p > 0.1 && flag
%                 H(1) = plot(x,y(:),'-k','LineWidth',0.5,'Tag','sigstar_bar', 'visible','off');
%             else
%                 H(1) = plot(x,y(:),'-k','LineWidth',0.5,'Tag','sigstar_bar');
%             end
%             %Increase offset between line and text if we will print "n.s."
%             %instead of a star.
%             if ~isnan(p) && p <= 0.1
%                 offset=0.001;
%                 dist = 0.04;
%             else
%                 offset=0.01;
%                 dist = NaN;
%             end
%             
%             starX = mean(x)+ side * range(xlim)*offset;
%             if p > 0.2 && flag
%                 H(2) = text(starX,mean(y(:)),stars,...
%                     'HorizontalAlignment','center',...
%                     'VerticalAlignment','baseline',...
%                     'BackGroundColor','none',...
%                     'Tag','sigstar_stars','FontSize',20,'visible', 'off');
%                 set(H(2),'Rotation',180 + 90*side);
%             else
%                 H(2) = text(starX,mean(y(:)),stars,...
%                     'HorizontalAlignment','center',...
%                     'VerticalAlignment','baseline',...
%                     'BackGroundColor','none',...
%                     'Tag','sigstar_stars','FontSize',20);
%                 set(H(2),'Rotation',180 + 90*side);
%             end
%             
%             X=xlim;
%             if starX*side > side*(side*max(side*X)+side*range(X)*0.05)
%                 xnew = sort([starX+side*range(X)*0.05 side*max(side*X)+side*range(X)*0.05 X]);
%                 xlim([xnew(1) xnew(3)]); % may have a bug here...
%             end
%         end %close makeSignificanceBar
%         function X = getmax_xlim(obj, y, side)
%             oldXLim = get(gca,'xlim');
%             oldYLim = get(gca,'ylim');
%             axis(gca,'tight');
%             y = sort(y);
%             if y(1) == y(2)
%                 y(2) = y(2) + 0.00001;
%             end
%             set(gca,'ylim', y) %Matlab automatically re-tightens y-axis
%             xLim = get(gca,'xlim'); %Now have max y value of all elements within range.
%             switch side
%                 case 1
%                     X = max(xLim);
%                 case -1
%                     X = min(xLim);
%             end
%             axis(gca,'normal')
%             set(gca,'xlim',oldXLim,'ylim',oldYLim)
%         end %close getmax_xlim
    end
end
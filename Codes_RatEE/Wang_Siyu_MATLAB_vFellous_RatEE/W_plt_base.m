classdef W_plt_base < handle
    properties
        param_preset % default params
        param_setting % dir, name
        param_figsetting % linewidth, fontsize
        param_fig % xlabel
        fig
    end
    methods
        function obj = W_plt()
        end
        %% default
        function default_preset(obj)
            % (preset) set up figure configuration - preset
            params.colors = W_colors;
            
            figconfig.rect{1,1} = [0.3 0.15 0.4 0.65];
            figconfig.margin{1,1} = [0.17, 0.2, 0.05, 0.05];
            figconfig.gap{1,1} = [0.1 0.1];
            
            figconfig.rect{1,2} = [0.1 0.15 0.85 0.7];
            figconfig.margin{1,2} = [0.15, 0.08, 0.05, 0.03];
            figconfig.gap{1,2} = [0.1 0.1];
            
            figconfig.rect{1,3} = [0.05 0.15 0.9 0.5];
            figconfig.margin{1,3} = [0.15, 0.08, 0.05, 0.03];
            figconfig.gap{1,3} = [0.1 0.1];
            
            figconfig.rect{2,2} = [0.15 0.05 0.6 0.9];
            figconfig.margin{2,2} = [0.12, 0.1, 0.05, 0.05];
            figconfig.gap{2,2} = [0.15 0.1];
            
            figconfig.rect{2,3} = [0.15 0.05 0.75 0.9];
            figconfig.margin{2,3} = [0.12, 0.1, 0.05, 0.02];
            figconfig.gap{2,3} = [0.1 0.08];
            
            figconfig.rect{2,4} = [0.15 0.05 0.9 0.9];
            figconfig.margin{2,4} = [0.12, 0.1, 0.05, 0.02];
            figconfig.gap{2,4} = [0.1 0.08];
            
            figconfig.rect{3,2} = [0.15 0.03 0.5 0.95];
            figconfig.margin{3,2} = [0.11, 0.11, 0.04, 0.03];
            figconfig.gap{3,2} = [0.12 0.11];
            
            figconfig.rect{4,2} = [0.15 0.02 0.4 0.95];
            figconfig.margin{4,2} = [0.1, 0.12, 0.04, 0.02];
            figconfig.gap{4,2} = [0.09 0.12];
            
            figconfig.rect{6,4} = [0.15 0.01 0.6 0.96];
            figconfig.margin{6,4} = [0.12, 0.1, 0.05, 0.01];
            figconfig.gap{6,4} = [0.05 0.05];
            params.fig_config = figconfig;
            
            pltconfig.dotsize_line = 7;
            pltconfig.dotsize = 10;
            pltconfig.capsize_errorbar = 6;
            pltconfig.linewidth = 2;
            pltconfig.fontsize_axes = 20;
            pltconfig.fontsize_face = 30;
            pltconfig.fontsize_leg = 15;
            pltconfig.islegbox = false;
            pltconfig.islegmark = true;
            pltconfig.isbold = false;
            pltconfig.legend_linewidth =[];
            % (setting) stat params
            pltconfig.stat_starorvalue = 'star';
            params.plt_config = pltconfig;
            obj.param_preset = params;
        end
        %% setups
        function setup_W_plt(obj, varargin)
            obj.default_preset;
            obj.initialize(varargin{:});
            obj.setup_pltparams;
            obj.param_fig.islocked = 0;
            obj.setup_fig_default;
            obj.fig.size = [1 1];
        end
        function initialize(obj, varargin)
            disp('plt_initialize: set up view/save options');
            obj.param_setting.isshow = true; % show figure
            obj.param_setting.fig_suffix = ''; % default suffix
            obj.param_setting.fig_projectname = ''; % default project name
            obj.param_setting.fig_dir = ''; % default directory
            obj.param_setting.fig_issave = 0;
            obj.param_setting.fig_saveformat = 'png';
            obj.fig.savename = '';
            % (setting) write user specified parameters
            obj.setuserparam('param_setting', varargin{:});
            obj.param_setting.fig_issave = ~isempty(obj.param_setting.fig_dir);
        end
        function setup_pltparams(obj, varargin)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % fig setting params
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %             SW.print('log', 'plt_setpltparams: set plotting params');
            % plotting params
            if nargin > 1 && strcmp(varargin{1}, 'hold')
                varargin = varargin(2:end);
            else
                obj.param_figsetting = obj.param_preset.plt_config;
            end
            obj.setuserparam('param_figsetting', varargin{:});
        end
        function setuserparam(obj, fd, varargin)
            inarglist = fieldnames(obj.(fd));
            i = 1;
            while i <= length(varargin)
                arg = varargin{i};
                idx = find(strcmp(inarglist, arg));
                if strcmp('help', arg)
                    i = i + 1;
                    disp(inarglist);
                elseif ~isempty(idx)
                    val = varargin{i+1};
                    i = i + 2;
                    obj.(fd).(arg) = val;
                else
                    i = i + 1;
                    warning(sprintf('command not recognized: %s', arg));
                end
            end
        end
        function setup_fig_default(obj)
            if obj.param_fig.islocked == 0
                obj.param_fig.color = [];
                obj.param_fig.xlim = [];
                obj.param_fig.ylim = [];
                obj.param_fig.title = [];
                obj.param_fig.legend = [];
                obj.param_fig.legloc = [];
                obj.param_fig.legcol = [];
                obj.param_fig.legord = [];
                obj.param_fig.xlabel = [];
                obj.param_fig.ylabel = [];
                obj.param_fig.xticklabel = [];
                obj.param_fig.yticklabel = [];
                obj.param_fig.xtick = [];
                obj.param_fig.ytick = [];
                obj.param_fig.gap_sigstarx = [];
                obj.param_fig.gap_sigstary = [];
                obj.param_fig.objecti = 0;
                obj.figon;
            else
                obj.param_fig.islocked = 2;
            end
        end
        %% figure & axes
        function figure(obj, nx, ny, varargin)
            if (exist('nx')~=1) || isempty(nx) || nx < 1
                nx = 1;
            end
            if (exist('ny')~=1) || isempty(ny) || ny < 1
                ny = 1;
            end
            istitle = cellfun(@(x)(ischar(x)|isstring(x)) && any(contains(string(x), 'title')) , varargin);
            obj.initialize_figure(nx, ny, any(istitle));
            varargin = varargin(~istitle);
            obj.setup_pltparams;
            obj.setuserparam('param_fig', varargin{:});
            if obj.param_setting.isshow
                str_onoff = 'on';
            else
                str_onoff = 'off';
            end
%             if strcmp(obj.param_setting.fig_saveformat, 'ppt')
%                 disp('pptfigure...');
%                 g = pptfigure('visible', str_onoff);
%             else
            g = figure('visible', str_onoff);
%             end
            set(g, 'units','normalized','outerposition',obj.param_fig.rect);
            if iscell(obj.param_fig.gap) % allows for unequal gaps
                hg = [NaN obj.param_fig.gap{1} NaN];
                wg = [NaN obj.param_fig.gap{2} NaN];
            else
                hg = ones(1, nx+1) * obj.param_fig.gap(1);
                wg = ones(1, ny+1) * obj.param_fig.gap(2);
            end
            hg(1) = obj.param_fig.margin(1);
            wg(1) = obj.param_fig.margin(2);
            hg(end) = obj.param_fig.margin(3);
            wg(end) = obj.param_fig.margin(4);
            rt = obj.param_fig.ax_ratio;
            thb = (1-sum(hg));
            twb = (1-sum(wg));

            hb = thb * (rt./W.funccol('sum', rt));
            wb = twb * (rt'./W.funccol('sum', rt'))';
            count = 1;
            for i_high = nx:-1:1
                for i_wide = 1:ny
                    if obj.param_fig.matrix_hole(nx+ 1- i_high, i_wide) == 1
                        bx(1) = sum(wg(1:i_wide)) + sum(wb(i_high,1:i_wide-1));
                        bx(2) = sum(hg(1:i_high)) + sum(hb(1:i_high-1, i_wide));
                        bx(3) = wb(i_high,i_wide);
                        bx(4) = hb(i_high,i_wide);
                        rc{count} = bx;
                        idx(nx+ 1- i_high, i_wide) = count;
                        count = count + 1;
                    else
                        idx(nx+ 1- i_high, i_wide) = NaN;
                    end
                end
            end
            for i = 1:length(rc)
                axes('position', rc{i})
                ax(i) = gca;
                set(gca, 'tickdir', 'out');
                set(gca, 'XTickLabelRotation', 0);
            end
            obj.fig.g = g;
            obj.fig.axes = ax;
            obj.fig.indices = idx;
            obj.fig.isholdon = false(nx, ny);
            obj.fig.leglist = repmat({[]}, length(ax), 1);
            %             obj.fig.legidx = repmat({[]}, length(ax), 1);
            obj.fig.current = [0,0];
            obj.fig.currentidx = 0;
            obj.fig.size = [nx, ny];
%             obj.fig.lgdobj = repmat({[]}, length(ax), 1);
%             obj.fig.lgdobjlb = repmat({[]}, length(ax), 1);
            obj.setup_fig_default;
        end
        function initialize_figure(obj, nx, ny, istitle)
            if ~exist('istitle') || isempty(istitle)
                istitle = 0;
            end
            margintt = 0.02;
            try
                obj.param_fig.rect = obj.param_preset.fig_config.rect{nx,ny};
                if isempty(obj.param_fig.rect)
                    error;
                end
            catch
                warning('no rect pre-defined for the size');
                obj.param_fig.rect = obj.param_preset.fig_config.rect{1,1};
            end
            try
                obj.param_fig.margin = obj.param_preset.fig_config.margin{nx,ny} + istitle * [0,0,1,0] * margintt;
                if isempty(obj.param_fig.margin)
                    error;
                end
            catch
                warning('no margin pre-defined for the size');
                obj.param_fig.margin = obj.param_preset.fig_config.margin{1,1} + istitle * [0,0,1,0] * margintt;
            end
            try
                obj.param_fig.gap = obj.param_preset.fig_config.gap{nx,ny};
                if isempty(obj.param_fig.gap)
                    error;
                end
            catch
                warning('no gap pre-defined for the size');
                obj.param_fig.gap = obj.param_preset.fig_config.gap{1,1};
            end
            obj.param_fig.matrix_hole = ones(nx, ny);
            obj.param_fig.ax_ratio = ones(nx, ny);
        end
        
        function ax(obj, varargin)
            obj.param_fig.objecti = 0;% need edit
            fig = obj.fig;
            switch nargin
                case 1
                    warning('please specify axes');
                    return;
                case 2
                    axi = varargin{1};
                    [x1, x2] = find(fig.indices == axi);
                case 3
                    x1 = varargin{1};
                    x2 = varargin{2};
                    axi = fig.indices(x1, x2);
            end
            obj.fig.current = [x1, x2];
            obj.fig.currentidx = obj.fig.indices(obj.fig.current(1),obj.fig.current(2));
            set(fig.g, 'CurrentAxes', ...
                fig.axes(axi));
            set(gca, 'FontSize', obj.param_figsetting.fontsize_face);
            %             plt_hold;
            %             hold on;
        end
        function new(obj)
            obj.param_fig.objecti = 0; % need edit
            fig = obj.fig;
            x1 = fig.current(1);
            x2 = fig.current(2);
            if (x1 == 0 && x2 == 0)
                axi = 0;
            else
                axi = fig.indices(x1, x2);
                if fig.isholdon(x1, x2)
                    return;
                end
            end
            axi = axi + 1;
            if axi > length(fig.axes)
                return;
            end
            [x1, x2] = find(fig.indices == axi);
            obj.fig.current = [x1, x2];
            obj.fig.currentidx = obj.fig.indices(obj.fig.current(1),obj.fig.current(2));
            set(fig.g, 'CurrentAxes', ...
                fig.axes(axi));
            set(gca, 'FontSize', obj.param_figsetting.fontsize_face);
        end
        function figon(obj)
            obj.param_fig.onoff = true;
        end
        function figoff(obj)
            obj.param_fig.onoff = false;
        end
        %% setfig
        function setfig_new(obj)
            obj.param_fig.islocked = false;
            obj.setup_fig_default;
        end
        function setfig_loc(obj, varargin)
            obj.param_fig.islocked = true;
            obj.setfig(varargin{:});
        end
        function setfig(obj, varargin)
            if isnumeric(varargin{1}) && isnumeric(varargin{2})
                n_tot = varargin{1};
                id = varargin{2};
                n_ax = length(id);
                i = 3;
            elseif isnumeric(varargin{1})
                tn = varargin{1};
                if length(tn) > 1
                    n_tot = length(obj.fig.axes);
                    id = tn;
                    n_ax = length(id);
                else
                    n_tot = tn;
                    id = 1:n_tot;
                    n_ax = n_tot;
                end
                i = 2;
            else
                n_ax = length(obj.fig.axes);
                n_tot = n_ax;
                id = 1:n_ax;
                i = 1;
            end
            while i < nargin
                arg = varargin{i};
                val = varargin{i+1};
                val = W_basic.encell(val);
                i = i + 2;
                if ~any(strcmp(arg, fieldnames(obj.param_fig)))
                    warning(sprintf('%s is not a sub-field of param_fig, value skipped', arg));
                    continue;
                end
                switch arg
                    case 'color'
                        colorfunc = @(str)cellfun(@(x)obj.calc_color(x),str,'UniformOutput',false);
                        if all(cellfun(@(x)~iscell(x), val)) % single plot, multiple lines
                            val = colorfunc(val);
                        else
%                             val = [];
                            for ni = 1:length(val)
                                val{ni} = W_basic.decell(colorfunc(val{ni}));
                            end
                        end
                end
                if obj.param_fig.islocked > 0 && ~isempty(obj.param_fig.(arg))
                    continue;
                end
                if isempty(obj.param_fig.(arg))
                    obj.param_fig.(arg) = W.empty_create('cell',[1 n_tot]);
                end
                if length(val) == n_ax % have params for each different plot
                    obj.param_fig.(arg)(id) = val;
                elseif length(val) == 1
                    obj.param_fig.(arg)(id) = repmat(val, 1, n_ax);
                else
                    obj.param_fig.(arg)(id) = repmat({val}, 1, n_ax);
                end
            end
        end
        function setfig_ax(obj, varargin)
            i = 1;
            axi = obj.fig.indices(obj.fig.current(1), obj.fig.current(2));
            while i < nargin
                arg = varargin{i};
                val = varargin{i+1};
                val = W_basic.encell(val);
                i = i + 2;
                if ~any(strcmp(arg, fieldnames(obj.param_fig)))
                    warning(sprintf('%s is not a sub-field of param_fig, value skipped', arg));
                    continue;
                end
                switch arg
                    case 'color'
                        colorfunc = @(str)cellfun(@(x)obj.calc_color(x),str,'UniformOutput',false);
                        if all(cellfun(@(x)~iscell(x), val)) % single plot, multiple lines
                            val = colorfunc(val);
                        else
                            val = [];
                            for ni = 1:length(val)
                                val{ni} = W_basic.decell(colorfunc(val{ni}));
                            end
                        end
                end
                obj.param_fig.(arg){axi} = W_basic.decell(val);
            end
        end
        function update(obj)
            obj.param_fig.islocked = 0;
            fig = obj.fig;
            axs = 1:length(fig.axes);
            for axi = axs
                set(fig.g,'CurrentAxes',fig.axes(axi));
                set(gca, 'FontSize', obj.param_figsetting.fontsize_axes);
                if ~isempty(obj.param_fig.xtick) && length(obj.param_fig.xtick) >= axi
                    if isempty(obj.param_fig.xtick{axi})
%                         continue;
                    elseif isempty(obj.param_fig.xticklabel)
                        set(gca,'XTick', obj.param_fig.xtick{axi});
                    else
                        set(gca,'XTick', obj.param_fig.xtick{axi}, ...
                            'XTickLabel', obj.param_fig.xticklabel{axi});
                    end
                end
                if ~isempty(obj.param_fig.ytick) && length(obj.param_fig.ytick) >= axi
                    if isempty(obj.param_fig.ytick{axi})
%                         continue;
%                     end
                    elseif isempty(obj.param_fig.yticklabel)
                        set(gca,'YTick', obj.param_fig.ytick{axi});
                    else
                        set(gca,'YTick', obj.param_fig.ytick{axi}, ...
                            'YTickLabel', obj.param_fig.yticklabel{axi});
                    end
                end
                if ~isempty(obj.param_fig.xlim) && length(obj.param_fig.xlim) >= axi && ~isempty(obj.param_fig.xlim{axi})
                    xlim(obj.param_fig.xlim{axi});
                end
                if ~isempty(obj.param_fig.ylim) && length(obj.param_fig.ylim) >= axi && ~isempty(obj.param_fig.ylim{axi})
                    ylim(obj.param_fig.ylim{axi});
                end
                if ~isempty(obj.param_fig.title) && length(obj.param_fig.title) >= axi
                    str = obj.param_fig.title{axi};
                    title(str,'FontWeight','normal','FontSize', obj.param_figsetting.fontsize_face);
                end
                if ~isempty(obj.param_fig.xlabel) && length(obj.param_fig.xlabel) >= axi
                    xlabel(obj.param_fig.xlabel{axi}, 'FontSize', obj.param_figsetting.fontsize_face);
                end
                if ~isempty(obj.param_fig.ylabel) && length(obj.param_fig.ylabel) >= axi
                    ylabel(obj.param_fig.ylabel{axi}, 'FontSize', obj.param_figsetting.fontsize_face);
                end
                if ~isempty(obj.param_fig.legend) && length(obj.param_fig.legend) >= axi %&& length(obj.param_fig.legend) >= axi
                    if isempty(obj.param_fig.legloc) || ...
                            length(obj.param_fig.legloc) < axi || ...
                            (length(obj.param_fig.legloc) >= axi && isempty(obj.param_fig.legloc{axi}))
                        tlegloc = 'NorthEast';
                    else
                        tlegloc = obj.param_fig.legloc{axi};
                    end
                    fontsize = obj.param_figsetting.fontsize_leg;
                    leg_lw = obj.param_figsetting.legend_linewidth;
                    leg = obj.param_fig.legend{axi};
                    if isstring(leg)
                        leg = W_basic.arrayfun(@(x)char(x), leg);
                    else
                        leg = W_basic.encell(leg);
                    end
%                     if length(leg) > length(fig.leglist{axi})
%                         leg = leg(fig.legidx{axi} == 1);
%                     end
                    if ~iscell(leg)
                        leg = arrayfun(@(x)x, leg, 'UniformOutput',false);
                    end
                    if length(leg) == length(fig.leglist{axi}) && ~all(cellfun(@(x)isempty(x), leg))
                        %                          if  ~obj.param_figsetting.islegmark
                        %                              obj.leglist{axi} = line(nan, nan, 'Linestyle', 'none', 'Marker', 'none', 'Color', 'none');
                        %                          end
                        tleglist = fig.leglist{axi};
                        if ~isempty(obj.param_fig.legord) && ~isempty(obj.param_fig.legord{axi})
                            if ischar(obj.param_fig.legord{axi}) && strcmp(obj.param_fig.legord{axi}, 'reverse')
                                leg = leg(end:-1:1);
                                tleglist = tleglist(end:-1:1);
                            else
                                leg = leg(obj.param_fig.legord{axi});
                                tleglist = tleglist(obj.param_fig.legord{axi});
                            end
                        end
                        axP = get(gca,'Position');
%                         if isempty(obj.param_fig.legcol)
%                             tcol = 1;
%                         else
%                             tcol = obj.param_fig.legcol{axi};
%                         end
%                         lgd = columnlegend(tcol, tleglist, leg,...
%                             'Location', tlegloc);
                        lgd = legend(tleglist, leg,...
                            'Location', tlegloc);
                        set(gca, 'Position', axP);
                        lgd.FontSize = fontsize;
                        if ~isempty(leg_lw)
                            lgd.ItemTokenSize = leg_lw;
                        end
                        if  ~obj.param_figsetting.islegmark
                            lgd.Position(1) = lgd.Position(1) - 0.05;
                        end
%                         obj.fig.lgdobj{axi} = lgd;
%                         obj.fig.lgdobjlb{axi} = lglb;
                        if obj.param_figsetting.islegbox
                            legend('boxon')
                        else
                            legend('boxoff');
                        end
                    elseif ~isempty(leg{1})
                        [t1,t2] = find(obj.fig.indices == axi);
                        warning(sprintf('axes (%d,%d): legend ignored: number of legend entries didn''t match the number of plots', ...
                            t1,t2));
                        disp(leg);
                    end
                end
            end
            obj.setup_fig_default;
            obj.save;
        end
        function addABCs(obj, offset, abcString)
            ax = obj.fig.axes;
            fontsize = obj.param_figsetting.fontsize_face;
            if exist('abcString')~= 1
                abcString = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];
            end
            if exist('fontsize') ~= 1
                fontsize = 20;
            end

            if exist('offset') && ~isempty(offset)
                if size(offset,1) ==  1
                    offset = repmat(offset, length(ax), 1);
                end
                for i = 1:length(ax)
                    pos(i,:) = get(ax(i), 'position');
                end
                ABCpos = [pos(:,1)+offset(:,1) pos(:,2)+pos(:,4)+offset(:,2)];
            else
                for i = 1:length(ax)
                    pos(i,:) = get(ax(i), 'outerposition');

                end
                ABCpos = [pos(:,1) pos(:,2)+pos(:,4)];
            end



            for i = 1:length(ax)
                tb(i) = annotation('textbox');
                set(tb(i), 'fontsize', fontsize, 'fontweight', 'normal', ...
                    'margin', 0, 'horizontalAlignment', 'center', ...
                    'verticalAlignment', 'top', 'lineStyle', 'none')

                set(tb(i), 'fontunits', 'normalized')
                fs = get(tb(i), 'fontsize');
                set(tb(i), 'fontunits', 'points')

                set(tb(i), 'string', abcString(i))

                rec = [ABCpos(i,1)-fs/2 ABCpos(i,2)-fs fs fs];
                set(tb(i), 'position', rec)
            end
        end
        %% save
        function out = savename(obj, filename, extension)
            if ~exist('extension')
                extension = obj.param_setting.fig_saveformat;
            end
            if isempty(obj.param_setting.fig_dir) && ~ischar(obj.param_setting.fig_dir)
                error('set up figdir first');
            end
            if ~isempty(obj.param_setting.fig_projectname)
                pn_ = '_';
            else
                pn_ = '';
            end
            filefolder = obj.param_setting.fig_dir;
            filefullpath = fullfile(filefolder, ...
                strcat(obj.param_setting.fig_projectname, pn_, filename, obj.param_setting.fig_suffix, ['.' extension]));
            if ~exist(filefolder)
                mkdir(filefolder);
            end
            obj.fig.savename = filefullpath;
            out = ~exist(obj.fig.savename, 'file');
            if ~out
                disp('warning - figure exists');
            end
        end
        function save(obj, filename, extension)
            if ~(obj.param_setting.fig_issave)
                return;
            end
            if ~exist('extension')
                extension = obj.param_setting.fig_saveformat;
            end
            if strcmp(extension, 'ppt')
                return;
            end
            if exist('filename') && ~isempty('filename')
                obj.savename(filename, extension);
            end
            if isempty(obj.fig.savename)
                return;
            end
            if ~strcmp(extension, 'emf')
                disp('saving')
                saveas(obj.fig.g, obj.fig.savename, extension);
            elseif ispc
                disp('saving emf')
                set(obj.fig.g, 'Color', 'none', 'Inverthardcopy', 'off'); 
                print(obj.fig.g, '-dmeta', fullfile(obj.fig.savename));
            else
                disp('unable to save .emf in mac');
            end
            obj.fig.savename = '';
        end
        %% supporting
        function out = calc_color(obj, str)
            if isnumeric(str)
                out = str;
                return;
            elseif ~(ischar(str) || isstring(str))
                out = [0 0 0]; % black
                return;
            end
            [num, idx] = W_basic.str_select(str);
            if isnan(num)
                num = 100;
            end
            str = str(~idx);
            try
                col = obj.param_preset.colors.(str);
            catch
                col = [0,0,0];
                warning(sprintf('color %s not found', str));
            end
            out = col * num/100 + (1-num/100) * [1 1 1];
        end
    end
end
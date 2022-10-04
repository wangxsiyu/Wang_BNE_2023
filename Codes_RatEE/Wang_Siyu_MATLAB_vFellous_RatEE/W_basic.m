classdef W_basic < handle
    properties
    end
    methods(Static)
        %% basic
        function out = iif(istrue, a, b)
            if istrue
                out = a;
            else
                out = b;
            end
        end
        %% matrix
        function a = vert(a)
            if size(a,1) == 1
                a = a';
            end
        end
        function a = horz(a)
            if size(a,2) == 1
                a = a';
            end
        end
        %% arithmetic
        function out = mod0(a,b,varargin)
            out = mod(a,b,varargin{:});
            if any(out == 0)
                out(out == 0) = b;
            end
        end
        function out = getrank(a)
            as = W.unique(a,0);
            out = a * NaN;
            for ai = 1:length(as)
                ta = as(ai);
                out(a == ta) = ai;
            end
        end
        %% NaN
        function out = nan_select(a, id)
            dtype = class(a);
            if strcmp(dtype, 'logical')
                a = a + 0;
            end
            if isnan(id)
                out = W_basic.empty_create(dtype, [1 1]);
            else
                out = a(id);
            end
        end
        function out = nan_equal(a, b)
            % a == b, considering NaN
            out = 1 - abs(sign(a - b));
        end
        function a = nan_changem(a, x)
            if ~exist('x')
                warning('nan_changem: default value set to 0');
                x = 0;
            end
            a(isnan(a)) = x;
        end
        function out = nan_get(a, islast)
            if ~exist('islast') || isempty(islast)
                islast = 0;
            end
            if islast == 1
                a = a(:, end:-1:1);
            end
            na = size(a,1);
            out = W.arrayfun(@(x)a(x, find(~isnan(a(x,:)),1,'first')), 1:na);
        end
        %% empties
        function out = empty_create(dtype, sz)
            switch dtype
                case 'cell'
                    out = cell(sz);
                case {'numeric', 'double'}
                    out = nan(sz);
                case 'char'
                    out = repmat(' ', sz); % this may only create an empty char array
                case 'string'
                    out = repmat("", sz);
                case 'logical'
                    out = nan(sz);
                case 'datetime'
                    out = NaT(sz);
                otherwise
                    out = [];
                    warning('empty_create: dtype not recognized');
            end
        end
        %% functions
        function out = cellfun(func, a)
            a = W_basic.encell(a);
            try
                out = cellfun(func, a);
            catch
                out = cellfun(func, a, 'UniformOutput', false);
            end
        end
        function out = arrayfun(func, a)
            a = W_basic.decell(a);
            try
                out = arrayfun(func, a);
            catch
                out = arrayfun(func, a, 'UniformOutput', false);
            end
        end
        function out = funcout(fcn, n, varargin)
            fcn = str2func(fcn);
            if ~exist('n')
                n = [];
            end
            nOut=nargout(fcn);
            X=cell(1,nOut);
            [X{:}]=fcn(varargin{:});
            if isempty(n)
                n = 1:nOut;
            end
            out = W_basic.decell(X(n));
        end
        %% cells
        function a = decell(a)
            while iscell(a) && length(a) == 1
                a =  a{1};
            end
        end
        function a = encell(a)
            if ~iscell(a)
                a = {a};
            end
        end        
        function cel = cell_squeeze(cel)
            cel(cellfun('isempty', cel)) = [];
        end
        function [a] = cell_extend_nan(a, nM)
            % extend the matrix in each cell to have the same number of columns
            nl  = cellfun(@(x)size(x,2), a);
            if ~exist('nM') || isempty(nM)
                nM = max(nl,[],'all');
            end
            a = cellfun(@(x) W_basic.extend_nan(x, nM),  a, 'UniformOutput',false);
            if isnumeric(a{1}) && ...
                size(a,2) == 1 && ... % only deals with 1 column of cells
                all(cellfun(@(x)size(x,1), a) ==  1) % each cell has 1 row
                a = vertcat(a{:});
            end
        end
        function [a] = cell_extend(a, nM, varargin)
            % extend the matrix in each cell to have the same number of columns
            if ischar(a{1})
                warning('did not extend char cells');
                return; 
            end
            nl  = cellfun(@(x)size(x,2), a);
            if ~exist('nM') || isempty(nM)
                nM = max(nl,[],'all');
            end
            a = cellfun(@(x) W_basic.extend(x, nM, varargin{:}),  a, 'UniformOutput',false);
            if ischar(a{1})
                a = string(a);
            elseif isnumeric(a{1}) && ...
                size(a,2) == 1 && ... % only deals with 1 column of cells
                all(cellfun(@(x)size(x,1), a) ==  1) % each cell has 1 row
                a = vertcat(a{:});
            end
        end
        
        function [b] = cell_sum(a, opt_nan)
            if ~exist('opt_nan') || isempty(opt_nan)
                opt_nan = 1;
            end
            a = W.encell(a);
            if opt_nan
                a = W.cellfun(@(x)W.nan_changem(x, 0), a);
            end
            b = a{1};
            for i = 2:length(a)
                b = b+ a{i};
            end
        end
        %% read & write
        function out = readtable(filename, varargin)
            out = readtable(filename, varargin{:});
            out = W_basic.tab_autofieldcombine(out, 1);
        end
        function writetable(tab, filename, varargin)
            if nargin >= 3 && ischar(varargin{1}) && ...
                    strcmp(varargin{1}, 'squeeze')
                tab = W.tab_autofieldcombine(tab);
                tab = W.tab_squeeze(tab);
                varargin = varargin(2:end);
            end
            tab = W_basic.tab_denested(tab); % a column of the table is table
            writetable(tab, filename, varargin{:});
        end
        function out = table2struct(tab)
            out = struct;
            fns = tab.Properties.VariableNames;
            for fi = 1:length(fns)
                fn = fns{fi};
                out.(fn) = tab.(fn);
            end
        end
        %% tables
        function tab = tab_autofieldcombine(tab, isnested)
            if ~exist('isnested') || isempty(isnested)
                isnested = 0;
            end
            fs = tab.Properties.VariableNames;
            % _
            is_ = find(contains(fs, '_'));
            idx_ = strfind(fs, '_');
            idxnonnum_ = arrayfun(@(x)isempty(str2double(fs{x}(idx_{x}(end)+1:end))), is_);
            is_ = is_(~idxnonnum_);
            fs_ = unique(arrayfun(@(x)fs{x}(1:idx_{x}(end)), is_,'UniformOutput',false));
            flag = false;
            for fi = 1:length(fs_)
                fn = fs_{fi};
                idx_col = find(arrayfun(@(x)length(fn) <= length(fs{x}) && ...
                    strcmp(fs{x}(1:length(fn)),fn) && idx_{x}(end) == length(fn), 1:length(fs)));
                ord = W.arrayfun(@(x)str2double(fs{x}(idx_{x}(end)+1:end)), idx_col);
                if iscell(ord) % only if ord has empty cells
                    ord = [ord{:}];
                end
                ord = ord(~isnan(ord)); % exclude NaN;
                if length(ord) == 0 % no numbers
                    continue;
                end
                if length(ord) ~= max(ord) % missing elements has to be 1,2,3,...,n
%                     warning(sprintf('tab_autofieldcombine: len != max. %s', fn))
                    continue;
                end
                flag = true;
                [~, idx] = sort(ord);
                idx_col = idx_col(idx);
                if all(arrayfun(@(x)size(tab.(fs{x}),2) == 1, idx_col))
                    tab = mergevars(tab, fs(idx_col), 'NewVariableName', fn(1:end-1));
                else % this is table format
                    tab.(fn(1:end-1)) = tab(:, contains(tab.Properties.VariableNames, fs(idx_col)));
                    tab = removevars(tab, fs(idx_col));
                end
            end
            if isnested == 1 && flag%length(fs_) > 0
                tab = W_basic.tab_autofieldcombine(tab, isnested);
            end
        end
        function tab = tab_denested(tab)
             fs = tab.Properties.VariableNames;
             idtab = find(cellfun(@(x)istable(tab.(x)), fs));
             for it = idtab
                 fn = fs{it};
                 te = tab.(fn);
                 tab = removevars(tab, fn);
                 tab = W_basic.tab_horzcat(tab, te);
             end
             if length(idtab) > 0
                 tab = W_basic.tab_denested(tab);
             end
        end
        function tab = tab_fill(tab, varargin)
            if nargin == 2 % in this case, fn should be a table
                fn = varargin{1};
                tab = W_basic.tab_horzcat(tab, repmat(fn, size(tab,1),1));
            else
                fn = varargin{1};
                x = varargin{2};
                tab.(fn) = repmat(x, size(tab,1),1);
            end
        end
        function tab = tab_horzcat(a, b, option) % merge b into a
            if ~exist('option') || isempty(option)
                option = 'duplicate';
            end
            c = intersect(a.Properties.VariableNames, b.Properties.VariableNames);
            if ~isempty(c)
                for ci = 1:length(c)
                    if strcmp(option, 'duplicate')
                        b.([c{ci} '_duplicate']) = b.(c{ci});
                        b.(c{ci}) = [];
                    elseif strcmp(option, 'overwrite')
                        disp(sprintf('ignoring field %s from the 2nd table', c{ci}));
                        b.(c{ci}) = [];
                    end
                end
            end
            tab = horzcat(a, b);
        end
        function out = tab_vertcat(varargin)
            varargin = W_basic.encell(W_basic.decell(varargin));
            var = varargin(cellfun(@(x)~isempty(x), varargin));
            if isempty(var)
                out = table;
                return;
            end
            try
                out = vertcat(var{:});
            catch
%                 var = W_basic.encell(W_basic.decell(varargin));
                varnames = cellfun(@(x)x.Properties.VariableNames, var, 'UniformOutput', false);
                fn = unique([varnames{:}]);
                sz = cellfun(@(x)W_basic.fieldsize(x, fn,2), var, 'UniformOutput', false);
                sz = horzcat(sz{:});
                sz_max =  max(sz')';
                for i = 1:size(sz,1) % field names
                    idnotnan = min(find(~isnan(sz(i,:))));
                    dtype = class(varargin{idnotnan}.(fn{i}));
                    if strcmp(dtype, 'char') % turn chars to strings
                        dtype = 'string';
                        sz_max(i) = 1;
                        for j = 1:size(sz, 2)
                            if ~isnan(sz(i,j))
                                varargin{j}.(fn{i}) = string(varargin{j}.(fn{i}));
                            end
                        end
                    elseif strcmp(dtype, 'table')
                        disp('ignoring sub-table when combining');
                        for j = 1:size(sz,2)
                            varargin{j}.(fn{i}) = [];
                        end
                        continue;
                    end
                    for j = 1:size(sz, 2) % # of tables
                        if isnan(sz(i,j)) || sz(i,j) == 0
                            varargin{j}.(fn{i}) = W_basic.empty_create(dtype, [size(varargin{j},1), sz_max(i)]);
                        elseif sz(i,j) ~= sz_max(i)
                            varargin{j}.(fn{i}) = W_basic.extend(varargin{j}.(fn{i}), sz_max(i));
                        end
                    end
                end
                out = vertcat(varargin{:});
            end
        end
        function tab = tab_squeeze(tab)
            fnms = tab.Properties.VariableNames;
            for fi = 1:length(fnms)
                fn = fnms{fi};
                if isnumeric(tab.(fn))
                    tt = tab.(fn);
                    tab.(fn) = W_basic_ext.nan_squeeze_col(tt);
                elseif iscell(tab.(fn))
                    tt = tab.(fn);
                    tab.(fn) = W_basic_ext.cell_squeeze_col(tt);
                    tab.(fn) = W_basic.cell_extend(tab.(fn));
                end
            end
        end
        %% structure
        function Snew = struct_rename(Sold, oldnames, newnames)
            N = numel(Sold);
            for k=1:numel(oldnames)
                [Snew(1:N).(newnames{k})] = deal(Sold.(oldnames{k})) ;
            end
        end
        function Snew = struct_name_pfxsfx(Sold, pfx, sfx)
            oldnames = fieldnames(Sold);
            newnames = strcat(pfx, oldnames, sfx);
            Snew = W_basic.struct_rename(Sold, oldnames, newnames);
        end
        function Snew = struct_flat(Sold)
            fnms = fieldnames(Sold);
            Snew = struct;
            for si = 1:length(fnms)
                fn = fnms{si};
                Snew.(fn) = W.horz(Sold.(fn));
            end
        end
        %% files and directories
        function [out, outtab] = dir(str, option)
            if ~exist('option') || isempty(option)
                option = 'all';
                % all - both
                % file - files only
                % folder - folders only
            end
            % exclude . ..
            out = dir(str);
            out = out(arrayfun(@(x)~any(strcmp({'.','..'}, x.name)), out));
            % exclude hidden files
            out = out(arrayfun(@(x)~strcmp(x.name(1), '.'), out));
            % select files or directory
            switch option
                case 'file'
                    out = out([out.isdir] == 0);
                case 'folder'
                    out = out([out.isdir] == 1);
                case 'dir'
                    out = out([out.isdir] == 1);
            end
            folder_name = string({out.name})';
            folder_path = string({out.folder})';
            outtab = table(folder_name, folder_path);
        end
        function out = file_deext(file)
            file = string(file);
            file = strsplit(file, '.');
            out = file(1); % can't deal with multiple .s
        end
        function out = file_enext(file, ext)
            file = W_basic.file_deext(file);
            out = strcat(file, ".", ext);
        end
        %% extend
        function y = extend_nan_full(x, n, selectside, sortside)
            if ~exist('selectside') || isempty(selectside)
                selectside = 'left';
            end
            if ~exist('sortside') || isempty(sortside)
                sortside = 'left';
            end
            if size(x,1) == 0 % doesn't allow matrices of nrow = 0
                x = NaN;
            end
            if size(x,2) < n
                switch sortside
                    case 'left'
                        y = [x nan(size(x,1), n- size(x,2))];
                    case 'right'
                        y = [nan(size(x,1), n- size(x,2)) x];
                end
            else
                switch selectside
                    case 'left'
                        y = x(:,1:n);
                    case 'right'
                        y = x(:,end-n+1:end);
                end
            end
        end
        function y = extend_nan(x, n)
            if size(x,1) == 0 % doesn't allow matrices of nrow = 0
                x = NaN;
            end
            y = [x nan(size(x,1), n- size(x,2))];
        end
        function y = extend_str(x, n, ch) % this one only works for single chars
            if ~exist('ch') || isempty(ch)
                ch = "";
            end
            if isempty(x) || size(x,1) == 0 % doesn't allow 0xN char
                y = "";
                return; % just return empty
            end
            if size(x,2) < n
                y = [x repmat(ch, size(x,1), n- size(x,2))];
            else
                y = x(:,1:n);
            end
        end
        function y = extend_char(x, n, ch, selectside, sortside) % this one only works for single chars
            if ~exist('ch') || isempty(ch)
                ch = ' ';
            end
            if ~exist('selectside') || isempty(selectside)
                selectside = 'left';
            end
            if ~exist('sortside') || isempty(sortside)
                sortside = selectside;
            end
            if isempty(x) || size(x,1) == 0 % doesn't allow 0xN char
                y = '';
                return; % just return empty
            end
            if size(x,2) < n
                switch sortside
                    case 'left'
                        y = [x repmat(ch, size(x,1), n- size(x,2))];
                    case 'right'
                        y = [repmat(ch, size(x,1), n- size(x,2)) x];
                end
            else
                switch selectside
                    case 'left'
                        y = x(:,1:n);
                    case 'right'
                        y = x(:,end-n+1:end);
                end
            end
        end
        function y = extend(x, n, varargin)
            if ~exist('n') || isempty(n)
                n = max(size(x,2), 1);
            end
            if isnumeric(x) || islogical(x)
                y = W_basic.extend_nan(x, n, varargin{:});
            elseif iscell(x)
                y = W_basic.extend_cell(x, n, varargin{:});
            elseif ischar(x)
                y = W_basic.extend_char(x, n, varargin(:));
            elseif isstring(x)
                y = W_basic.extend_str(x, n, varargin{:});
            elseif (~istable(x)) && size(unique(x','rows'),1) == 1 % if all the columns are the same
                % warning('extend: check, not sure what will trigger this condition (old codes)')
                % this is for datetimes (potential others as well)
                y = repmat(unique(x','rows'), n,1)';
            else
                warning('extend: unrecognized format');
                y = x;
            end
        end
        function y = extend_strings(x, n, varargin)
            x = string(x);
            y = arrayfun(@(t)string(W_basic.extend_char(char(t), n, varargin{:})), x);
        end
        %% string
        function out = string(x)
            if isnumeric(x)
                out = string(arrayfun(@(t)num2str(t), x, 'UniformOutput', false));
            else
                out = string(x);
            end
        end
        function out = str2cell(str)
            out = W.arrayfun(@(x){x}, str);
        end
        function out = str_de_(str, opt_str)
            if ~exist('opt_str') || isempty(opt_str)
                opt_str = ' ';
            end
            out = replace(str, '_', opt_str);
        end
        function [out, idxselect] = str_select(str, option)
            % options in isstrprop
            if ~exist('option') || isempty(option)
                option = 'digit';
            end
            option = char(option);
            if contains(option, '!')
                option = option(2:end);
                opt_rev = 1;
            else
                opt_rev = 0;
            end
            str = W_basic.decell(str);
            str = char(str);
            idxselect = isstrprop(str, option);
            if opt_rev == 1
                option = 'rev';
                idxselect = ~idxselect;
            end
            if ~any(idxselect, 'all')
                if strcmp(option, 'digit')
                    out = NaN;
                else
                    out = '';
                end
            else
                tidxnum = find(idxselect);
                tword = [0 find(diff(tidxnum) > 1) length(tidxnum)] + 1;
                for i = 1:(length(tword)-1)
                    if strcmp(option, 'digit')
                        out(i) = str2num(str(tidxnum(tword(i):tword(i+1)-1)));
                    else
                        out{i} = str(tidxnum(tword(i):tword(i+1)-1));
                    end
                end
            end
            out = W_basic.decell(out);
        end
        function out = str_selectbetween2pattern(str, spre, spost, npre, npost)
            if ~exist('npre') || isempty(npre)
                npre = 1;
            end
            if ~exist('npost') || isempty(npost)
                npost = 1;
            end
            str = char(str);
            if isempty(spre)
                n1 = 1;
            else
                idxpre = strfind(str, spre);
                n1 = idxpre(npre) + length(spre);
            end
            if isempty(spost)
                n2 = length(str);
            else
                idxpost = strfind(str, spost);
                n2 = idxpost(npost) - 1;
            end
            out = string(str(n1:n2));
        end
        function out = str_csv2cell(strs, sep)
            % strings separated by sep = ',' put into cell arrays
            if ~exist('sep') || isempty(sep)
                sep = ',';
            end
            strs = string(strs);
            out = arrayfun(@(x)strsplit(x, sep), strs, 'UniformOutput', false);
            LEN = max(cellfun(@(x)length(x), out));
            out = cellfun(@(x)W_basic.extend_str(x, LEN), out, 'UniformOutput', false);
            out = vertcat(out{:});
        end
        %% unique
        function [out] = unique(x, varargin)
            if isnumeric(x)
                if length(varargin) > 0 && isnumeric(varargin{1})
                    [out] = W_basic.unique_nan(x, varargin{1}, varargin{2:end});
                else
                    [out] = W_basic.unique_nan(x, 0, varargin{:}); % skip multiple NaNs
                end
            elseif iscell(x)
                [out] = W_basic.unique_cell(x, varargin{:});
            else
                [out] = unique(x, varargin{:});
            end
        end
        function [out] = unique_cell(x, varargin)
            x = W_basic.encell(x);
            idchar = cellfun(@(t)ischar(t) || isstring(t), x);
            if ~(all(idchar, 'all'))
                warning('unique_cell: some cells are not character/string variables, ignored');
            end
            x = x(idchar);
            lenx = cellfun(@(t)length(string(t)), x);
            if ~(all(lenx == 1, 'all'))
                warning('unique_cell: some cells are character/string arrays, ignored');
            end
            if iscell(x) % rows option is not available for cells
                varargin = setdiff(varargin,'rows');
            end
            x = x(lenx == 1);
            [out, id] = unique(x, varargin{:});
        end
        function [out] = unique_nan(x, optionNaN, varargin)
            if ~exist('optionNaN') || isempty(optionNaN)
                optionNaN = 1; % includes a single NaN
            end
            ma = max(x, [],'all')+1;
            x = W_basic.nan_changem(x, ma);
            [x, id] = unique(x, varargin{:});
            x = changem(x, NaN, ma);
            if optionNaN == 0
                x = x(~all(isnan(x),2),:);
            end
            out = x;
            if isempty(out) % never return []
                out = NaN(1, size(x, 2));
                id = zeros(1, size(x, 2));
            end
        end
        %% assist
        function [out, fnms] = fieldsize(d, fnms, idx)
            if ~exist('idx')
                idx = 1:2;
            end
            fnms0 = fieldnames(d);
            fnms0 = setdiff(fnms0, {'Row','Properties','Variables'});
            if ~exist('fnms') || isempty(fnms)
                fnms = fnms0;
            end
            tfnms = intersect(fnms, fnms0, 'stable');
            out0 = W_basic.encell(W_basic.cellfun(@(x)size(d.(x)), tfnms));
            mz = max(cellfun(@(x)length(x), out0));
            tt = cellfun(@(x)W_basic.extend_nan(x, mz), out0, 'UniformOutput', false);
            tt = vertcat(tt{:});
            tt = tt(:, idx);
            out = NaN(length(fnms), size(tt,2));
            idx = cellfun(@(x)find(strcmp(x, fnms)), tfnms);
            out(idx,:) = tt;
        end
    end
end
classdef W_tools < handle
    properties
    end
    methods(Static)
        %% basic
        function [av, se, n] = avse(a)
            if islogical(a)
                a = a + 0;
            end
            if size(a, 1) == 1
                av = a;
                n = 1 - (isnan(a));
                se = NaN(size(a,1), size(a,2));
            else
                n = sum(~isnan(a));
                av = nanmean(a);
                se = nanstd(a)./sqrt(n);
            end
        end
        function [av, sd, n] = avsd(a)
            if islogical(a)
                a = a + 0;
            end
            if size(a, 1) == 1
                av = a;
                n = 1 - (isnan(a));
                sd = NaN(size(a,1), size(a,2));
            else
                n = sum(~isnan(a));
                av = nanmean(a);
                sd = nanstd(a);
            end
        end
        function [b, x] = derepeat(a)
            c = 0;
            for i = 1:length(a)
                if i == 1 || a(i) ~= a(i-1)
                    c = c+ 1;
                    b(c) = a(i);
                    x{c} = i;
                else
                    x{c} = [x{c} i];
                end
            end
        end
        %% stat
        function out = getstatstars(p0, nons, option)
            if ~exist('option') || isempty(option)
                option = 'stars';%value
            end
            if ~exist('nons') || isempty(nons) || isnan(nons)
                nons = ' ';%'n.s.';
            end
            for i = 1:size(p0,1)
                for j = 1:size(p0,2)
                    p = p0(i,j);
                    if p<=1E-3
                        stars='***';
                    elseif p<=1E-2
                        stars='**';
                    elseif p<=0.05
                        stars='*';
                    elseif p <= 0.1
                        stars = ' ';%'+';
                    elseif p > 0.1
                        %                 if isempty(nons)
                        %                     stars = sprintf('%.2f', p);
                        %                 else
                        stars = nons;
                        %                 end
                    elseif isnan(p)
                        stars = ' ';%'n.a.';
                    else
                        stars=' ';
                    end
                    if strcmp(option, 'value')
                        out{i,j} = sprintf('%.3f', p);
                    else
                        out{i,j} = stars;
                    end
                end
            end
        end
        %% interval(more bins)
        function [idx] = find_interval(itvs, val, opt_equal)
            if ~exist('opt_equal') || isempty(opt_equal)
                opt_equal = [1 1];
            end
            if opt_equal(1)
                id1 = itvs(:,1) <= val;
            else
                id1 = itvs(:,1) < val;
            end
            if opt_equal(2)
                id2 = val <= itvs(:,2);
            else
                id2 = val < itvs(:,2);
            end
            idx = W_basic.extend(find(id1 & id2));
        end
        function [idx] = find_intervals(itvs, vals, varargin)
            if iscell(vals)
                idx = W_basic.cellfun(@(x)W_tools.find_interval(itvs, x, varargin{:}), vals);
            else
                idx = W_basic.arrayfun(@(x)W_tools.find_interval(itvs, x, varargin{:}), vals);
            end
        end
        %% consecutives
        function y = get_consecutives(x)
            vs = unique(x);
            y = [];
            for vi = 1:length(vs)
                ty = W_tools.get_consecutive0(x ~= vs(vi));
                ty = W_basic.tab_fill(ty, 'label', vs(vi));
                y = vertcat(y, ty);
            end
            y = sortrows(y,2);
        end
        function out = get_consecutive0(x)
            out = table;
            trow = find(x==0);
            if isempty(trow)
                out.start = NaN;
                out.end = NaN;
                out.duration = NaN;
            else
                tjump = find(diff(trow) > 1);
                tstart = [0; tjump] + 1;
                out.duration = diff([tstart; length(trow)+1]);
                out.start = trow(tstart);
                out.end = out.start + out.duration -1;
            end
        end
        %% intervals
        function out = join_intervals(itvs, dist)
            % ex. join_intervals([1 2; 10 14], 10) = [1 14]
            % pool intervals that are dist away from each other to a single
            % interval
            td = itvs(2:end, 1) - itvs(1:end-1,2);
            td = find(td < dist);
            xr = reshape(itvs', [],1);
            xr([td*2 td*2+1]) = NaN;
            xr = xr(~isnan(xr));
            out = reshape(xr, 2,[])';
        end
        %% bin
        function out = slidingwindow(y, x, at, bin)
            if ~exist('x') || isempty(x)
                x = 1:length(y);
            end
            if ~exist('at') || isempty(at)
                at = 1:length(y);
            end
            at = W.vert(at);
            bin = W.horz(bin);
            if size(bin,1) == 1
                bin = bin + at;
            end
            out = W.bin_mean(y, x, bin);
        end
        function out = bin_middle(bin)
            bin = W_tools.bin_1to2(bin);
            out = mean(bin')';
        end
        function bin = bin_1to2(bin)
            if size(bin,1) > 1 && size(bin,2) > 1
                return;
            end
            bin = horzcat(W_basic.vert(bin(1:end-1)), W_basic.vert(bin(2:end)));
        end
        function [av, se, num] = bin_mean(y,x,bins)
            % only works for 1-D y and x
            if ~exist('x') || isempty(x)
                x = 1:length(y);
            end
            y = W_basic.vert(y);
            bins = W.horz(bins);
            if size(bins,1) == 1
                bins = W_tools.bin_1to2(bins);
            end
            for bi = 1:size(bins,1)
                idx = x >= bins(bi,1) & x < bins(bi,2);
                if ~any(idx)
                    num(bi) = 0;
                    av(bi) = NaN;
                    se(bi) = NaN;
                else
                    [av(bi), se(bi), num(bi)] = W_tools.avse(y(idx));
                end
            end
        end
        function [av, se, num] = bin_mean_byrow(ys, xs, bins)
            xs = W.horz(xs);
            ys = W.horz(ys);
            xs = repmat(xs, round(size(ys,1)/size(xs, 1)), 1);
            for xi = 1:size(xs, 1)
                [av(xi,:), se(xi,:), num(xi,:)] = W_tools.bin_mean(ys(xi,:), xs(xi,:), bins);
            end
        end
        function [av, se, num] = bin_mean_all(ys, xs, bins)
            xs = W.horz(xs);
            ys = W.horz(ys);
            xs = repmat(xs, size(ys,1)/size(xs, 1), 1);
            y = reshape(ys, [], 1);
            x = reshape(xs, [], 1);
            [av, se, num] = W_tools.bin_mean(y, x, bins);
        end
        function [av, se, num] = bin_mean_option(ys, xs, bins, option)
            if option == "byrow"
                 [av, se, num] = W_tools.bin_mean_byrow(ys, xs, bins);
            elseif option == "all"
                 [av, se, num] = W_tools.bin_mean_all(ys, xs, bins);
            end
        end
        %% analysis
%         function out = analysis_slidingwindow(tab, fns, x, at, bin, varargin)
%             at = W.vert(at);
%             bin = W.horz(bin);
%             bin = bin + at;
%             out = W_tools.analysis_bincurve(tab, fns, x, bin, varargin{:});
%         end
        function out = analysis_av(tab, varargin)
            if istable(tab)
                fns = W.encell(varargin{1});
                for fi = 1:length(fns)
                    [out.(['av_' fns{fi}]), out.(['se_' fns{fi}])] = W.avse(tab.(fns{fi}));
                end
            else                
                [out.(['av']), out.(['se'])] = W.avse(tab);
            end
        end    
        function out = analysis_av_bygroup(gp, gps, tab, varargin)
            if ischar(gp)
                gp = tab.(gp);
            end
            gp = W.string(gp);
            if ~exist('gps') || isempty(gps)
                gps = W.unique(gp);
            end
            gps = W.string(gps);
            out = table;
            for ti = 1:length(gps)
                td = tab(gp == gps(ti), :);
                te = W.analysis_av(td, varargin{:});
                te = struct2table(te);
                out = vertcat(out, te);
            end
            out.(['id_group']) = W.vert(gps);
            out = W.table2struct(out);
            out = W.struct_name_pfxsfx(out, 'gp_', '');
            out = W.struct_flat(out);
        end
        function out = analysis_bincurve(tab, fns, x, bin, opt_binmean, newfns)
            if isempty(tab)
                out = [];
                return;
            end
            if ~exist('opt_binmean')
                error('specify opt_binmean');
            end
            fns = W_basic.encell(fns);
            te = cellfun(@(x)tab.(x), fns, 'UniformOutput', false);
            te = W.cellfun(@(x)W.horz(x), te);
            nM = max(cellfun(@(x)size(x,2), te));
            te = cellfun(@(x)W_basic.extend_nan(x, nM), te,'UniformOutput', false);
            if ~exist('x') || isempty(x)
                x = 1:nM;
            end
            if ischar(x)
                x = tab.(x);
            end
            if ~exist('bin') || isempty(bin)
                bin = [min(x) - mean(diff(x))/2 : mean(diff(x)): max(x) + mean(diff(x))/2];
            end
            if ~exist('newfns') || isempty(newfns)
                newfns = strcat('bin_', opt_binmean, '_', fns);
            end
            te = cellfun(@(t)W_tools.bin_mean_option(t, x, bin, opt_binmean), te, 'UniformOutput', false);
            for fi = 1:length(fns)
                out.(newfns{fi}) = te{fi};
            end
        end
        function out = analysis_bincurve_bygroup(gp, gps, tab, varargin)
            if ischar(gp)
                gp = tab.(gp);
            end
            gp = W.string(gp);
            if ~exist('gps') || isempty(gps)
                gps = W.unique(gp);
            end
            gps = string(gps);
            out = table;
            for ti = 1:length(gps)
                td = tab(gp == gps(ti), :);
%                 try
                te = W.analysis_bincurve(td, varargin{:});
                te = struct2table(te);
                out = vertcat(out, te);
%                 catch
%                     disp('error in analysis_bincurve');
%                 end
            end
            out.(['bin_group']) = W.vert(gps);
            out = W.table2struct(out);
            out = W.struct_name_pfxsfx(out, 'gp_', '');
            out = W.struct_flat(out);
        end
    end
end
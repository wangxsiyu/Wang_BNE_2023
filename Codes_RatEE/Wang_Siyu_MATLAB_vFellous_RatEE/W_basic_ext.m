classdef W_basic_ext < W_basic
    properties
    end
    methods(Static)
        %% iif
        function out = iif_empty(x, a)
            out = W_basic.iif(isempty(x), a, x);
        end
        %% col fun
        function out = funccol(fcn, x, varargin)
            fcn = str2func(fcn);
            if size(x,1) <= 1
                out = x;
            else
                out = {};
                for i = 1:size(x,2)
                    out{i} = fcn(x(:,i), varargin{:});
                end
                out = W_basic.cellfun(@(x)x, out);
            end
        end
        function out = unique_col(x, varargin) % unique for each col
            out = W_basic_ext.funccol('W_basic.unique', x, varargin{:});
        end     
        function out = nan_squeeze_col(tt)
             idx = ~W_basic_ext.funccol('all', isnan(tt));
             idx = 1:max(1,sum(cumsum(idx(end:-1:1))>0)); % if all NaNs, then keep 1 column
             out = tt(:,idx);
        end
        function out = cell_squeeze_col(tt)
            idx = ~W_basic_ext.funccol('all', cellfun(@(x)isempty(x),tt));
            idx = 1:max(1,sum(cumsum(idx(end:-1:1))>0));
            out = tt(:,idx);
        end
        %% s 
        % strs
        function [out] = strs_select(strs, varargin)
            strs = string(strs);
            out = W_basic.arrayfun(@(x)W_basic.str_select(x, varargin{:}), strs);
        end
        function out = strs_selectbetween2pattern(strs, varargin)
            strs = string(strs);
            out = W.arrayfun(@(x)W_basic.str_selectbetween2pattern(x, varargin{:}), strs);
        end
        % NaNs
        function out = nan_selects(a, varargin)
            id = [varargin{:}];
            out = arrayfun(@(x)W_basic.nan_select(a, x), id);
        end
    end
end
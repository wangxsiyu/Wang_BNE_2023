classdef W_plt_JAGS < handle
    properties
    end
    methods(Static)
        function [out, tm] = density(var, bin)
            sz = size(var);
            if length(sz) == 3
                tv = [];
                for i = 1:sz(3)
                    tv = reshape(var(:,:,i), 1, []);
                    [ty, tm] = hist(tv', bin);
                    out{i,1} = ty ./sum(ty) ./mean(diff(tm));
                end
                out = vertcat(out{:});
            elseif length(sz) == 4
                tv = [];
                for i = 1:sz(3)
                    for j = 1:sz(4)
                        tv = reshape(var(:,:,i, j), 1, []);
                        [ty, tm] = hist(tv', bin);
                        tout{i,j} = ty ./sum(ty) ./mean(diff(tm));
                    end
                    out{i} = vertcat(tout{i,:});
                end
            else
                tv = reshape(var, 1, []);
                [ty, tm] = hist(tv', bin);
                out = ty ./sum(ty) ./mean(diff(tm));
            end
        end
    end
end
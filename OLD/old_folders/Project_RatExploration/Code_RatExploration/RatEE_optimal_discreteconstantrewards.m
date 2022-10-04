function [thetas, as, dEV] = RatEE_optimal_discreteconstantrewards(rs, ps, Hs, probs, nRRGuided)
    % nRRGuided - if not empty, then rewards gained during the guided trials count towards
    % reward rate.
    if ~exist('probs') || isempty(probs)
        probs = ones(1, length(rs));
    end
    if ~exist('nRRGuided') || isempty(nRRGuided)
        nRRGuided = 0;
    end
    nr = length(rs);
    for hi = 1:length(Hs)
        h = Hs(hi);
        tdEV = NaN(1, nr);
        for ai = 1:nr
            tr = rs - rs(ai);
            tp = ps(ai,:);
            tdEV(ai) = sum(tp(ai:nr) .*tr(ai:nr)) * h + sum(tp(1:ai).* tr(1:ai));
        end
        dEV(hi,:) = tdEV/(h + nRRGuided);
        as(hi) = min(find([tdEV -Inf] < 0));
    end
    rs_ext = [rs -Inf];
    thetas = arrayfun(@(x)rs_ext(x), as);
end
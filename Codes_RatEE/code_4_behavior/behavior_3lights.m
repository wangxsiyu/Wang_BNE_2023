function out = behavior_3lights(g)
    % assume constant n_guided and n_free
    ng = unique(g.n_guided);
    out.pnv = mean(ismember(g.c(:,ng+1) ,[3 7]));
end
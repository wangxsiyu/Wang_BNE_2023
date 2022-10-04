function g = func_cond_drop(g)
    unq = W.unique(sort(g.drop,2),'rows');
    if size(unq,1) == 1
        vv = arrayfun(@(x)num2str(x), unq);
    else
        vv = arrayfun(@(x)num2str(x), sort(W.horz(W.unique(unq))));
    end
    g = W.tab_fill(g, 'cond_drop', vv);
%     vv = g.cond_drop;
end
function y = ff(x)
    if iscell(x)
        y = vertcat(x{:});
    else
        y = x;
    end
    if size(y,2) > 15
        y = y(:,1:15);
    end
end
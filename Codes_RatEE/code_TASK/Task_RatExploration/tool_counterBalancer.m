function [var, T, N] = tool_counterBalancer(var, nrep, option_nrep)
    % this is a copy of version 06-06-2020

    % [var, T, N] = tool_counterBalancer(var, nrep, option_nrep)
    % nrep: number of repeats
    % option_nrep: 1 to randomize var for nrep separate sets
    %              0 to randomize nrep sets of var for 1 combined set
    %
    % var(i).x    = values of variable i to be considered
    % var(i).type = 1 - fully counterbalance
    %             = 2 - random counterbalance
    %             = 3 - alternate (repeat in the order specified)
    % NOTE : THIS DOES NOT YET HANDLE MULTIDIMENSIONAL VARIABLES
    %
    % adapted from Robert Wilson's code by Siyu Wang
    % 06-06-2020
    %
    % example inputs
    % R = 2;
    %
    % var(1).x = [1 2 3 4 5];
    % var(1).type = 1;
    %
    % var(2).x = [1 2 3 4 5 6 7];
    % var(2).type = 2;
    %
    % var(3).x = [7 8 9];
    % var(3).type = 1;
    if ~exist('option_nrep') || isempty(option_nrep)
        option_nrep = 0;
    end
    % get type 1 variables to fully counterbalance over
    ind1 = find([var.type] == 1);
    for i = 1:length(ind1)
        L(i) = length(var(ind1(i)).x);
    end
    % total number of trials per cycle
    N = prod(L);
    T = N*nrep;
    % counterbalance all type 1 variables - this could probably be more elegant!
    str = 'ndgrid(';
    k = length(ind1);
    for i = 1:k
        str = [str 'var(ind1(' num2str(i) ')).x'];
        if i < k
            str = [str ', '];
        else
            str = [str ');'];
        end
    end
    str2 = '[';
    for i = 1:k
        str2 = [str2 'cb{' num2str(i) '}'];
        if i < k
            str2 = [str2, ', '];
        else
            str2 = [str2 ']'];
        end
    end
    str3 = [str2 ' = ' str];
    eval(str3);
    
    for i = 1:k
        var(ind1(i)).x_cb = repmat(cb{i}(:)', 1, nrep);
    end
    
    if option_nrep == 1
        r = [];
        for repi = 1:nrep
            r = [r (repi-1)*N+randperm(N)];
        end
    else
        r = randperm(T);
    end
    
    for i = 1:k
        var(ind1(i)).x_cb = var(ind1(i)).x_cb(r);
    end
    
    % randomly mix up all type 2 variables
    ind2 = find([var.type] == 2);
    for i = 1:length(ind2)
        if option_nrep == 1
            var(ind2(i)).x_cb = [];
            for repi = 1:nrep % sample type 2 variables for every repeat separately
                te_rep = repmat(var(ind2(i)).x, ...
                    [1 ceil(N/length( var(ind2(i)).x ))]);
                r = randperm(length(te_rep));
                var(ind2(i)).x_cb = [var(ind2(i)).x_cb te_rep(r(1:N))];
            end
        else
            te_rep = repmat(var(ind2(i)).x, ...
                [1 ceil(T/length( var(ind2(i)).x ))]);
            r = randperm(length(te_rep));
            var(ind2(i)).x_cb = [te_rep(r(1:T))];
        end
    end
    
    % alternate all type 3 variables
    ind3 = find([var.type] == 3);
    for i = 1:length(ind3)
        te_rep = repmat(var(ind3(i)).x, ...
            [1 ceil(T/length( var(ind3(i)).x ))]);
        var(ind3(i)).x_cb = te_rep(1:T);
    end
end
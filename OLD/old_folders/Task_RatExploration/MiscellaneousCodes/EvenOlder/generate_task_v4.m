function generate_task_v4(Nrep, Nguided, Nfree, T, rlist, hb, folder)
    if ~exist('folder')
        folder = './';
    end
    rand('seed', sum(clock()));
    outputfile = strcat('taskset_drop_alternation_', datestr(now,30));
    fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    rlist = repmat(rlist, Nrep,1);
    nr = size(rlist, 1);
    hblist = repmat(reshape(hb,[],1), nr, 1);
    hblist = hblist(1:nr);
    idxrd = randperm(length(hblist));
    rlist = rlist(idxrd,:);
    tod = [ones(1,Nguided),zeros(1,Nguided)]+1;
    for i = 1:nr
        te = tod(randperm(length(tod)));
        while any(te * [32 16 8 4 2 1]' == [7 56])
            te = tod(randperm(length(tod)));
        end    
        odlist(i,:) = te;
    end
    for i = 1:nr
        thb = hblist(i);
        tfd = findbandit(thb);
        tr = rlist(i,:);
        tod = odlist(i,:);
        for hi = 1:Nguided*2
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(tod(hi)), T, tr(tod(hi)));
        end
        for hi = 1:Nfree
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(1), tfd(2), T, tr(1), tr(2));
        end
    end
    fclose(fileID);
    str = 'file generation complete';
    disp(str);
    disp(sprintf('total runs = %d', nr*(Nguided*2 + Nfree)*2));
end
function y = findbandit(x)
    y(1) = x + 3;
    y(2) = x - 3;
    y = mod(y,8);
    y(y == 0) = 8;
    y = y(randperm(2));
end
function y = getreward(levels)
    tl = levels(randperm(length(levels)));
    y = tl(1:2);
end
function y = getrlist(x)
    y = [];
    for i = 1:length(x)-1
        for j = i+1:length(x)
            y(end+1,:) = [x(i), x(j)];
        end
    end
end
function generate_task_pretraining_ambiguity(Nguided, Nfree, T, rlist, hb, folder)
    if ~exist('folder')
        folder = './';
    end
    rand('seed', sum(clock()));
    outputfile = strcat('taskset_pretraining_ambiguity_', datestr(now,30));
    fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    hb = hb(randperm(length(hb)));
    nr = size(rlist, 1);
    hblist = repmat(reshape(hb,[],1), nr, 1);
    trlist(1:2:(2*nr-1),:) = rlist(randperm(nr),:);
    trlist(2:2:(2*nr),:) = rlist(randperm(nr),:);
    rlist = trlist;
    fdlist = findbandit(hb(1));
    fdlist = repmat([fdlist; fdlist([2 1])], nr, 1); fdlist = fdlist(1:nr,:);
    tfdlist(1:2:(2*nr-1),:) = fdlist(randperm(nr),:);
    fdlist = findbandit(hb(2));
    fdlist = repmat([fdlist; fdlist([2 1])], nr, 1); fdlist = fdlist(1:nr,:);
    tfdlist(2:2:(2*nr),:) = fdlist(randperm(nr),:);
    fdlist = tfdlist;
    tod = [ones(1,Nguided),zeros(1,Nguided)]+1;
    ng = nr*2;
    for i = 1:ng
        te = tod(randperm(length(tod)));
        odlist(i,:) = te;
    end
    for i = 1:ng
        thb = hblist(i);
        tfd = fdlist(i,:);
        tr = rlist(i,:);
        tod = odlist(i,:);
        for hi = 1:Nguided
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(1), T, tr(1));
        end
        for hi = 1:Nfree
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
            fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(1), tfd(2), T, tr(1), tr(2));
        end
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
    str = 'file generation complete - pretraining ambiguity';
    disp(str);
    disp(sprintf('total runs = %d', ng*(Nguided*3 + Nfree*2)*2));
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
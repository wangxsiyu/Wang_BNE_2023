function generate_task(Ngame, Nguided, Nfree, T, hb, folder)
    if ~exist('folder')
        folder = './';
    end
    if ~exist('phb')
        phb = 1;
    end
    rand('seed', sum(clock()));
    outputfile = strcat('taskset_', datestr(now,30));
    fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    fd{1} = findbandit(hb(1));
    fd{2} = findbandit(hb(2));
    fdi = ceil(rand*2);
    rlist = [1 0; 2 0; 1 2; 2 1; 1 3; 3 1; 2 3];
    nr = size(rlist, 1);
    ri = ceil(rand(Ngame,1) * nr);
    r = rlist(ri,:);
    for i = 1:Ngame
        ris = [ones(floor(Nguided/2),1); ones(ceil(Nguided/2),1)*2];
        nr = length(ris);
        rrr = randperm(nr);
        ris = ris(rrr);    
        fdi = 3-fdi;
        mnow = ceil(rand*2);
        d(mnow) = r(i,1);
        d(3 - mnow) = r(i,2);
        for hi = 1:Nguided
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', hb(fdi), T);
            ri = ris(hi);
            fprintf(fileID,'%d\t%d\t1\t0\t%d\n', fd{fdi}(ri), T, d(ri));
        end
        for hi = 1:Nfree
            fprintf(fileID,'%d\t%d\t0\t0\t1\n', hb(fdi), T);
            fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', fd{fdi}(mnow), fd{fdi}(3-mnow), T, d(mnow), d(3-mnow));
        end
    end
    fclose(fileID);
    str = 'file generation complete';
    disp(str);
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
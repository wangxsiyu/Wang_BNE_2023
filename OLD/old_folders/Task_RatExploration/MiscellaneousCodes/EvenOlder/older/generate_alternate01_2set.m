function generate_alternate01_2set(Ngame, Nguided, Nfree, Tguided, Tfree, hb, folder)
    if ~exist('folder')
        folder = './';
    end
    rand('seed', sum(clock()));
    outputfile = strcat('taskset_alternate01_2set_', datestr(now,30));
    fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
    fprintf(fileID, '1\t1\t0\n');
    fd{1} = findbandit(hb(1));
    fd{2} = findbandit(hb(2));
    fdi = ceil(rand*2);
    mnow{1} = ceil(rand*2);
    mnow{2} = ceil(rand*2);
    for i = 1:Ngame
        ris = [ones(floor(Nguided/2),1); ones(ceil(Nguided/2),1)*2];
        nr = length(ris);
        rrr = randperm(nr);
        ris = ris(rrr);      
        fdi = 3-fdi;
        for hi = 1:Nguided
            fprintf(fileID,'%d\t%d\t1\t0\t1\n', hb(fdi), Tguided);
            ri = ris(hi);
            fprintf(fileID,'%d\t%d\t1\t0\t1\n', fd{fdi}(ri), Tguided);
        end
        mnow{fdi} = 3 - mnow{fdi};
        for hi = 1:Nfree
            fprintf(fileID,'%d\t%d\t1\t0\t1\n', hb(fdi), Tguided);
            fprintf(fileID,'%d%d\t%d\t1\t0\t20\n', fd{fdi}(mnow{fdi}), fd{fdi}(3-mnow{fdi}), Tfree);
        end
    end
    fclose(fileID);
    str = 'file generation complete - alternation 01 2set';
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
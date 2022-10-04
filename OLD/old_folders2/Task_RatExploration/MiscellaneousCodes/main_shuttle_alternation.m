folder = 'U:\Data1\SiyuTaskfiles';
outputfile = strcat('taskset_shuttle_alternation');
fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
fprintf(fileID, '1\t1\t0\n');
ng = 20;
nB = 10;
T = 130;
rand('seed', sum(clock()));
if rand < 0.5 
    pair = [4, 8];
    pair0 = [2, 6];
else
    pair = [2, 6];
    pair0 = [4, 8];
end
for bi = 1:nB
    x0 = 0; x = 0;
    for i = 1:ng
        while (x == x0)
            x = ceil(rand*2);
        end
        x0 = x;
        fprintf(fileID,'%d\t%d\t1\t0\t%d\n',  pair(x0), T, 1);
    end
    y = pair;
    pair = pair0;
    pair0 = y;
end
 fclose(fileID);
 str = 'file generation complete - shuttle';
 disp(str);
 disp(sprintf('total runs = %d', ng));
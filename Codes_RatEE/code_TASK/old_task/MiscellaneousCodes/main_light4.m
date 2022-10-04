function main_light4(ng, T, folder, rndsd, ratname)
outputfile = strcat(ratname, '_', 'random_',num2str(rndsd));
fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
fprintf(fileID, '1\t1\t0\n');
    fprintf(fileID,'%d\t%d\t0\t0\t1\n', 7, 0);

rand('seed', sum(clock()));
pair = [2, 4, 6, 8];
x0 = 0; x = 0;
for i = 1:ng
    while (x == x0)
        x = ceil(rand*4);
    end
    x0 = x;
    fprintf(fileID,'%d\t%d\t1\t0\t%d\n',  pair(x0), T, 1);
end
 fclose(fileID);
%  str = 'file generation complete - light 4';
%  disp(str);
%  disp(sprintf('total runs = %d', ng));
end
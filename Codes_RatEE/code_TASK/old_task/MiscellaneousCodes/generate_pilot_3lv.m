function generate_pilot_3lv(Nguided, Nfree, T, rlist, hbs, R, folder)
  rand('seed', sum(clock()));
  if ~exist('folder')
        folder = './';
    end
outputfile = strcat('taskset_pilot3lv_', datestr(now,30));
fileID = fopen(fullfile(folder, [outputfile, '.txt']),'w');
fprintf(fileID, '1\t1\t0\n');
if ~exist('hbs')
    hbs = [1 5];
end
fds = [4 6; 8 2];
var(1).x = rlist;
var(1).type = 2;
var(2).x = [1:(length(rlist)-1)]; % is explore side higher
var(2).type = 1;
var(3).x = [1 2]; % which side is to exploit
var(3).type = 1;
[g1 N] = TASK_counterBalancer(var, R);
[g2 N] = TASK_counterBalancer(var, R);
hbi(1:2:(2*N-1)) = ceil(rand * 2);
hbi(2:2:(2*N)) = 3 - hbi(1:2:(2*N-1));
Rexploit(1:2:(2*N-1)) = g1(1).x_cb;
RexploreI(1:2:(2*N-1)) = g1(2).x_cb;
FDexploit(1:2:(2*N-1)) = g1(3).x_cb;
Rexploit(2:2:(2*N)) = g2(1).x_cb;
RexploreI(2:2:(2*N)) = g2(2).x_cb;
FDexploit(2:2:(2*N)) = g2(3).x_cb;
for i = 1:(2*N)
    r_rest = var(1).x;
    r_rest(r_rest == Rexploit(i)) = [];
    Rexplore(i) = r_rest(RexploreI(i));
    hb(i) = hbs(hbi(i));
    fd(i,:) = fds(hbi(i), [FDexploit(i) 3-FDexploit(i)]);
end
game = [hb', fd Rexploit', Rexplore'];
ng = size(game,1);
for i = 1:ng
    thb = game(i,1);
    tfd = game(i,2:3);
    tr = game(i,4:5);
    for hi = 1:Nguided
        fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
        fprintf(fileID,'%d\t%d\t1\t0\t%d\n', tfd(1), T, tr(1));
    end
    for hi = 1:Nfree
        fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
        fprintf(fileID,'%d%d\t%d\t1\t0\t%d%d\n', tfd(1), tfd(2), T, tr(1), tr(2));
    end
    fprintf(fileID,'%d\t%d\t0\t0\t1\n', thb, T);
 end
 fclose(fileID);
 str = 'file generation complete - pilot cb';
 disp(str);
 disp(sprintf('total runs = %d', ng*(Nguided + Nfree)*2));

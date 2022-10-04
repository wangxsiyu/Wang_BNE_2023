data = importdata('dataEXT_UnityITC.mat');
rots = cellfun(@(x)quat2eul(x,'XYZ')/pi  * 180, data.rot, 'UniformOutput', false);
%%
clf;
subplot(2,1,1);
plot([-5 -5], [0 50],'k');
hold on;
plot([5 5], [0 50],'k');

hold on;
plot([-5 -5-50*sqrt(3)], [0 -50],'k');
hold on;
plot([0 -50*sqrt(3)], -5*sqrt(3) + [0 -50],'k');


hold on;
plot([5 5+50*sqrt(3)], [0 -50],'k');
hold on;
plot([0 50*sqrt(3)], -5*sqrt(3) + [0 -50],'k');

xlabel('x');
ylabel('y');
title('Example trial');

xlim([-100 100]);
ylim([-60 55]);
set(gca, 'FontSize', 20);

ms = 3;
for ti = 17
    rot = rots{ti};
    traj = data.pos{ti};
    nt = size(traj,1);
    tdis = arrayfun(@(x) sum((traj(x,:)- traj(x+1,:)).^2),  1:(nt-1));
    idcont = tdis < 100;
    if sum(idcont == 0) > 0
        traj = traj(1:find(idcont == 0),:);
        rot = rot(1:find(idcont == 0),:);
    end
    
    subplot(2,1,1);
    hold on;
    id1 = 1:65;
    id2 = (id1(end)+1):133;
    id3 = (id2(end)+1):244;
    plot(traj(id1,1)+ rand(length(id1),1)*0.05, traj(id1,3)+ rand(length(id1),1)*0.05,'.k','MarkerSize', ms);
    plot(traj(id2,1)+ rand(length(id2),1)*0.05, traj(id2,3)+ rand(length(id2),1)*0.05 ,'.r','MarkerSize', ms);
    plot(traj(id3,1)+ rand(length(id3),1)*0.05, traj(id3,3)+ rand(length(id3),1)*0.05,'.b','MarkerSize', ms);
    subplot(2,1,2);
    hold on;
%     plot(traj(:,1), '.', 'MarkerSize',10);
    plot(-rot(id1,2), -0.03*id1,  '.k','MarkerSize', ms);
    plot(-rot(id2,2), -0.03*id2,  '.r','MarkerSize', ms);
    plot(-rot(id3,2), -0.03*id3,  '.b','MarkerSize', ms);
end
set(gca, 'YTick', [-8:2:0], 'YTickLabel', [8:-2:0]);
set(gca, 'FontSize', 20, 'XTick', [-60 0 60]);
xlim([-90 90])
ylabel('time (s)');
xlabel('looking angle (degrees)');
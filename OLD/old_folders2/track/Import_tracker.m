datadir = '/Volumes/WangSiyu/Lab_Wilson/Data/Data_Raw/UnityITC_data';
beh = readtable('data_UnityITC.csv');
files = dir(datadir);
files = files(arrayfun(@(x)length(str2num(x.name))>0, files));
tab = [];
for fi = 1:length(files)
    tic
    disp(sprintf('importing sub %d/%d', fi, length(files)));
    datasub = [];
    filename = fullfile(files(fi).folder, files(fi).name, [files(fi).name '.txt']);
    tdata = importdata(filename,'\n');
    tdatetime = tdata{1};
    tsubID = sscanf(tdata{2},'SubjectID: %d');
    ridsub = find(beh.subjectID == tsubID);
    if length(ridsub) == 0
        continue;
    end
    tdata = tdata(3:end);
    for ti = 1:size(tdata,1)
        ts =  tdata{ti};
        datasub(ti).subjectID = tsubID;
        td = textscan(ts,'%s %s %s    Pos = (%f, %f, %f),    Rotation = (%f, %f, %f, %f),    Camera Pos = (%f, %f, %f),    Camera Rotation = (%f, %f, %f, %f)');
        datasub(ti).timestamp = datestr(strcat(td{1}, {' '},td{2}, {' '},td{3}{1}(1:end-1)), 30);
        datasub(ti).pos = [td{4:6}];
        datasub(ti).rot = [td{7:10}];
        datasub(ti).campos = [td{11:13}];
        datasub(ti).camrot = [td{14:17}];
    end
    ttab = struct2table(datasub);
    tds = sum((ttab.pos - [0 5 48]).^2,2);
    stid = [1;1+find(diff(tds) < -10000); size(ttab,1)+1];
    for tti = 10
        hold on;
        ttpos = ttab.pos(stid(tti):(stid(tti+1)-1),:);
        plot(ttpos(:,1), ttpos(:,3));
    end
%     tms = ttab.timestamp;
%     tms = cellfun(@(x)str2num(x(10:15)),  tms);
    disp(sprintf('compare: %d, %d', size(ridsub,1), length(stid)-1));
    for ti = 1:size(ridsub,1)
        ri  = ridsub(ti);
%         tg = beh(ri,:);
%         t1 = datestr(tg.timestamp_start,30);
%         t1 = str2num(t1(10:15));
%         t2 = datestr(tg.timestamp_choice,30);
%         t2 = str2num(t2(10:15));
%         rid =  find(tms >= t1 & tms <= t2);
        rid = stid(ti):(stid(ti+1)-1);
        beh.totaltime(ri) = tms(rid(end))- tms(rid(1));
        beh.pos{ri} = ttab(rid,:).pos;
        beh.campos{ri} = ttab(rid,:).campos;
        beh.rot{ri} = ttab(rid,:).rot;
        beh.camrot{ri} = ttab(rid,:).camrot;
    end
    toc
end
%%
save('dataEXT_UnityITC.mat','beh');
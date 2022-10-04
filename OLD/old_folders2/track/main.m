clear;
data = readtable('data_UnityITC.csv');
subIDs = unique(data.subjectID);
data = table_autofieldcombine(data);
data.EV = data.reward.*data.prob/100;
data.RR =  data.EV./data.time;
data.dRR = diff(data.RR')';
xbinITC = [-500:20:500];
xbinProb = [-500:20:500];
xbinRD = [-500:20:500];
for si  = 1:length(subIDs)
    idxs = data.subjectID == subIDs(si);
    td = data(idxs,:);
    
    idx_ITC =  all((td.prob == [100 100])')';
    tdITC = td(idx_ITC,:);
    islong = sign(diff(tdITC.time'))';
    dRR = islong .* tdITC.dRR;
    c =  (tdITC.choice *2 - 3) == islong;
    resultITC(si,:) = tool_bin_average(c, dRR, xbinITC);
    
    idx_Prob =  diff(td.time')' == 0;
    tdProb = td(idx_Prob,:);
    issafe = sign(diff(tdProb.prob'))';
    dRR = issafe .* tdProb.dRR;
    c =  (tdProb.choice *2 - 3) == issafe;
    resultProb(si,:) = tool_bin_average(c, dRR, xbinProb);
%     speeds = [1 2 4 8 16];
%     for spi = 1:length(speeds)
     idxsp = all(tdProb.time' == 1 | tdProb.time' == 2)';
     resultProb_sp{1}(si,:) = tool_bin_average(c(idxsp), dRR(idxsp), xbinProb);
     idxsp = all(tdProb.time' == 4 )';
     resultProb_sp{2}(si,:) = tool_bin_average(c(idxsp), dRR(idxsp), xbinProb);
     idxsp = all(tdProb.time' == 8 | tdProb.time' == 16)';
     resultProb_sp{3}(si,:) = tool_bin_average(c(idxsp), dRR(idxsp), xbinProb);
%     end
    
    idx_RD =  diff(td.reward')' == 0;
    tdRD = td(idx_RD,:);
    issafe = sign(diff(tdRD.prob'))';
    dRR = issafe .* tdRD.dRR;
    c =  (tdRD.choice *2 - 3) == issafe;
    resultRD(si,:) = tool_bin_average(c, dRR, xbinRD);
    
end
[av_ITC, se_ITC] = tool_avse(resultITC);
[av_Prob, se_Prob] = tool_avse(resultProb);
[av_RD, se_RD] = tool_avse(resultRD);
for spi = 1:3
    [av_Prob_sp(spi,:),se_Prob_sp(spi,:)] = tool_avse(resultProb_sp{spi});
end
plt_figure; plt_new;
plt_lineplot(av_ITC, se_ITC, tool_bin_middle(xbinITC));
plt_setfig('xlabel', 'RR(long) - RR(short)', 'ylabel', 'p(long)');
plt_update;

plt_figure; plt_new;
plt_lineplot(av_Prob, se_Prob, tool_bin_middle(xbinProb));
plt_setfig('xlabel', 'RR(safe) - RR(risk)', 'ylabel', 'p(safe)');
plt_update;

plt_figure; plt_new;
plt_lineplot(av_RD, se_RD, tool_bin_middle(xbinRD));
plt_setfig('xlabel', 'RR(safe) - RR(risk)', 'ylabel', 'p(safe)');
plt_update;


plt_figure; plt_new;
plt_lineplot(av_Prob_sp, se_Prob_sp, tool_bin_middle(xbinProb));
plt_setfig('xlabel', 'RR(safe) - RR(risk)', 'ylabel', 'p(safe)', ...
    'legend', {'s','m','l'});
plt_update;
%%
for si  = 1:length(subIDs)
    idxs = data.subjectID == subIDs(si);
    td = data(idxs,:);
    
    sub.subjectID(si,1) =  subIDs(si);
    
    idx_ITC =  all((td.prob == [100 100])')';
    tdITC = td(idx_ITC,:);
    islong = sign(diff(tdITC.time'))';
    c =  (tdITC.choice *2 - 3) == islong;
    sub.ITC(si, 1) = nanmean(c);
    
    idx_Prob =  diff(td.time')' == 0;
    tdProb = td(idx_Prob,:);
    issafe = sign(diff(tdProb.prob'))';
    c =  (tdProb.choice *2 - 3) == issafe;
    sub.Prob(si,1) = nanmean(c);
    speeds = [1 2 4 8 16];
    for spi = 1:length(speeds)
     idxsp = all(tdProb.time' == speeds(spi))';
     sub.Prob_sp(si, spi) = nanmean(c(idxsp));
    end
    
    idx_RD =  diff(td.reward')' == 0;
    tdRD = td(idx_RD,:);
    issafe = sign(diff(tdRD.prob'))';
    c =  (tdRD.choice *2 - 3) == issafe;
    sub.RD(si,:) = nanmean(c);
end
sub = struct2table(sub);
gp = ANALYSIS_group(sub);
%%
plt_figure; plt_new;
plt_setfig('color', 'AZblue');
str = plt_scatter(sub.Prob, sub.RD, 'corr');
plt_setfig('legend', str);
plt_update;
%%
plt_new; plt_lineplot(gp.av_Prob_sp, gp.ste_Prob_sp);
%%
ITCsurvey = readtable(fullfile('/Volumes/WangSiyu/Lab_Wilson/Data/Data_Raw/UnityITC_data', 'ITC.csv'));
sv.subjectID = ITCsurvey.ObjectID;
sv.tot = ITCsurvey.x_Of1;
sv =  struct2table(sv);
iscb = strcmp(ITCsurvey.ColorBlind_, 'no');
sv = sv(iscb,:);
%%
ids =  ANALYSIS_subjectmatching(sv, sub, 'subjectID');
plt_figure; plt_new;
plt_setfig('color', 'AZblue');
str = plt_scatter(sub(ids(:,2),:).ITC, sv(ids(:,1),:).tot,  'corr');
plt_setfig('legend', str);
plt_update;


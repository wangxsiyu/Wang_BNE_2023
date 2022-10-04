function sub = RatEE_analysis(td, option_human)
    if ~exist('option_human')
        option_human = 0;
    end
    if option_human == 0 && all(ismember(td.nFree(1:end-1), [2 7 16]))
        nF = td.nFree - 1;
        nG = td.nGuided + 1;
    else
        nF = td.nFree;
        nG = td.nGuided;
    end
    sub = compute(td, nF, nG,option_human);
%     sub1 = compute(td(td.timefrom_lasthomebase < 500000,:), nF, nG, option_human);
%     sub2 = compute(td(td.timefrom_lasthomebase > 500000,:), nF, nG, option_human);
end
function sub = compute(td, nF, nG,option_human)
    if isempty(td)
        sub = [];
    end
    sub.cond_horizon = unique(nF);
    
    ngame = height(td);
    sub.ngame = ngame;
    
    c_ac = arrayfun(@(x)td.c_ac(x,nF(x) + nG(x)), 1:ngame);
    c_ac1 = arrayfun(@(x)td.c_ac(x,1 + nG(x)), 1:ngame);
    c_ee = arrayfun(@(x)td.c_rp(x,nG(x) + 1), 1:ngame);
    rt = arrayfun(@(x)td.timestamp_visit_choice(x, nG(x) + 1), 1:ngame) - ...
        arrayfun(@(x)td.timestamp_BlinkStart_choice(x, nG(x) + 1), 1:ngame);
    if option_human  == 0
        rt = rt / 1000;
    end
    rt(rt > mean(rt) + std(rt)) = NaN; % needs more work
    R = td.reward(:,1);
    xbin = [-0.5:1:5.5];
    [sub.rcurve_ac,sub.se_rcurve_ac] = tool_bin_average(c_ac, R, xbin);
    [sub.rcurve_ac1,sub.se_rcurve_ac1] = tool_bin_average(c_ac1, R, xbin);
    [sub.rcurve_ee,sub.se_rcurve_ee] = tool_bin_average(c_ee, R, xbin);
    [sub.rcurve_rt,sub.se_rcurve_rt] = tool_bin_average(rt, R, xbin);
    
%     te = tempMLEfit(c_ee, R);
%     sub.thres = te(1);
%     sub.noise = te(2);
    
    c_ac = arrayfun(@(x)td.c_ac(x,nG(x)+1:nF(x)+ nG(x)), 1:ngame, 'UniformOutput', false);
    c_ac = vertcat(c_ac{:});
    [sub.trialn_ac, sub.trialn_ac_se] = tool_meanse(c_ac);
    
    c_rp = arrayfun(@(x)td.c_rp(x,nG(x)+1:nF(x)+ nG(x)), 1:ngame, 'UniformOutput', false);
    c_rp = vertcat(c_rp{:});
    [sub.trialn_rp, sub.trialn_rp_se] = tool_meanse(c_rp);

    rt2 = arrayfun(@(x)td.timestamp_visit_choice(x, nG(x)+1:nF(x)+ nG(x)), 1:ngame, 'UniformOutput', false);
    rt1 = arrayfun(@(x)td.timestamp_BlinkStart_choice(x, nG(x)+1:nF(x)+ nG(x)), 1:ngame , 'UniformOutput', false);
    rt2 = vertcat(rt2{:}); rt1 = vertcat(rt1{:});
    if option_human == 0
        rt = (rt2-rt1) / 1000;
    else
        rt = rt2 - rt1;
    end
    rt(rt > mean(rt) + std(rt)) = NaN; % needs more work
    [sub.trialn_rt, sub.trialn_rt_se] = tool_meanse(rt);
    
%     ttd = td(td.timefrom_lasthomebase > 0,:);
    %     xbin = [-0.5, 100000, 200000, 1000000, 100000000, Inf];
%     try
%         xbin = [-0.5, 500000, Inf];
%         [sub.temp_clastgamebest,sub.se_temp_clastgamebest] = tool_bin_average(ttd.c_sameaslastbest, ttd.timefrom_lasthomebase, xbin);
%         [sub.temp_clastgameself,sub.se_temp_clastgameself] = tool_bin_average(ttd.c_sameaslastself, ttd.timefrom_lasthomebase, xbin);
%         
%         te = hist(td.choice(:,unique(td.nGuided+1)), [1 3 5 7 9]);
%         te = te(1:4);
%         sub.percfeeder = te./sum(te);
%     end
end
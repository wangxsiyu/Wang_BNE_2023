function out = behavior_RatEE(g)
    %% r curve
    behsets = {'cc_best','cc_explore','cc_switch','cc_left','ac_guided','cc_sw_guided','cc_sw_unguided'};
    behsets1 = {'c1_cc_best','c1_cc_explore','c1_cc_switch','c1_cc_left',...
        'ce_cc_best','ce_cc_explore','ce_cc_switch','ce_cc_left'};
    out = W.analysis_av(g, behsets);
    if all(g.r(:,1) <= 5)
        rgr = -0.5:1:5.5;
        rgr2 = [-1.5:1:5.5];
    else
        rgr = -10:20:110;
        rgr2 = [-30:20:110];
    end
    out2 = W.analysis_bincurve(g, behsets1, 'r_guided', rgr, 'all');
    out = catstruct(out,out2);
    out3 = W.analysis_bincurve_bygroup('ac_guided',[0, 1], g, behsets1, 'r_guided', rgr, 'all');
    out = catstruct(out,out3);
    out4 = W.analysis_av_bygroup('ac_guided',[0, 1], g, behsets);
    out = catstruct(out,out4); 
    tod = (g.c_guided == g.feeders) * [1 2]';
    g.r_LG = arrayfun(@(x)g.value_lastgame(x, tod(x)), 1:length(tod))';
    g.r_LG(isnan(g.r_LG)) = -1;
    out5 = W.analysis_bincurve(g, behsets1, 'r_LG', rgr2, 'all');
    out5 = W.struct_name_pfxsfx(out5, 'LG_',"");
    out = catstruct(out,out5);

    g.r_LS = arrayfun(@(x)g.value_lastsession(x, tod(x)), 1:length(tod))';
    g.r_LS(isnan(g.r_LS)) = -1;
    out6 = W.analysis_bincurve(g, behsets1, 'r_LS', rgr2, 'all');
    out6 = W.struct_name_pfxsfx(out6, 'LS_',"");
    out = catstruct(out,out6);
%     out5 = W.analysis_bincurve(g, behsets1, 'gameID', -0.5:5:35.5, 'all');
%     out = catstruct(out,W.struct_rename_prefix(out5, 'gameID_'));
%     out6 = W.analysis_bincurve(g, behsets1, 'gameID_perc', -0.1:0.2:1.1, 'all');
%     out = catstruct(out,W.struct_rename_prefix(out6, 'gameIDperc_'));
    
%     % in case there are older data, this computes behavior in different
%     % stages separately
%     [~, od] = sort(g.date);
%     g = g(od,:);
%     tdt = datetime(g.date, 'ConvertFrom', 'YYYYMMDD');
%     tdtu = unique(tdt);
%     gh0 = 1; gh = [];
%     for i = 1:length(tdtu)
%         if i == 1 || tdtu(i) - tdtu(i-1) <= duration(240,0,0)
%             tid = find(tdtu(i) == tdt);
%             gh(tid) = gh0;
%         else
%             gh0 = gh0 + 1;
%             tid = find(tdtu(i) == tdt);
%             gh(tid) = gh0;
%         end
%     end
%     g.historicstages = W.vert(gh);
%     out5 = W.analysis_bincurve_bygroup('historicstages',[], g, behsets, 'r_guided', -0.5:1:5.5, 'all');
%     out = catstruct(out,out5); 
%     out6 = W.analysis_av_bygroup('historicstages',[], g, behsets);
%     out = catstruct(out,out6); 
end
function get_bayesdata(data, savename)
    bayesdata = [];
    bayesdata.nG = size(data,1);
    rats = unique(data.rat);
    bayesdata.nR = length(rats);
    bayesdata.h = data.bayes_horizon;
    bayesdata.h = W.getrank(bayesdata.h);
    bayesdata.gd = data.cond_guided;
    bayesdata.gd = W.getrank(bayesdata.gd);
    bayesdata.nH = max(bayesdata.h);
    bayesdata.ngd = max(bayesdata.gd);
    bayesdata.r = data.r_guided;
    bayesdata.c = data.c1_cc_explore;
    bayesdata.sideguided = sign(data.side_guided- 1.5);
    bayesdata.rats = cellfun(@(x)find(strcmp(x, rats)), data.rat);
%     bayesdata.rLastVisit = sum((data.c_guided == data.feeders).*data.value_lastvisit,2);
    vlg = data.value_lastgame;
    vlg(isnan(vlg)) = -1;
    vls = data.value_lastsession;
    vls(isnan(vls)) = -1;
    bayesdata.rLastGame = sum((data.c_guided == data.feeders).*vlg,2);
    bayesdata.rLastSession = sum((data.c_guided == data.feeders).*vls,2);

    bayesdata.rOLastGame = sum((data.c_other == data.feeders).*vlg,2);
    bayesdata.rOLastSession = sum((data.c_other == data.feeders).*vls,2);
    
    save(savename, 'bayesdata','rats');
end
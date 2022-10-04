function data = disp_cond_ratEE(data)
    te = W_sub.display_conditions(data, {'n_free','n_guided','rat','date','foldername'});
    [tidx, tcond] = W_sub.selectsubject(te, {'n_free', 'n_guided', 'rat'});
    tout = W_sub.tab_trial2game(te, tidx);
    dts = arrayfun(@(x)W.extend_nan(str2num(x),1),tout.date);
    yr = floor(dts/10000);
    mt = floor(mod(dts, 10000)/100);
    dt = mod(dts, 100);
    cummon = cumsum([0 31 29 31 30 31 30 31 31 30 31 30]);
    doy = W.arrayfun(@(x)W.nan_select(cummon, x), mt) + dt;
    xgrid = (yr - min(yr,[],'all')) * 366 + doy;
   
    rats = unique(tcond.rat);
    grid = zeros(length(rats), max(xgrid, [],'all'));
    for xi = 1:size(xgrid, 1)
        txi = find(tout.rat(xi) == rats);
        tt = str2num(tout(xi,:).n_free);
        if ismember(tt,[1 0])
                tt = 1;
        elseif ismember(tt,[6,7])
                tt = 2;
        elseif ismember(tt,[15,20])
                tt = 3;
        end
        grid(txi, W.unique(xgrid(xi,:)',0)) = tt;
    end
    
    figure;
    imagesc(grid);
    set(gca, 'ytick', 1:6, 'yticklabel', rats);
end
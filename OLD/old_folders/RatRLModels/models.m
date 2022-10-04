function gpR = models(fd, rs, para, option, d)
    switch option
        case 'A'
            [c, r] = modelA_nolight(fd, rs, para);
        case 'B'
            [c, r] = modelB_light(fd, rs, para);
        case 'C'
            [c, r] = modelC_valuelight(fd, rs, para(1), para(2));
        case 'D'
            [c, r] = modelD_plusminusalpha(fd, rs, para(1), para(2));
            
        case 'E'
            [c, r] = modelE_hardreset(fd, rs, para(1), para(2));
    end
    d.r = repmat([repmat(999, 1, 9),  NaN(1,3)], size(d,1),1);
    d.fd = repmat([repmat(999, 1, 9),  NaN(1,3)], size(d,1),1);
    d.r = nan_fill(d.r, r);
    d.fd = nan_fill(d.fd, c);
    d.fd_side = abs(sign(d.fd - d.feederID(:,1))) + 1;
    [gp, gpR] = Rat_default(d);
end
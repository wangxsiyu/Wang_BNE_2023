function expdates = getratdateranges(ratdir, expdates)
    files = dir(ratdir);
    idxnum = ~isnan(cellfun(@(x)str_selectnum(x), {files.name}));
    files = files(idxnum);
    dates = {files.name};
    datesnum = cellfun(@(x)str2num([x(5:6), x(1:4)]), dates);
    rgnum  = cellfun(@(x)str2num([x(5:6), x(1:4)]), expdates(1:2));
    idx = datesnum >= rgnum(1) & datesnum <= rgnum(2);
    expdates = dates(idx);
    % exclude folders with NA
%     expdates = expdates(cellfun(@(x)length(x) <= 7, expdates)); % 6 digits + 1 letter
end
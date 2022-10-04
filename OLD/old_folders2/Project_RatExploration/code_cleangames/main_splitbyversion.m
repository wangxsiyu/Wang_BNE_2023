data = W.readtable('../data_behavior_RatExploration/cleaned_games_EE.csv');
info = W.readtable('../data_behavior_RatExploration/cleaned_info_EE.csv');
outputdir = '../data_behavior_RatExploration';
%%
W_sub.display_conditions(info, {'str_guidefree','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
%% 3 lights
tfdidxinfo = info.is_3lights == 1;
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);
tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_3lights.csv'));
%% control reward
tfdidxinfo = info.is_random == 1 & info.is_consistent_ntotal == 1 & info.str_guidefree == "(3,6)";
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);

tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_control_G3F6_random.csv'));
%% control horizon
tfdidxinfo = info.is_consistent_ntotal == 0 & (info.str_guidefree == "(3,1)(3,6)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);

tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_RandH_control_G3F16.csv'));
%% between subject H1 vs H6
tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(3,6)" | info.str_guidefree == "(3,1)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);

tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_G3_between.csv'));
%% Long horizons between
tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(3,15)" | info.str_guidefree == "(3,20)" | ...
    info.str_guidefree == "(1,20)" | info.str_guidefree == "(0,16)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);

tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_mixed_long_between.csv'));
%% within subject H1 vs H6
tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(3,1)(3,6)" | ...
    info.str_guidefree == "(4,1)(4,6)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);
tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_G34_within.csv'));
%% free vs forced
tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(1,1)(1,6)" | ...
    info.str_guidefree == "(0,2)(0,7)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);
tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_G01_within.csv'));
%% within subject H2 vs H7
tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(0,3)(0,8)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);

tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_G0F38_within.csv'));
%% (wrong) all mixed 0123 vs 16
tfdidxinfo = info.is_random == 0 & info.is_consistent_nguided == 0;
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);
tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_RandH_G0123F16_within.csv'));
%% (early) neutral guide (1 drop during guided choices)
tfdidxinfo = info.is_random == 1 & (info.str_guidefree == "(6,18)" | info.str_guidefree == "(6,24)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);
tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_EARLY_neutralguide.csv'));
%% G4 F6
tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(4,6)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);
tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_G4F6_between.csv'));
%% G6 F6
tfdidxinfo = (info.str_guidefree == "(6,6)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder & data.is_guided(:,4) == 1;
td = data(tidx,:);
tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_G6F6.csv'));
%% G3F3G3F3
tfdidxinfo = (info.str_guidefree == "(6,6)");
tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
tidx = tidxfolder;
td = data(tidx,:);
tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
data = data(~tidx,:);
info = info(tidxinfo,:);
W.writetable(td, 'squeeze', fullfile(outputdir, 'gameversion_G3F3G3F3.csv'));
%% data that's ignored
W_sub.display_conditions(info, {'str_guidefree','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])

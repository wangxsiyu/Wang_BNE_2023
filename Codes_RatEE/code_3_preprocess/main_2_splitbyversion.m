data = W.readtable('../../data_processed/cleaned/cleaned_games_EE_withhistory.csv');
% info = W.readtable('../../data_processed/cleaned/cleaned_info_EE.csv');
outputdir = '../../data_processed/versions';
if ~exist(outputdir)
    mkdir(outputdir);
end
%%
W_sub.display_conditions(data, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
%% 3 lights
% tfdidxinfo = info.is_3lights == 1;
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = data.is_3lights == 1;
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_3lights.csv'), 'squeeze');
%% control reward
% tfdidxinfo = info.is_random == 1 & info.is_consistent_ntotal == 1 & info.str_guidefree == "(3,6)";
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% 
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = data.is_random == 1 & strcmp(data.str_guidefree, '(3,6)');
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_RandR_G3F6.csv'), 'squeeze');
%% control horizon
% tfdidxinfo = info.is_consistent_ntotal == 0 & (info.str_guidefree == "(3,1)(3,6)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% 
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = data.is_randomhorizon == 1 & strcmp(data.str_guidefree, '(3,1)(3,6)');
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_RandH_G3F16.csv'), 'squeeze');
%% between subject H1 vs H6
% tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(3,6)" | info.str_guidefree == "(3,1)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% 
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = strcmp(data.str_guidefree, '(3,1)') | strcmp(data.str_guidefree, '(3,6)');
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_G3_between.csv'), 'squeeze');
%% Long horizons between
% tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(3,15)" | info.str_guidefree == "(3,20)" | ...
%     info.str_guidefree == "(1,20)" | info.str_guidefree == "(0,16)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% 
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = strcmp(data.str_guidefree, '(1,20)') | strcmp(data.str_guidefree, '(3,20)') | ...
    strcmp(data.str_guidefree, '(0,16)') | strcmp(data.str_guidefree, '(3,15)');
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_long_between.csv'), 'squeeze');
%% within subject H1 vs H6
% tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(3,1)(3,6)" | ...
%     info.str_guidefree == "(4,1)(4,6)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
%% free vs forced
% tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(1,1)(1,6)" | ...
%     info.str_guidefree == "(0,2)(0,7)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
%% within all
tidx = strcmp(data.str_guidefree, '(3,1)(3,6)') | ...
    strcmp(data.str_guidefree, '(4,1)(4,6)') | ...
    strcmp(data.str_guidefree, '(1,1)(1,6)') | ...
    strcmp(data.str_guidefree, '(0,2)(0,7)');
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_within.csv'), 'squeeze');
%% within subject H2 vs H7
% tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(0,3)(0,8)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% 
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = strcmp(data.str_guidefree, '(0,3)(0,8)');
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_G0F38_within.csv'), 'squeeze');
%% (wrong) all mixed 0123 vs 16
% tfdidxinfo = info.is_random == 0 & info.is_consistent_nguided == 0;
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = data.is_consistent_ntotal == 0;
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_RandH_G0123F16_within.csv'), 'squeeze');
%% (early) neutral guide (1 drop during guided choices)
% tfdidxinfo = info.is_random == 1 & (info.str_guidefree == "(6,18)" | info.str_guidefree == "(6,24)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = data.is_random == 1;
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_EARLY_neutralguide.csv'), 'squeeze');
%% G4 F6
% tfdidxinfo = info.is_random == 0 & info.is_consistent_ntotal == 1 & (info.str_guidefree == "(4,6)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = strcmp(data.str_guidefree, '(4,6)');
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_G4F6_between.csv'), 'squeeze');
%% G6 F6
% tfdidxinfo = (info.str_guidefree == "(6,6)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder & data.is_guided(:,4) == 1;
% td = data(tidx,:);
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
tidx = strcmp(data.str_guidefree, '(6,6)');
td = data(tidx,:);
W_sub.display_conditions(td, {'str_guidefree','is_randomhorizon','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])
data = data(~tidx, :);
W.writetable(td, fullfile(outputdir, 'gameversion_G6F6.csv'), 'squeeze');
%% G3F3G3F3
% tfdidxinfo = (info.str_guidefree == "(6,6)");
% tidxfolder = contains(data.foldername, info.foldername(tfdidxinfo)) & contains(data.filename, info.filename(tfdidxinfo));
% tidx = tidxfolder;
% td = data(tidx,:);
% tidxinfo = ~(contains(info.foldername, td.foldername) & contains(info.filename, td.filename));
% disp(sprintf('%d games selected, %d sessions involved', sum(tidx), sum(~tidxinfo)));
% data = data(~tidx,:);
% info = info(tidxinfo,:);
% W.writetable(td, fullfile(outputdir, 'gameversion_G3F3G3F3.csv'), 'squeeze');
%% data that's ignored
W_sub.display_conditions(data, {'str_guidefree','is_random','is_3lights', 'is_consistent_nfree','is_consistent_nguided','is_consistent_ntotal'},[])

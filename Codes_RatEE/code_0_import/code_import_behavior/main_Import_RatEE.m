%% set up directory list
datadir = '../../../RawData_RatExploration';
folders = dir(fullfile(datadir, 'Exploration*'));
outputdir = '../../../data_processed/compiled';
isoverwrite = true;
%% load maze
maze = importRat_mazelayout(fullfile(datadir, 'Room1_063020_correctedbySiyu.txt'));
%% get all folders
xfolders = table;
for fi = 1:length(folders)
    [~,tfolder] = W.dir(fullfile(folders(fi).folder, folders(fi).name, 'RawData'), 'folder');
    te = table;
    te.folderdate = W.strs_select(tfolder.folder_name);
    te.foldersession = string(W.strs_select(tfolder.folder_name, '!digit'));
    te = W.tab_fill(te, 'rat', string(W.str_selectbetween2pattern(folders(fi).name, '_', [], 1, [])));
    te.foldername = fullfile(folders(fi).folder, folders(fi).name, 'RawData', tfolder.folder_name);
    xfolders = vertcat(xfolders, te);
end
xfolders = xfolders(~isnan(xfolders.folderdate),:);
%% add new folders
if exist(fullfile(outputdir, 'raw_RatEE.csv'), 'file') && ~isoverwrite
    raw_rat0 = readtable(fullfile(outputdir, 'raw_RatEE.csv'));
    raw_rat0 = W.tab_autofieldcombine(raw_rat0);
    idexist = ismember(xfolders.foldername, unique(raw_rat0.foldername));
    xfolders = xfolders(~idexist,:);
else
    raw_rat0 = table;
end
%% load all folders 
%%%%% TODO
%%%%% tracker
%%%%% sound
raw_rat = table;
for fi = 1:height(xfolders)
    %%
    folder = xfolders.foldername(fi);
    tic
%     try
        disp(sprintf('Importing %s: %d%s, %d/%d', xfolders.rat(fi), ...
            xfolders.folderdate(fi), xfolders.foldersession(fi), fi, height(xfolders)));
        tdata = importRat_MASTER_folder(folder, maze);
        tdata = W.tab_fill(tdata, xfolders(fi,:));
        raw_rat = W.tab_vertcat(raw_rat, tdata);
%     catch
%         warning(sprintf('Importing failed: #%d %s, %d%s\n', fi, xfolders.rat(fi), ...
%             xfolders.folderdate(fi), xfolders.foldersession(fi)));
% %         pause;
%     end
    disp(sprintf('            %.2f', toc));
end
%% combine with old
if ~isempty(raw_rat0)
    raw_rat = W.tab_vertcat(raw_rat0, raw_rat);
end
%% save this file
if ~exist(outputdir)
    mkdir(outputdir);
end
writetable(raw_rat, fullfile(outputdir, 'raw_RatEE.csv'));
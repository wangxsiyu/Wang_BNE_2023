%% set up directory list
datadir = '../../../RawData_RatExploration';
folders = dir(fullfile(datadir, 'Exploration*'));
outputdir = '../../data_behavior_RatExploration';
isoverwrite = false;
%% get all folders
xfolders = table;
for fi = 1:length(folders)
    [~,tfolder] = W.dir(fullfile(folders(fi).folder, folders(fi).name, 'RawData'), 'folder');
    te = table;
    te.folderdate = W.str_selects(tfolder.folder_name);
    te.foldersession = string(W.str_selects(tfolder.folder_name, '!digit'));
    te = W.tab_fill(te, 'rat', string(W.str_selectbetween2patterns(folders(fi).name, '_', [], 1, [])));
    te.foldername = fullfile(folders(fi).folder, folders(fi).name, 'RawData', tfolder.folder_name);
    xfolders = vertcat(xfolders, te);
end
xfolders = xfolders(~isnan(xfolders.folderdate),:);
%%
fd_raw = fullfile(outputdir, 'trackdata', 'raw');
fd_smoothed = fullfile(outputdir, 'trackdata', 'smoothed');
if ~exist(fd_raw, 'dir')
    mkdir(fd_raw);
end
if ~exist(fd_smoothed, 'dir')
    mkdir(fd_smoothed);
end
%% load all folders 
for fi = 1:height(xfolders)
    %%
    folder = xfolders.foldername(fi);
    tic
        disp(sprintf('Importing %s: %d%s, %d/%d', xfolders.rat(fi), ...
        xfolders.folderdate(fi), xfolders.foldersession(fi), fi, height(xfolders)));
        fname = strcat("track_",xfolders.rat(fi),"_",num2str(xfolders.folderdate(fi)), '_', xfolders.foldersession(fi), ".csv");
        if ~isoverwrite && exist(fullfile(fd_raw, fname), 'file') && exist(fullfile(fd_smoothed, strcat('smoothed', fname)), 'file')
            cprintf('blue', 'file exists, skipped\n');
        else
            tdata = importFolder_tracker(folder);
            if ~isempty(tdata)
                track = W.tab_fill(tdata.track, xfolders(fi,:));
                track_smoothed = W.tab_fill(tdata.track_smoothed, xfolders(fi,:));
                writetable(track, fullfile(fd_raw, fname));
                writetable(track_smoothed, fullfile(fd_smoothed, strcat('smoothed', fname)));
            else
                cprintf('red', 'no track file found\n');
            end
        end
    disp(sprintf('            %.2f', toc));
end
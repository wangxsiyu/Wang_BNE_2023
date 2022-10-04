%% load data
datadir = '/Volumes/Wang/Lab_Fellous/Data_FellousLab/RawData_FellousLab/';
outputdir = '/Volumes/Wang/Lab_Fellous/Data_FellousLab/ImportedData_FellousLab/';
projectname = 'Exploration';
folders = dir(fullfile(datadir, [projectname '*']));
%% tempfile for the compilation of data from all folders
rawfile = fullfile(outputdir,['Rat_' projectname '_foldercompilation']);
%% check folders
filelist = {};
fileheads = {'Game','TrackData','TrackData-Events','Behavior','SoundData', ...
    'Load_SoundSpecs','Load_SoundMap'};
for ri = 1:length(folders)
    cprintf('Green', 'Checking rat %s\n', folders(ri).name);
    tfolder = fullfile(folders(ri).folder, folders(ri).name, 'RawData');
    tdays = getratdateranges(tfolder, {'010118','123120'});
    tab = import_checkfolders(strcat(tfolder,'/', tdays),fileheads);    
    filelist{ri} = table;
    filelist{ri}.rat = repmat(string(str_selectbetween2patterns(folders(ri).name, '_',[], 1,[])), size(tab,1),1);
    filelist{ri} = [filelist{ri} tab];
    filelist{ri}.ratdir = repmat(string(tfolder), size(tab,1),1);
end
filelist = table_vertcat(filelist{:});
%% exclude days without game and behavior
filelist = filelist(~isnan(filelist.Behavior) | ~isnan(filelist.Game),:);

%% select only Exploration
idx = cellfun(@(x)isempty(x), tab_rat);
d = tab_rat(~idx);
idx = cellfun(@(x)isfield(x, 'Exploration'), d);
d = d(idx);
d = cellfun(@(x)x.Exploration, d, 'UniformOutput',false);
%%
tab = table;
for di = 1:length(d)
    tab = table_vertcat(tab, d{di});
end
%%
rawfile = fullfile(outputdir,['RatEE.csv']);
writetable(tab, rawfile);
%%
% versionlist = getversionlist(datadir, projectname);
% rats = fieldnames(versionlist);
% games = table;
% for ri = 1:length(rats)
%     game = table;
%     rat = rats{ri}; 
%     vs = versionlist.(rat);
%     for vi = 1:length(vs.version)
%         for fi = 1:length(vs.dates{vi})
%             filedir = fullfile(vs.folder, vs.dates{vi}{fi});
%             [tgame] = loadFolder(filedir, mazelayout);
%             tgame.version = repmat(vs.version(vi), size(tgame,1),1);
%             game = vertcat(game, tgame);
%         end
%     end
%     games = vertcat(games, game);
% end
% %%
% writetable(games, '/Volumes/Wang/Lab_Fellous/Data_FellousLab/ImportedData_FellousLab/ratEE.csv');
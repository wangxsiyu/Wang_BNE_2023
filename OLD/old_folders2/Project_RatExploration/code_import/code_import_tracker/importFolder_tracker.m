function [out] = importFolder_tracker(folder)
files = dir(fullfile(folder, 'TrackData*.txt'));
files = files(arrayfun(@(x)isempty(strfind(x.name,'Events')), files));
if length(files) == 0
    out = [];
    return;
end
for fi = 1:length(files)
    filename = fullfile(folder, files(fi).name);
    rawtrack{fi} = import_tracker(filename);
    [track2{fi}, track{fi}] = preprocess_tracker(rawtrack{fi});
    track2{fi}.filename = repmat(string(files(fi).name), size(track2{fi},1),1);
    track{fi}.filename = repmat(string(files(fi).name), size(track{fi},1),1);
end
track2 = vertcat(track2{:}); % smoothed and interpolated
track = vertcat(track{:});
out.track = track;
out.track_smoothed = track2;
end
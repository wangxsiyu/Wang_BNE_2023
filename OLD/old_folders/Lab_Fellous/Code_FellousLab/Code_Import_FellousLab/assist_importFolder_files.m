function [dat] = assist_importFolder_files(folder, func, fn)
    dat = {};
    func = str2func(func);
    files = dir(fullfile(folder, [fn '*.txt']));
    for fi = 1:length(files)
        filename = fullfile(folder, files(fi).name);
        dat{fi} = func(filename);
    end
   
end
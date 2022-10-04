classdef W_import < handle
    properties
    end
    methods(Static)
        function out = assist_getSubIDDatetime(filenames, str_subID, num_subID, str_datetime, num_datetime)
            for fi = 1:length(filenames)
                filename = filenames{fi};
                out(fi).subjectID = str2num(W.str_selectbetween2pattern(filename, str_subID{1}, str_subID{2}, ...
                    num_subID(1), num_subID(2)));
                strdatetime = W.str_selectbetween2pattern(filename, str_datetime{1}, str_datetime{2}, ...
                    num_datetime(1), num_datetime(2));
                out(fi).date = yyyymmdd(datetime(strdatetime));
                out(fi).time = timeofday(datetime(strdatetime));
                out(fi).filename = string(filename);
            end
        end
        function data = IMPORT_datafiles_subID_yyyymmddTHHMMSS(datadir, filetemplate, importfunc, ...
                str_subID, num_subID, str_datetime, num_datetime, subIDrange, outputdir, outputname)
            % this function works for files with format:
            % PRESTR_subjectID_yyyymmddTHHMMSS.mat
            % if importfunc includes a column named gameNumber
            if ~exist('func_data')
                func_data = [];
            end
            files = dir(fullfile(datadir, filetemplate));
            subs = W_import.assist_getSubIDDatetime({files.name}, str_subID, num_subID, str_datetime, num_datetime);
            idx_subID = ([subs.subjectID] >= subIDrange(1)) & ([subs.subjectID] <= subIDrange(2));
            files = files(idx_subID);
            subs = subs(idx_subID);
            games = W_import.IMPORT_datafiles(importfunc, files);
            disp('Processing...');
            subtable = unique(struct2table(subs));
            data = [];
            for gi = 1:length(games)
                tgame = games(gi);
                [fx, fnms] = W.fieldsize(tgame,[], 1);
                fnms = fnms(fx == 1);
                %                 if ~isempty(tgame)
                for fi = 1:length(fnms)
                    tgame.(fnms{fi}) = repmat(tgame.(fnms{fi}), max(fx),1);
                end
                %                 end
                ttab = struct2table(tgame);
                ttab = join(ttab, subtable);
                data = W.tab_vertcat(data, ttab);
            end
            idx_filename = find(strcmp(fieldnames(data), 'filename'));
            data = data(:,[idx_filename:size(data,2), 1:idx_filename-1]);
            if exist('outputname') && exist('outputdir') && ~isempty(outputname)
                writetable(data, fullfile(outputdir ,['RAW_', outputname, '.csv']));
            end
            disp(sprintf('Completed - imported from raw files'));
        end
        function games = IMPORT_datafiles(funcimport, files)
            % by sywangr@email.arizona.edu
            % version 1.0
            nfile = length(files);
            for fi = 1:nfile
                filename = files(fi).name;
                disp(sprintf('importing file %d/%d: %s', fi, nfile, filename));
                tic
                tdata = load(fullfile(files(fi).folder, filename));
                tgame = funcimport(tdata);
                if ~isempty(tgame)
                    for ti = 1:length(tgame)
                        tgame(ti).filename = string(filename);
                    end
                else
                    disp('failed to import - empty output');
                end
                data{fi} = tgame;
                toc
            end
            games = [data{:}];
            disp(sprintf('Complete: %d files imported', nfile));
        end
    end
end
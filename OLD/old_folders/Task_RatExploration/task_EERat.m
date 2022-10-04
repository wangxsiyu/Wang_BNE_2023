classdef task_EERat < handle
    properties
        savedir
        ratname
        tskname
    end
    methods
        function obj = task_EERat(savedir)
            obj.savedir = savedir;
            rand('seed', round(sum(clock()*1000)));
        end
        function settask(obj, rats, tasks)
            if length(rats) ~= length(tasks)
                error('SiyuErr: The number of tasks do not match the number of rats');
            end
            obj.ratname = rats;
            obj.tskname = tasks;
        end
        function gettask(obj)
            ratname = obj.ratname;
            for ri = 1:length(ratname)
                switch obj.tskname{ri}
                    case 'randomlight' % this is to generate random files...
                        lights = [2 4 6 8]; % the range of available feeders
                        nlight = 1; % the number of lights going up at once, switch this to 2 for initial training...
                        ngame = 500;
                        fdtime = 90;
                        fddrop = 2;
                        rattask_randomlights(obj.savedir, ratname{ri}, lights, nlight, ngame, fdtime, fddrop);
                    case 'EEsound_noguided'
                        fddrops = [0 1 2 3 5];
                        fdtime = 90;
                        homebase = [1 5];
                        nRep = 5;
                        horizons = [1 6];
                        guideds = [0];
                        rattask_EEsound(obj.savedir, ratname{ri}, fdtime, fddrops, homebase, horizons, guideds, nRep);
                        
                end
            end
        end
    end
end
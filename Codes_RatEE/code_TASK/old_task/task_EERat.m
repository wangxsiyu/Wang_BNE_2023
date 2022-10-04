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
                        fdtime = 100;
                        fddrop = 2;
                        rattask_randomlights(obj.savedir, ratname{ri}, lights, nlight, ngame, fdtime, fddrop);
                    case 'randomlightsound'
                        lights = [2 4 6 8]; % the range of available feeders
                        ngame = 500;
                        fdtime = 100;
                        rattask_randomlightssound(obj.savedir, ratname{ri}, lights, ngame, fdtime);
                    case 'EEsound_noguided'
                        fddrops = [0 1 2 3 5];
                        fdtime = 90;
                        homebase = [1 5];
                        nRep = 5;
                        horizons = [1 6];
                        guideds = [0];
                        rattask_EEsound(obj.savedir, ratname{ri}, fdtime, fddrops, homebase, horizons, guideds, nRep);
                     case 'EEsound_magnitude'
                        fddrops = [0 1 2 3 4 5];
                        fdtime = 100;
                        homebase = [1 5];
                        nRep = 5;
                        horizons = [1 6];
                        guideds = [4];
                        rattask_EEsound_magnitude(obj.savedir, ratname{ri}, fdtime, fddrops, homebase, horizons, guideds, nRep);
                   case 'EEsound_magnitudeG'
                        fddrops = [0 1 1 2 2 3 3 4 4 5];
                        fdtime = 100;
                        homebase = [1 5];
                        if rand > 0.5
                            nRep = 5;
                            horizons = [1 6];
                        elseif rand < 4/26
                            nRep = 4;
                            horizons = [6 6];
                        else 
                            nRep = 9;
                            horizons = [1 1];
                        end
                        guideds = [3];
                        rattask_EEsound_magnitudeG(obj.savedir, ratname{ri}, fdtime, fddrops, homebase, horizons, guideds, nRep);
                    case 'rattask_EEsound_magnitudeLast'
                        fddrops = [0 1 2 3 4 5];
                        fdtime = 100;
                        homebase = [1 5];
                        nRep = 2;
                        horizons = [1 6];
                        guideds = [3];
                        rattask_EEsound_magnitudeLast(obj.savedir, ratname{ri}, fdtime, fddrops, homebase, horizons, guideds, nRep);
                    case 'EEsound_magnitudeG2'
                        fddrops = [1 3];
                        fdtime = 100;
                        homebase = [1 5];
                        nRep = 20;
                        horizons = [6 6];
                        guideds = [4];
                        rattask_EEsound_magnitudeG2(obj.savedir, ratname{ri}, fdtime, fddrops, homebase, horizons, guideds, nRep);
                     case 'EEsound_magnitudeG2_01'
                        fddrops = [0 1];
                        fdtime = 100;
                        homebase = [1 5];
                        nRep = 30;
                        horizons = [1 6];
                        guideds = [0];
                        rattask_EEsound_magnitudeG2(obj.savedir, ratname{ri}, fdtime, fddrops, homebase, horizons, guideds, nRep);
                    case 'rattask_EEsound_magnitudeGLong'
                        fddrops = [0 1 2 3 4 5];
                        fdtime = 100;
                        homebase = [1 5];
                        nRep = 4;
                        horizons = [15 15];
                        guideds = [3];
                        rattask_EEsound_magnitudeGLong(obj.savedir, ratname{ri}, fdtime, fddrops, homebase, horizons, guideds, nRep);
                  
                 
                    
                    
                    case 'NegativeZone'
                        probnext = [0 1 1 1 1 1 0]; % blake, change this to change the probability of the next feeder, 
                                                    % if you want completely random ones, just change
                                                    % this to [1 1 1 1 1 1 1];
                        blakeNeg(110, 1:8, 1, 1, 600, obj.savedir, round(sum(clock()*1000)), datestr(now, 30), ratname{ri}, probnext);    
                   case 'HomePlusNeg'
                        probnext = [0 0 1 1 1 0 0]; % blake, change this to change the probability of the next feeder, 
                                                    % if you want completely random ones, just change
                                                    % this to [1 1 1 1 1 1 1];
                        blakeHomeNeg(110, 1:8, 1, 1, 600, obj.savedir, round(sum(clock()*1000)), datestr(now, 30), ratname{ri}, probnext);    
                   case 'BlakeHomeNegv1'
                        probblock = 1/3;
                        isnext = -1;
                        drop = 1;
                        blakeHomeNegv1(130, 1, drop, 600, obj.savedir, round(sum(clock()*1000)), datestr(now, 30), ratname{ri}, probblock, isnext);    
                     case 'rattask_EEsound_magnitudeGBig'
                        fddrops = [1 2]; % exploit value
                        fddiffs = [1 -1]; % explore value
                        fdtime = 200;
                        homebase = [1 5];
                        nRep = 10;
                        horizons = [1 6];
                        guideds = [3];
                        rattask_EEsound_magnitudeGBig(obj.savedir, ratname{ri}, fdtime, fddrops, fddiffs, homebase, horizons, guideds, nRep);
                    
                
                end
            end
        end
    end
end
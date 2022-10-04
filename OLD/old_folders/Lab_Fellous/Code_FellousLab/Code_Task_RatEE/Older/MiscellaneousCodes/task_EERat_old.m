classdef task_EERat < handle
    properties
        savedir
        dt
        sd
        ratname
        tskname
    end
    methods
        function obj = task_EERat(savedir)
           obj.savedir = savedir;
           dt = datestr(now, 30);
           obj.dt = str2num([dt(1:8), dt(10:15)]);
           obj.sd = sum(clock);
        end
        function settask(obj, rats, tasks)
            obj.ratname = rats;
            obj.tskname = tasks;
        end
        function gettask(obj)
            ratname = obj.ratname;
            for ri = 1:length(ratname)
                switch obj.tskname{ri}
                    case 'alter17'
                        game = generate2(3, 6, 130, [1 7], [1 5], 4, obj.savedir, obj.sd, ratname{ri});
                    case 'alter17b'
                        game = generate2b(3, 6, 130, [1 7], [1 5], 4, obj.savedir, obj.sd, ratname{ri});
                    case 'alter17c'
                        game = generate2c(3, 6, 130, [1 7], [1 5], 4, obj.savedir, obj.sd, ratname{ri});
                    case 'alter02'
                        game = generate2d(3, 6, 130, [0 2], [1 5], 10, obj.savedir, obj.sd, ratname{ri});
                    case '02'
                        game = generate2e(3, 6, 130, [0 2], [1 5], 10, obj.savedir, obj.sd, ratname{ri});
                    case '015'
                        game = generate2f(3, 6, 130, [0 1 5], [1 5], 4, obj.savedir, obj.sd, ratname{ri});
                    case '015guided2'
                        game = generate2g015(3, 6, 90, [0 1 5], [0 1 1 5], [1 5], 2, obj.savedir, obj.sd, ratname{ri});
                    case '015new'
                        game = generate2h015(3, 6, 90, [0 1 5], [0 1 1 5], [1 5], 2, obj.savedir, obj.sd, obj.dt, ratname{ri});
                     case '015newS'
                        game = generate2h015(3, 1, 90, [0 1 5], [0 1 1 5], [1 5], 10, obj.savedir, obj.sd, obj.dt, ratname{ri});
                    case '0135newS'
                        game = generate2h015(3, 1, 90, [0 1 3 5], [0 1 1 3 3 5], [1 5], 5, obj.savedir, obj.sd, obj.dt, ratname{ri});
                    case '0135newL'
                        game = generate2h015(3, 6, 90, [0 1 3 5], [0 1 1 3 3 5], [1 5], 2, obj.savedir, obj.sd, obj.dt, ratname{ri});
                    case '3light_L'
                        game = generate4(3,[1 6], 90, [0 1 2 3 5], [0 1 1 2 2 3 3 5], [1 5], 1, obj.savedir, obj.sd, obj.dt, ratname{ri});
                    case 'randomGuided'
                        game = generate5([0 1 2 3],[1 6], 90, [0 1 2 3 5], [0 1 2 3 5], [1 5], 1, obj.savedir, obj.sd, obj.dt, ratname{ri});
                    case 'soundv1'
                        game = generateSD([0 1 2 3],[1 6], 90, [0 1 2 3 5], [0 1 2 3 5], [1 5], 5, obj.savedir, obj.dt, ratname{ri});
                    case 'Blake'
                        blake(110, 1:8, 1, 1, 600, obj.savedir, obj.sd, obj.dt, ratname{ri});
                    case 'NegativeZone'
                        probnext = [0 0 1 1 1 0 0]; % blake, change this to change the probability of the next feeder, 
                                                    % if you want completely random ones, just change
                                                    % this to [1 1 1 1 1 1 1];
                        blakeNeg(110, 1:8, 1, 1, 600, obj.savedir, obj.sd, obj.dt, ratname{ri}, probnext);    
                    case 'random'
                        main_light4(300, 130, obj.savedir, obj.sd, ratname{ri});
                end
            end
        end
        function getorderinpair(obj)
            ratname = obj.ratname;
            nr = length(ratname);
            if mod(obj.dt, 2) == 1
                od = [1 2];
            else
                od = [2 1];
            end
            for ri = 1:floor(nr/2)
                tname = ratname(ri*2-1:ri*2);
                ratname(ri*2-1:ri*2)= tname(od);
            end
            for ri = 1:nr
                disp(sprintf('#%d: %s', ri, ratname{ri}));
            end
        end
    end
end
function figure_model(gpRs)
    gpRs = tool_encell(gpRs);
    nl = length(gpRs);
    for j  =  1:nl
        gpR = gpRs{j};
        gpRLs{j} = gpR(gpR.av_nFree == 6,:);
    end
    colrat = {'AZcactus', 'AZsand', 'AZblue', 'AZsky', 'AZred'};
    plt_figure(2,3);
    plt_setfig('color', colrat, ...
        'xlabel', 'horizon', 'ylabel', {'p(best feeder)','p(best feeder)','p(best feeder)','p(switch)','p(switch)','p(switch)'},  ...
        'ylim', [0 1], 'xlim', [0,10]);
    r0 = [0  1  5];
    for i = 1:3
        plt_new;
        for j = 1:nl
            gpRL = gpRLs{j};
            tgp = gpRL(gpRL.av_r_guided == r0(i),:);
            plt_lineplot(tgp.av_c_ac(4:9), tgp.ste_c_ac(4:9), 4:9);
        end
        plt_lineplot(tgp.av_c_ac(1:3), tgp.ste_c_ac(1:3));
    end
    for i = 1:3
        plt_new;
        for j  = 1:nl
            gpRL = gpRLs{j};
            tgp = gpRL(gpRL.av_r_guided == r0(i),:);
            plt_lineplot(1-tgp.av_c_repeat(4:9), tgp.ste_c_repeat(4:9), 4:9);
        end
        plt_lineplot(1-tgp.av_c_repeat(1:3), tgp.ste_c_repeat(1:3));
    end
    plt_update;
end
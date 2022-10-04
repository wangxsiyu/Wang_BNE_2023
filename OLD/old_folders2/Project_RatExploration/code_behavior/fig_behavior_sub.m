function plt = fig_behavior_sub(plt, sub, strfront, xlab, col, leg, savename)
    plt.figure(6,4, 'title');
    rats = W.vert(W.extend_char(W.horz(unique(sub.rat)),6,"NA"));
    plt.setfig('xlim', [repmat({''},1,20), repmat({[0.5 6.5]},1,4)], 'color', col, ...
        'xlabel', [repmat({''},1,20) {xlab,xlab,xlab,xlab}], ...
        'ylabel', reshape([W.str2cell(rats) repmat({""}, [6 3])]',1,[]), ...
        'legend', leg, 'title', [{'p(best)','p(unguided)','p(switch)','p(left)'}, repmat({''},1,20)]);
    old_dotsize = plt.param_figsetting.dotsize;
    plt.param_figsetting.dotsize = 7;
    for ri = 1:length(rats)
        tsub = sub(sub.rat == rats(ri),:);
        plt.ax(ri,1);
        plt.lineplot(ff(tsub.([strfront '_cc_best'])),[],[],'-o'   );
        plt.ax(ri,2);
        plt.lineplot(ff(tsub.([strfront '_cc_explore'])),[],[],'-o'    );
        plt.ax(ri,3);
        plt.lineplot(ff(tsub.([strfront '_cc_switch'])),[],[],'-o'	);
        plt.ax(ri,4);
        plt.lineplot(ff(tsub.([strfront '_cc_left'])),[],[],'-o'    );
    end
    plt.update;
    plt.param_figsetting.dotsize = old_dotsize;
    plt.save(savename);
end
function y = ff(x)
    if iscell(x)
        y = vertcat(x{:});
    else
        y = x;
    end
end
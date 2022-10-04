function plt = fig_behavior_gp(plt, gp, strfront, xlab, col, leg, savename)
    plt.figure(1,2);
    plt.setfig('color', {col,col}, ...
        'xlabel', xlab, ...
        'ylabel', {'p(high reward)','p(switch)'}, ...
        'legend', {leg, leg});
    plt.ax(1,1);
    plt.lineplot(ff(gp.(['av_' strfront '_cc_best'])), ff(gp.(['ste_' strfront '_cc_best'])));
    plt.ax(1,2);
%     plt.lineplot(ff(gp.(['av_' strfront '_cc_explore'])), ff(gp.(['ste_' strfront '_cc_explore'])));
%     plt.ax(2,1);
    plt.lineplot(ff(gp.(['av_' strfront '_cc_switch'])), ff(gp.(['ste_' strfront '_cc_switch'])));
%     plt.ax(2,2);
%     plt.lineplot(ff(gp.(['av_' strfront '_cc_left'])), ff(gp.(['ste_' strfront '_cc_left'])));
    plt.update;
    plt.save(savename);
end
function y = ff(x)
    if iscell(x)
        y = vertcat(x{:});
    else
        y = x;
    end
    if size(y,2) > 15
        y = y(:,1:15);
    end
end
% function plt = fig_behavior_gp(plt, gp, strfront, xlab, col, leg, savename)
%     plt.figure(2,2);
%     plt.setfig('color', col, ...
%         'xlabel', xlab, ...
%         'ylabel', {'p(best)','p(unguided)','p(switch)','p(left)'}, ...
%         'legend', leg);
%     plt.ax(1,1);
%     plt.lineplot(ff(gp.(['av_' strfront '_cc_best'])), ff(gp.(['ste_' strfront '_cc_best'])));
%     plt.ax(1,2);
%     plt.lineplot(ff(gp.(['av_' strfront '_cc_explore'])), ff(gp.(['ste_' strfront '_cc_explore'])));
%     plt.ax(2,1);
%     plt.lineplot(ff(gp.(['av_' strfront '_cc_switch'])), ff(gp.(['ste_' strfront '_cc_switch'])));
%     plt.ax(2,2);
%     plt.lineplot(ff(gp.(['av_' strfront '_cc_left'])), ff(gp.(['ste_' strfront '_cc_left'])));
%     plt.update;
%     plt.save(savename);
% end
% function y = ff(x)
%     if iscell(x)
%         y = vertcat(x{:});
%     else
%         y = x;
%     end
% end
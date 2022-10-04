function plt = ratfig_behavior_sub(plt, sub)
    col = {'AZblue','AZred','AZcactus'};
    col2 = {'AZblue','AZblue50','AZred','AZred50','AZcactus', 'AZcactus50'};
    leg = {'h = 1', 'h = 6', 'h = 15'};
    leg2 = {'h = 1, bad', 'h = 1, good','h = 6, bad', 'h = 6, good' ,'h = 15, bad', 'h = 15, good'}
    %% by trial number
    plt.setfig_new;
    plt = fig_behavior_sub(plt, sub, 'av', 'trial number', col, ...
        leg, ['gp_av']);

    %% by good/bad guide
    plt.setfig_new;
    plt = fig_behavior_sub(plt, sub, 'bin_all', 'trial number', col2, ...
        leg2, ['gp_acG']);
   
    %% by R guided
    plt.setfig_loc('xtick', 1:6, 'xticklabel', 0:5);
    plt = fig_behavior_sub(plt, sub, 'bin_all', 'R guided', col, ...
        leg, ['gp_rG']);
    
     %% by gameID
    plt.setfig_new;
    plt = fig_behavior_sub(plt, sub, 'gameID_bin_all_c1', 'game ID', col, ...
        leg, ['gp_gameID']);
    
    
    %% by gameID perc
    plt.setfig_new;
    plt = fig_behavior_sub(plt, sub, 'gameIDperc_bin_all_c1', 'game ID perc', col, ...
        leg, ['gp_gameIDperc']);
end
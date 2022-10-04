%% 11/22/2019
folder = 'U:\Data1\SiyuTaskfiles';
generate_pilot_3lv(4, 6, 90, [1 3 5 7], [1 5], 1, folder);
%% alternation
folder = 'U:\Data1\SiyuTaskfiles';
game = generate_alternation_dp15(3, 6, 130, [1 7], [1 5], 2, folder);
%% phase 2
folder = 'U:\Data1\SiyuTaskfiles';
game = generate2(3, 6, 130, [1 7], [1 5], 4, folder);
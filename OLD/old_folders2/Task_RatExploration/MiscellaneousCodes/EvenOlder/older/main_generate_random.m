folder = 'U:\Data1\SiyuTaskfiles';
[a] = generate_random_v2(200, 20, 3, folder);
%%
folder = 'U:\Data1\SiyuTaskfiles';
[a] = generate_random_v2(100, 20, 1, folder);
%%
folder = 'U:\Data1\SiyuTaskfiles';
[feeders, rewards] = generate_horizon_v5(20, 10, 20, [1 9], folder);
%% hard code v1 
folder = 'U:\Data1\SiyuTaskfiles';
previousday = [5,8,2,9,1; 1,4,6,9,1; 5,2,8,1,9; 1,6,4,1,9];
day1 = [1,4,6,9,1; 5,2,8,9,1; 1,6,4,9,1; 5,8,2,1,9; 1,4,6,9,1; 5, 8, 2, 9, 1];
[feeders, rewards] = generate_horizon_v6(day1, [8,16], 20, [1 9], folder);
%%
folder = 'U:\Data1\SiyuTaskfiles';
generate_feedertest(10, 20, 9, folder);
%% 080819
N = 20;
homebase = [1 8];
cond_horizon = [10 20];
[feeders, rewards] = generate_horizon_v7(N, homebase, cond_horizon, 0.5, 20, [1 9], folder);

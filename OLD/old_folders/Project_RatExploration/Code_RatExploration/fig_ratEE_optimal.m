rs = [0 1 2 3 5];
nLv = length(rs);
ps = ones(nLv, nLv)/(nLv - 1);
ps(eye(nLv) == 1) = zeros(1, nLv);
Hs = 1:20;
isRRGuided = 2;
[thetas,as,dEV] = RatEE_optimal_discreteconstantrewards(rs, ps, Hs, isRRGuided);
%% probabilistic 

%% distribution of rs being not uniform
rs = [0 1 2 3 5];
nLv = length(rs);
ps = repmat([1 2 3 2 1],5,1);
ps(eye(nLv) == 1) = zeros(1, nLv);
ps = ps./sum(ps,2);
Hs = 1:20;
isRRGuided = 2;
[thetas,as,dEV] = RatEE_optimal_discreteconstantrewards(rs, ps, Hs, isRRGuided);
%% 
%%
figure;
plot(dEV);
hold on;
plot([0, max(Hs)], [0 0], '--r');
ylim([-4 3]);
legend([arrayfun(@(x)sprintf('R = %d', x), rs, 'UniformOutput', false)]);
xlabel('Horizon');
ylabel('EV(explore) - EV(exploit)');
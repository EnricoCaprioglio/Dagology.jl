using Dagology
using LightGraphs
using BenchmarkTools
import Random
Random.seed!(54)

##########################################################################
# for all tests you need to run the following
N = 1000; d = 2; p = 1.5; perc = 15; prob = 1.0;
# max_R = d_minkowski(ones(N), zeros(N), d, p0);
max_R = Inf64
(pos, g) = cube_space_digraph(N, d, max_R*perc/100)

##########################################################################
@benchmark (pos, g) = cube_space_digraph(N, d, max_R*perc/100, p, prob)
@btime (pos, g) = static_cube_space(N, d, max_R*perc/100, p, prob)
@btime (pos, g) = cone_space_digraph(N, d, max_R*perc/100, prob)

##########################################################################
@btime topological_sort_by_dfs(g)
@btime my_TopSort_by_dfs(g)
# my Topological Sort function seems to be quicker but that seems quite
# weird, there might be some mistakes or some cases I have not considered
# keep this in mind.

##########################################################################
(pos, g) = cone_space_digraph(N, d, max_R*perc/100, prob)
order = topological_sort_by_dfs(g);     # using lightGraphs function

@btime dist = my_sslp(g, order, 1)
@btime dist = my_sslp_v2(g, order, 1)

# Redefine weigths to use them for shortest path algorithms
new_weights = weights(g).*(-1)
ds = dijkstra_shortest_paths(g,1,new_weights)
ds.dists
ds2 = dijkstra_shortest_paths(g,1)
ds2.dists
# Check "dijkstra longest paths comparison" in longest_path_test.jl for comparison
# between my single source longest path algorithm output and dijkstra algorithm
# used to find the longest path.

##########################################################################
# Benchmark dijkstra_shortest_paths and compare with my_sslp
p = 1.5; N = 1000; d = 2; perc = 15;
max_R = Inf64
(pos, g) = cube_space_digraph(N, d, max_R*perc/100, p);
order = topological_sort_by_dfs(g);
dist = my_sslp(g, order, 1)
new_weights = weights(g).*(-1);
ds = dijkstra_shortest_paths(g,1,new_weights)
@test dist == ds.dists.*(-1)
@btime my_sslp(g, order, 1)
@btime dijkstra_shortest_paths(g,1,new_weights)
# so my_sslp uses MORE memory but it's faster.

# TODO: understand why when max_R is different the two
# algorithms find some paths differently.

##########################################################################
# compare with static DiGraph
(pos, g) = static_cube_space(N, d, max_R*perc/100, p);
order = topological_sort_by_dfs(g);     # using lightGraphs function
new_weights = weights(g).*(-1);
@btime ds = dijkstra_shortest_paths(g,1,new_weights)

store_e = zeros(1000)
for i in 1:1000
    (pos, g) = cube_space_digraph(1000, 2, Inf*perc/100, 2, 1)
    store_e[i] = g.ne
end
mean(store_e)
std(store_e)
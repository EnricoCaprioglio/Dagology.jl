using Dagology
using LightGraphs
using BenchmarkTools
import Random
Random.seed!(54)

##########################################################################
# for all tests you need to run the following
N = 100; d = 2; p0 = 1.5; fraction = 1;
# max_R = d_minkowski(ones(N), zeros(N), d, p0);
max_R = Inf64
(pos, g) = cube_space_digraph(N, d, max_R/fraction)

##########################################################################
@btime (pos, g) = cube_space_digraph(N, d)
@btime (pos, g) = static_cube_space(N, d, max_R/fraction)
@btime (pos, g) = cone_space_digraph_test(N, d, 1, Inf64)

##########################################################################
@btime topological_sort_by_dfs(g)
@btime my_TopSort_by_dfs(g)
# my Topological Sort function seems to be quicker but that seems quite
# weird, there might be some mistakes or some cases I have not considered
# keep this in mind.

##########################################################################
(pos, g) = static_cube_space(N, d, max_R/fraction)
order = topological_sort_by_dfs(g);     # using lightGraphs function

@btime dist = my_sslp(g, order, 1)
@btime dist = my_sslp_v2(g, order, 1)
# quite interestingly my_sslp_faster is actually slower than my_sslp
new_weights = weights(g).*(-1)
ds = dijkstra_shortest_paths(g,1,new_weights)
ds.dists
ds2 = dijkstra_shortest_paths(g,1)
ds2.dists

##########################################################################
# Benchmark dijkstra_shortest_paths and compare with my_sslp
N = 10000; d = 2;
p0 = 1.5; fraction = 5;
max_R = d_minkowski(ones(N), zeros(N), d, p0);
(pos, g) = cube_space_digraph(N, d, max_R/fraction, p0);
order = topological_sort_by_dfs(g);     # using lightGraphs function
@btime my_sslp(g, order, 1)
dist = my_sslp(g, order, 1)
new_weights = weights(g).*(-1);
@btime dijkstra_shortest_paths(g,1,new_weights)
ds = dijkstra_shortest_paths(g,1,new_weights)
dist == ds.dists.*(-1)
# so my_sslp uses more memory but it's faster

##########################################################################
# compare with static DiGraph
(pos, g) = static_cube_space(N, d, max_R/fraction, p0);
order = topological_sort_by_dfs(g);     # using lightGraphs function
new_weights = weights(g).*(-1);
@btime ds = dijkstra_shortest_paths(g,1,new_weights)
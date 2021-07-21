using Dagology
using LightGraphs

# Benchmark functions
using BenchmarkTools
@btime topological_sort_by_dfs(g)
@btime my_TopSort_by_dfs(g)
# my Topological Sort function seems to be quicker but that seems quite
# weird, there might be some mistakes or some cases I have not considered
# keep this in mind.

@btime dist = my_sslp(g, order, start)
@btime dist = my_sslp_v2(g, order, start)
# quite interestingly my_sslp_faster is actually slower than my_sslp
##########################################################################
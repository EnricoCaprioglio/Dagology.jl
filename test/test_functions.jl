
using Dagology
using LightGraphs
using GraphPlot
using Test

##########################################################################
# create test DAG
N = 30;
E = N*5;
g = SimpleDiGraph(N);
for i in 1:E
    a = rand(1:N)
    b = rand(1:N)
    if b > a
        add_edge!(g, a, b)
    end
end

##########################################################################
# plot test graph
order = topological_sort_by_dfs(g);
@test topological_sort_by_dfs(g) == my_TopSort_by_dfs(g)
# from https://juliagraphs.org/GraphPlot.jl/
# begin #
using Colors
nodesize =  [LightGraphs.outdegree(g, v) for v in LightGraphs.vertices(g)];
alphas = nodesize/maximum(nodesize);
nodefillc = [RGBA(0.0,0.8,0.8,i) for i in alphas];
# end #
layout=(args...)->spring_layout(args...; C=100)
gplot(g, nodelabel=collect(1:N), layout=layout, nodefillc=nodefillc, linetype="curve")
# save to png
using Compose, Cairo
draw(PNG("test_graph.png", 16cm, 16cm), gplot(g, nodelabel=collect(1:N), layout=layout, nodefillc=nodefillc, linetype="curve"))
g.fadjlist    # out degree adjacency list
g.badjlist    # in degree adjacency list
g.ne          # number of edges
# get longest path
start = find_sources(g)[1]
dist = my_sslp(g, order, start, true)
longest_path = maximum(dist)

########################################################
using LightGraphs
N = 30;
g = SimpleDiGraph(N); # this is a digraph
for i in 1:3:N-1
    add_edge!(g, i, i+3)
end
gplot(g, nodelabel=collect(1:N))
order = topological_sort_by_dfs(g)
start = 1;
dist = my_sslp(g, order, start)
longest_path = maximum(dist)
for i in 1:2:N-1
    add_edge!(g, i, i+2)
end
length(collect(1:2:N-1))

###############################################################
# another test
N = 1000;
(bbox_space, g) = box_space_digraph(N, 3)
size(g)
using Dagology
degree_distr(g)
order = topological_sort_by_dfs(g)
starts = find_sources(g);
start = starts[1]
N = Int64(size(g)[1])
# gplot(g, nodelabel=collect(1:N))
dist = my_sslp(g, order, start)
longest_path = maximum(dist)

old_node = 1;
increment = round(Int, N/longest_path)
for i in 1:longest_path+1
    new_node = rand(old_node+1:old_node+increment)
    add_edge!(g, old_node, new_node)
    print(old_node, " and ", new_node, "\n")
    old_node = copy(new_node);
end

order = topological_sort_by_dfs(g)
dist = my_sslp(g, order, 1)
longest_path = maximum(dist)

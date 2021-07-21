using Dagology
using Test
using LightGraphs

@test true # just to check everything is working fine

# test degree_distr
@testset "degree distribution" begin
    A = rand(1000, 2)*1000;
    g = SimpleDiGraph(size(A)[1]); # this is a digraph
    # typeof(g)
    for i in 1:size(A)[1]
        add_edge!(g, round(Int, A[i,1]), round(Int, A[i,2]))
    end
    g.fadjlist # out degree adjacency list
    g.badjlist # in degree adjacency list
    g.ne       # number of edges
    # test function
    k_out, k_in = degree_distr(g);
    @test length(k_out) == size(A)[1]
    @test length(k_in) == size(A)[1]
    # count(i->(i!=0), k_out) # check edges have been added
end

# example of Longest path using imported package from networkx
using PyCall
nx = pyimport("networkx")
# if pyimport doesn't work add the python package using Conda as follows
# using Conda
# Conda.add("PackageName")
graph = nx.DiGraph()
graph.add_edges_from([("root", "a"), ("a", "b"), ("a", "e"), ("b", "c"), ("b", "d"), ("d", "e")])
nx.algorithms.dag.dag_longest_path(graph)

##########################################################################
# example test using LightGraphs
using LightGraphs
g = SimpleDiGraph(13); # this is a digraph
add_edge!(g, 1, 4);
add_edge!(g, 5, 1);
add_edge!(g, 5, 4);
add_edge!(g, 5, 6);
add_edge!(g, 6, 10);
add_edge!(g, 6, 11);
add_edge!(g, 11, 10);
add_edge!(g, 10, 12);
add_edge!(g, 3, 1);
add_edge!(g, 3, 2);
add_edge!(g, 2, 4);
add_edge!(g, 4, 7);
add_edge!(g, 7, 9);
add_edge!(g, 4, 8);
add_edge!(g, 8, 10);
add_edge!(g, 8, 9);
add_edge!(g, 9, 12);
add_edge!(g, 10, 13);

# second test using box_space_digraph()
(positions, g) = box_space_digraph(1000, 2);

# third test using cone_space_digraph()
(positions, g) = cone_space_digraph(15, 2);

##########################################################################
# plot test graph
using GraphPlot
# nodelabel = ["A","B","C","D","E","F","G","H","I","J","K","L","M"];
nodesize = [LightGraphs.outdegree(g, v) for v in LightGraphs.vertices(g)];
N = Int32(size(g)[1]);
DAG_Plot_2D(positions, g)
gplot(g, nodelabel=collect(1:N), layout=circular_layout) # nodesize = nodesize 
g.fadjlist    # out degree adjacency list
g.badjlist    # in degree adjacency list
g.ne          # number of edges

##########################################################################
# test functions
# compare my TopSort to LightGraphs function
@test my_TopSort_by_dfs(g) == topological_sort_by_dfs(g)
# for large graphs there seem to be differences between the two
# topological sorting functions. Recall it is not unique the
# toplogical order from a single DAG. However this is transitive
# so I am not sure it is fine.
order = topological_sort_by_dfs(g);     # using lighgraphs function
starts = find_sources(g);
start = round(Int, starts[1]);

@test my_sslp(g, order, start) == my_sslp_v2(g, order, start)
dist = my_sslp(g, order, start)
# dist = my_sslp_v2(g, order, start)
maximum(dist)
# TODO make list integers


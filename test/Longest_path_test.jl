using Dagology
using Test
using LightGraphs
using LinearAlgebra
using GraphPlot

###########################################################################
# Test DAG Longest Path
@testset "Longest path test" begin
    N = 61;
    g = SimpleDiGraph(N);
    increment = 2;
    set_longestpath = round(Int, N/increment)
    old_node = 1;
    for i in 1:set_longestpath
        new_node = old_node+increment;
        add_edge!(g,old_node,new_node);
        old_node = new_node;
    end
    set_testpath = 10;
    for j in 4:2:(N-set_testpath-3)
        old_node = j;
        for i in 1:set_testpath
            new_node = old_node+increment;
            add_edge!(g,old_node,new_node);
            old_node = new_node;
        end
    end
    @test is_cyclic(g) == false
    order = topological_sort_by_dfs(g);     # using lightGraphs function
    sources = find_sources(g);
    sinks = find_sinks(g)
    longest_path_store = zeros(N);
    for start in sources
        if start in sinks
            continue
        else
            dist = my_sslp(g, order, start);
            ending = findall(x->(x==maximum(dist)), dist);
            longest_path_store[start] = maximum(dist);
            @test maximum(longest_path_store) == set_longestpath
        end
    end
end

###########################################################################
# test using cube_space_digraph
# lim_{N --> \infty} L = m_x N^{1/D}
# for D = 2 we have m_{Cu(D)} = 2
# let\s test this

D = 2;
for N in 10:100:1000
    longest = 0;
    for j in 1:100
        pos, g = cube_space_digraph(N, D);
        longest_arr = my_sslp(g, topological_sort_by_dfs(g), find_sources(g)[1])
        longest += maximum(longest_arr)
    end
    println("This is the longest path average: ", longest/100)
    println("Expected longest path length: ", 2*(N)^(1/D), "\n")
end
# this doesn't seem to be accurate

D=2;
for N in 10:20
    pos, g = cube_space_digraph(N, D);
    starts = find_sources(g);
    for start in starts
        longest_arr = my_sslp(g, topological_sort_by_dfs(g), start)
        longest = maximum(longest_arr)
        println("this is longest path: $longest, with source: $start and N: $N")
    end
end
# TODO understand why some sources != 1 have a longest path than source 1
# IDEA always have a source set at coordinates (0, 0, ..., 0)

###########################################################################
N = 15;
(positions, g) = cube_space_digraph(N, 3, 1.0);
# g.fadjlist
using Colors
nodesize =  [LightGraphs.outdegree(g, v) for v in LightGraphs.vertices(g)];
alphas = nodesize/maximum(nodesize);
nodefillc = [RGBA(0.0,0.8,0.8,i) for i in alphas];
# end #
layout=(args...)->spring_layout(args...; C=100)
gplot(g, nodelabel=collect(1:N), layout=layout, nodefillc=nodefillc, linetype="curve")
sources = find_sources(g);
sinks = find_sinks(g)
order = topological_sort_by_dfs(g);
for start in sources
    if start in sinks
        println("$start is both a source and a sink")
        continue
    else
        dist = my_sslp(g, order, start)
        ending = findall(x->(x==maximum(dist)), dist);
        println("Longest path from $start to $ending is $(maximum(dist))")
    end
end


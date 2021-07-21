using Base: Int32, Int64
using LightGraphs

function find_sources(g::SimpleDiGraph{Int64})
    """
    find_source(g::SimpleDiGraph{Int64})

    returns an array containing the nodes with
    in-degree equal to Zero, i.e. k^{in} = 0
    """
    return findall(x->(x==0), [length(i) for i ∈ g.badjlist])
end

# Depth First Search function for ordering
function _dfs_for_TopSort(index, start, visited, order, g)
    visited[start] = true;
    neigh = g.fadjlist[start]; # get neighbours of starting node
    for v in neigh
        if visited[v] == false
            index, visited, order = _dfs_for_TopSort(index, v, visited, order, g);
        end
    end
    order[index] = round(Int, start)
    return index-1, visited, order
end

# My version of topological sort function
# notice the packaeg LighGraphs has the similar function
# topological_sort_by_dfs, I need to check what are the differences
function my_TopSort_by_dfs(g::SimpleDiGraph{Int64})
    index = Int64(size(g)[1]);
    visited = falses(size(g)[1]);
    order = zeros(size(g)[1]);
    starts = find_sources(g);
    for start in starts
        index, visited, order = _dfs_for_TopSort(index, start, visited, order, g);
    end
    return Array{Int64}(order)
end

# Single Source Longest Path
# this function outputs all the longest distances
# from starting node to any other node > starting node
function my_sslp(g::SimpleDiGraph{Int64}, order::Array{Int64, 1}, start::Int64)
    N = Int64(size(g)[1]);
    get_pos = findall(x->(x==start), order);
    dist = zeros(N).-Inf;
    dist[start] = 0;
    # loop over all elements > start in the top_sort poset
    # exclude elements that cann't be reached by node start
    for (top_sort_i, elem) ∈ enumerate(order[get_pos[1]:end])
        neigh_arr = g.fadjlist[elem];
        counter = Int64(1);
        neigh_index = Int64(1);
        while counter <= length(neigh_arr)
            neigh = order[top_sort_i+neigh_index];
            if neigh ∈ neigh_arr
                new_dist = dist[elem] + 1;
                dist[neigh] = maximum([new_dist, dist[neigh]])
                counter += 1; # neighbour found, move to next
            end
            neigh_index += 1; # to find next element of topsort
        end
    end
    return dist
end

function _relax_neighs(dist::Array{Float64}, elem, g)
    neigh_arr = g.fadjlist[elem];
    for neigh in neigh_arr
        new_dist = dist[elem] + 1;
        dist[neigh] = maximum([new_dist, dist[neigh]])
    end
    return dist
end

function my_sslp_v2(g::SimpleDiGraph{Int64}, order::Array{Int64, 1}, start::Int64)
    N = Int64(size(g)[1]);
    get_pos = findall(x->(x==start), order);
    dist = zeros(N).-Inf;
    dist[start] = 0;
    _relax_neighs(dist, start, g)
    for (top_sort_i, elem) ∈ enumerate(order[get_pos[1]:end])
        if dist[elem] != -Inf;
            dist = _relax_neighs(dist, elem, g)
        else
            continue
        end
    end
    return dist
end

##########################################################################
# example test
using LightGraphs
g = SimpleDiGraph(13); # this is a digraph
typeof(g)
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

##########################################################################
# plot test graph
using GraphPlot
nodelabel = ["A","B","C","D","E","F","G","H","I","J","K","L","M"];
nodesize = [LightGraphs.outdegree(g, v) for v in LightGraphs.vertices(g)];
gplot(g, nodelabel=collect(1:13)) # nodesize = nodesize
g.fadjlist    # out degree adjacency list
g.badjlist    # in degree adjacency list
g.ne          # number of edges

##########################################################################
# test functions defined above
order = my_TopSort_by_dfs(g);
typeof(order)
order = topological_sort_by_dfs(g);
typeof(order)
starts = find_sources(g);
start = round(Int, starts[1]);

dist = my_sslp(g, order, start)
dist = my_sslp_v2(g, order, start)

##########################################################################
# Benchmark functions
using BenchmarkTools
@btime topological_sort_by_dfs(g)
@btime my_TopSort_by_dfs(g)
# my Topological Sort function seems to be quicker but that seems quite
# weird, there might be some mistakes or some cases I have not considered
# keep this in mind.

@btime dist = my_sslp(g, order, start)
@btime dist = my_sslp_faster(g, order, start)
# quite interestingly my_sslp_faster is actually slower than my_sslp
##########################################################################

using Test


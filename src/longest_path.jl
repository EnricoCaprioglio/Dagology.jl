# We are going to use topological sort by dfs from
# LightGraphs package
# topological_sort_by_dfs(g)

using LightGraphs

function find_sources(g)
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

function my_TopSort_by_dfs(g::SimpleDiGraph{Int64})
    index = size(g)[1];
    visited = falses(size(g)[1]);
    order = zeros(size(g)[1]);
    starts = find_sources(g);
    for start in starts
        index, visited, order = _dfs_for_TopSort(index, start, visited, order, g);
    end
    return order
end

# Single Source Shortest Path
# this function outputs all the shortest distances
# from starting node to any other node > starting node
function _dfs_for_sssp(g, start, dist, count)
    neigh = g.fadjlist[start]; # get neighbours of starting node
    new_dist = zeros(length(dist));
    for v in neigh
        new_dist[v] = 1 +  new_dist[start]
        if visited[v] == false
            count += 1;
            count = _dfs_for_sssp(g, start, dist, count)
        end
    end
    return count
end

function sssp(g, start)
    N = size(g)[1];
    order = topological_sort_by_dfs(g);
    get_pos = findall(x->(x==start), order);
    max_dist = (N-get_pos)
    dist = zeros(N).+max_dist;
    for i ∈ order[get_pos:end]
        # dist = _dfs_for_sssp(g, dist)
    end
end

function sssp(g, start)
    N = size(g)[1];
    order = topological_sort_by_dfs(g);
    get_pos = findall(x->(x==start), order);
    max_dist = (N-get_pos)
    dist = zeros(N).+max_dist;
    dist[start] = 0;
    for i ∈ order[get_pos:end]
        # dist = _dfs_for_sssp(g, dist)
    end
end

# the longest path is simply the exact same function
# for the shortest path but instead of adding 1 at each
# step to calculated the distance we add -1, then
# the shortest distance will actually be the longest.


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
using GraphPlot
nodelabel = ["A","B","C","D","E","F","G","H","I","J","K","L","M"];
nodesize = [LightGraphs.outdegree(g, v) for v in LightGraphs.vertices(g)];
gplot(g, nodelabel=collect(1:13)) # nodesize = nodesize
g.fadjlist    # out degree adjacency list
g.badjlist    # in degree adjacency list
g.ne          # number of edges


##########################################################################
# sssp tests
N = size(g)[1];
order = topological_sort_by_dfs(g);
start = 8;
get_pos = findall(x->(x==start), order);
max_dist = (N-get_pos[1])
dist = zeros(N).+(max_dist+1);
dist[start] = 0;
for i ∈ order[get_pos[1]:end]
    neigh = g.fadjlist[start];
    
    # dist = _dfs_for_sssp(g, dist)
end

##########################################################################
# test functions defined above
my_TopSort_by_dfs(g)

find_sources(g);

using BenchmarkTools
@btime topological_sort_by_dfs(g)
@btime my_TopSort_by_dfs(g)
# my Topological Sort function seems to be quicker but that seems quite
# weird, there might be some mistakes or some cases I have not considered
# keep this in mind.
##########################################################################

using Test


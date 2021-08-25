using Base: Int32, Int64
using LightGraphs
using Distributions

"""
    find_source(g::SimpleDiGraph{Int64})

    returns an array containing the nodes with
    in-degree equal to Zero, i.e. k^{in} = 0
"""
function find_sources(g::SimpleDiGraph{Int64})
    return findall(x->(x==0), [length(i) for i ∈ g.badjlist])
end

"""
    find_sinks(g::SimpleDiGraph{Int64})

    returns an array containing the nodes with
    in-degree equal to Zero, i.e. k^{in} = 0
"""
function find_sinks(g::SimpleDiGraph{Int64})
    return findall(x->(x==0), [length(i) for i ∈ g.fadjlist])
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
# notice the package LighGraphs has the similar function
# topological_sort_by_dfs, I need to check what are the differences
"""
Simple implementation of DFS algorithm to find the topological order of a DAG.
Recall, the topological order of a DAG is not unique.

Only one input:
    g::SimpleDiGraph{Int64}     The DAG

output:
    order::Array{Int64}         A list with elements in the topological order

"""
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

# TODO: add docstring for my_sslp

# Single Source Longest Path
# this function outputs all the longest distances
# from starting node to any other node > starting node
"""

"""
function my_sslp(g::SimpleDiGraph{Int64}, order::Array{Int64, 1},
    start::Int64, print = false)
    N = Int64(size(g)[1]);
    get_pos = findall(x->(x==start), order);        # get starting position
    dist = zeros(N).-typemax(Int64);                           # initialize distance array
    dist[start] = 0;
    # loop over all elements > start in the top_sort poset
    # exclude elements that can't be reached by node start
    for (top_sort_i, elem) ∈ enumerate(order[get_pos[1]:end])
        if print
            println("\n We are at element: $elem, in place $top_sort_i in the TopSort order,
            element $elem is at distance: $(dist[elem]) from the source $start.")
        end
        if dist[elem] == -typemax(Int64)       # no path between source and elem
            continue
        else                        # update neighbours distances
            neigh_arr = g.fadjlist[elem];
            for neigh in neigh_arr
                dist[neigh] = maximum([(dist[elem] + 1), dist[neigh]]);
                if print
                    println("The distance of $neigh, neighbour of $elem, is $(dist[neigh])")
                end
            end
        end
    end
    return convert(Vector{Int64}, dist)
end

# function used for my second version of single source longest path algorithm
function _relax_neighs(dist::Array{Float64}, elem, g)
    neigh_arr = g.fadjlist[elem];
    for neigh in neigh_arr
        new_dist = dist[elem] + 1;
        dist[neigh] = maximum([new_dist, dist[neigh]])
    end
    return dist
end

# Just a second version of the single source longest path algorithm.
# Not sure if calling anoter function to relax the disatnces is faster or
# slower.
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

function get_longest_path_vertices(adjlist, dists, pos, p)
    d = length(pos[1,:]);
    value_longest_path = maximum(dists)
    vertex_longest_path = findall(x -> x == value_longest_path, dists)[1]
    longest_path_vertices = Vector{Int64}();
    push!(longest_path_vertices, vertex_longest_path)
    next_vertex = vertex_longest_path;
    for i in 1:value_longest_path
        check_vertex = next_vertex;
        if check_vertex == 1
            break
        end
        neigh_dists = Vector{Int64}();
        neighbours = adjlist[check_vertex]
        for j in neighbours                  # find next vertex in the path from in-degree
            push!(neigh_dists, dists[j])
        end
        index = findall(x -> x == value_longest_path-i, neigh_dists)
        if length(index) > 1                 # choose the closest vertex
            conflicting_distances = [];
            for l in 1:length(index)
                vertex_to_check = neighbours[index[l]]
                push!(conflicting_distances, 
                d_minkowski(pos[check_vertex,:], pos[vertex_to_check,:], d, p))
            end
            index2 = findmin(conflicting_distances)[2]  # get index lowest distance
            next_vertex = neighbours[index[index2]]
            if 1 in neighbours[index[1]:index[end]]
                println("this happened")
                next_vertex = 1
            end
        else
            next_vertex = neighbours[index[1]]
        end
        push!(longest_path_vertices, next_vertex)
    end
    return longest_path_vertices
end

function get_shortest_path_vertices(adjlist, dists, dst, pos, p)
    d = length(pos[1,:]);
    value_shortest_path = dists[dst]
    shortest_path_vertices = Vector{Int64}();
    push!(shortest_path_vertices, dst)
    next_vertex = dst;
    for i in 1:value_shortest_path
        check_vertex = next_vertex;
        if check_vertex == 1
            break
        end
        neigh_dists = Vector{Int64}();
        neighbours = adjlist[check_vertex]
        for j in neighbours                  # find next vertex in the path from in-degree
            push!(neigh_dists, dists[j])
        end
        index = findall(x -> x == value_shortest_path-i, neigh_dists)
        if length(index) > 1                 # choose the closest vertex
            conflicting_distances = [];
            for l in 1:length(index)
                vertex_to_check = neighbours[index[l]]
                push!(conflicting_distances, 
                d_minkowski(pos[check_vertex,:], pos[vertex_to_check,:], d, p))
            end
            index2 = findmin(conflicting_distances)[2]  # get index lowest distance
            next_vertex = neighbours[index[index2]]
            if 1 in neighbours
                println("this happened")
                next_vertex = 1
            end
        else
            next_vertex = neighbours[index[1]]
        end
        push!(shortest_path_vertices, next_vertex)
    end
    return shortest_path_vertices
end

"""

"""
function long_vs_short_path(N, d, p, max_R, fraction)
    (pos, g) = cube_space_digraph(N, d, max_R/fraction, p);
    adjlist = g.badjlist;
    # find longest path
    dists = my_sslp(g, topological_sort_by_dfs(g), 1);
    value_longest_path = maximum(dists);
    vertex_longest_path = findall(x -> x == value_longest_path, dists)[1];
    longest_path_vertices = get_longest_path_vertices(adjlist, dists, pos, p);
    # find shertest path
    dst = longest_path_vertices[1];
    ds = dijkstra_shortest_paths(g,1,weights(g));
    shortest_path_vertices = get_shortest_path_vertices(adjlist, ds.dists, dst, pos, p);
    # calculate distance:
    long_sum = 0;
    for i in 1:(length(longest_path_vertices)-1)
        x_index = longest_path_vertices[i]
        y_index = longest_path_vertices[i+1]
        x = pos[x_index,:]
        y = pos[y_index,:]
        long_sum += d_minkowski(x,y,d,p)
    end
    short_sum = 0;
    for i in 1:(length(shortest_path_vertices)-1)
        x_index = shortest_path_vertices[i]
        y_index = shortest_path_vertices[i+1]
        x = pos[x_index,:]
        y = pos[y_index,:]
        short_sum += d_minkowski(x,y,d,p)
    end
    return long_sum, short_sum
end
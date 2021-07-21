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



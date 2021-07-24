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

##########################################################################
# check box_space digraph is a DAG
@testset "is cube space digraph cyclic" begin
    for N in 2:100
        (positions, g) = cube_space_digraph(N, 3);
        @test is_cyclic(g) == false
    end
end
# check cone_space digraph is a DAG
@testset "is cone space digraph cyclic" begin
    p = 1; R = 2;
    (positions, g) = cone_space_digraph(1000, 3, p, R);
    @test is_cyclic(g) == false
end
# TODO fix cone_spaec_digraph

using LongestPaths
n = 10
g1 = path_digraph(n)

# from LongestPaths by
# https://github.com/GunnarFarneback/LongestPaths.jl/blob/master/test/runtests.jl
# begin #
abstract type AbstractWeightedPath{T} end
struct UnweightedPath <: AbstractWeightedPath{Int} end
function dfs_longest_path(g::AbstractGraph{T}, weights, first_vertex,
        last_vertex = 0) where T
    visited = falses(nv(g))
    path = Vector{T}()
    longest_path = Vector{T}()
    push!(path, first_vertex)
    visited[first_vertex] = true
    recurse_dfs_longest_path!(g, weights, last_vertex, visited,
            path, longest_path)
    return longest_path
end

function recurse_dfs_longest_path!(g, weights, last_vertex, visited,
             path, longest_path)
    v = path[end]
    if (last_vertex == 0 || v == last_vertex) && (isempty(longest_path) || path_length(path, weights) > path_length(longest_path, weights))
        resize!(longest_path, length(path))
        copyto!(longest_path, path)
    end
    if v == last_vertex
        return
    end
    for n in outneighbors(g, v)
            if !visited[n]
            push!(path, n)
            visited[n] = true
            recurse_dfs_longest_path!(g, weights, last_vertex, visited, path,
                            longest_path)
            visited[n] = false
            pop!(path)
        end
    end
end

function path_length(path, weights::Dict{Tuple{Int, Int}, <:Any})
    L = 0
    for k = 2:length(path)
        L += weights[(path[k - 1], path[k])]
    end
    return L
end
# end #

function get_weights(g) # this is just to be able to use the above functions
    weight = Dict();
    for i in 1:length(g.fadjlist)
        for j in 1:length(g.fadjlist[i])
            if length(g.fadjlist[i]) != 0
                weight[(i, g.fadjlist[i][j])] = 1;
            end
        end
    end
    return weight
end

##########################################################################
# test Topological Sort
# compare my TopSort to LightGraphs function
@testset "Topological sort" begin
    for N in 2:100
        (positions, g) = box_space_digraph(N, 3);
        @test my_TopSort_by_dfs(g) == topological_sort_by_dfs(g);
    end
end
# for large graphs there seem to be differences between the two
# topological sorting functions. Recall it is not unique the
# toplogical order from a single DAG.
# TODO try using transitive DAGs to test the function

###########################################################################
# Test DAG Longest Path
N = 10;
(positions, g) = cube_space_digraph(N, 2, 0.7);
# g.fadjlist
gplot(g, nodelabel = collect(1:N), layout = circular_layout)
order = topological_sort_by_dfs(g);     # using lightGraphs function
starts = find_sources(g);
# Store Longest paths in a dictionary for each source
longest_path_dict = Dict()
weight = get_weights(g);
for start in starts
    # @test my_sslp(g, order, start) == my_sslp_v2(g, order, start)
    dist = my_sslp(g, order, start)
    ending = findall(x->(x==maximum(dist)), dist);
    longest_path_dict["$start"] = (maximum(dist), ending)
    # Check with LongestPath brute force function, omit weights
    l_path = dfs_longest_path(g, weight, start, ending)
    println(l_path)
end
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

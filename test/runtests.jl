using Dagology
using Test
using LightGraphs

# test degree_distr
g = SimpleDiGraph(); # this is a digraph
typeof(g)
A = rand(1000, 2)*1000;
# for i in 1:size(A)[1]
for i in 1:4
    add_edge!(g, round(Int, A[i,1]), round(Int, A[i,2]))
end

g.fadjlist # out degree adjacency list
g.badjlist # in degree adjacency list
g.ne       # number of vertices
# test function
k_out, k_in = degree_distr(g);
#############################################################


@test true # just to check everything is working fine

@testset "Dagology" begin

end

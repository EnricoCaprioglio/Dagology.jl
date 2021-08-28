using Dagology
using Test
using LightGraphs
using LinearAlgebra

@test true # just to check everything is working fine

# test degree_distr
@testset "degree distribution" begin
    A = rand(1000, 2)*1000;
    g = SimpleDiGraph(size(A)[1]);          # this is a digraph
    for i in 1:size(A)[1]
        add_edge!(g, round(Int, A[i,1]), round(Int, A[i,2]))
    end
    g.fadjlist              # out degree adjacency list
    g.badjlist              # in degree adjacency list
    g.ne                    # number of edges
    # test function
    k_out, k_in = degree_distr(g);
    @test length(k_out) == size(A)[1]
    @test length(k_in) == size(A)[1]
    # count(i->(i!=0), k_out)               # check edges have been added
end

##########################################################################
#########################
# setup data cube space #
#########################
# N = 100; d = 3;
perc = 15; prob = 1.0; p = 2;   # p is the parameter for Minkowski distance

# check box_space digraph is a DAG
@testset "is cube space digraph cyclic" begin
    for N in 2:100:1000
        for d in 1:10
            max_R = d_minkowski(ones(d), zeros(d), d, p);
            R = (max_R/100)*perc
            (pos, g) = cube_space_digraph(N, d, R, p, prob);
            @test is_cyclic(g) == false
        end
    end
end

#########################
# setup data cone space #
#########################
perc = 10; prob = 1.0;
max_R = 1;  # maximum time separation in the system for any d
R = max_R*perc/100

# check cone_space digraph is a DAG
@testset "cone space size test" begin
    N = 100
    for d in [2,3]
        for i in 1:1000
            (pos, g) = cone_space_digraph(N, d, R)
            if pos == 1 && g == 1
                continue
            else
                @test vertices(g).stop == N
                @test is_cyclic(g) == false
            end
        end
    end
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
# topological sort functions. Recall it is not unique the
# toplogical order from a single DAG.
# TODO try using transitive DAGs to test the function

##########################################################################
# test Minkowski distance
@testset "Minkowski distance test" begin
    x = collect(3:5);
    y = collect(6:8);
    d = length(x)
    for p in 0.5:0.1:3
        @test d_minkowski(y,x,length(x),p) == (3^(p)+3^(p)+3^(p))^(1/p)
        # println(d_minkowski(y,x,length(x),p))
        # println("For p = $p we have distance: ", Mink_dist(y,x,d,p))
    end
end
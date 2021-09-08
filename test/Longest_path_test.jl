using Dagology
using Test
using LightGraphs
using LinearAlgebra
using GraphPlot
using Statistics
using SpecialFunctions

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
# test using cube_space_digraph (these tests can be some nice graphs)
# lim_{N --> \infty} L = m_x N^{1/D}
# for D = 2 we have m_{Cu(D)} = 2
# let's test this
@testset "Longest path 2D Cube Space" begin
    D = 2;
    no_test = 10;      # we average over no_test runs
    for k in 1:10
        for N in 10:100:1000
            longest = zeros(no_test);
            for j in 1:no_test
                pos, g = cube_space_digraph(N, D);
                longest_arr = my_sslp(g, topological_sort_by_dfs(g), 1)
                longest[j] = maximum(longest_arr)
            end
            # println("This is the longest path
            # average: $(mean(longest)) ± $(std(longest))")
            # println("Expected longest path length: ", 2*(N)^(1/D), "\n")
            @test mean(longest) < 2*(N)^(1/D)
        end
    end
end

###########################################################################
# m_x is less than c_x but greater than: \frac{c_x*D}{e(gamma(1+D))^{1/D}gamma(1+1/D)}
@testset "Longest path D = 3 Cube Space" begin
    D = 3;
    c_x = ℯ
    no_test = 100;          # we average over no_test runs
    for N in 50:100:1000
        longest = zeros(no_test);
        for j in 1:no_test
            pos, g = cube_space_digraph(N, D);
            longest_arr = my_sslp(g, topological_sort_by_dfs(g), 1)
            longest[j] = maximum(longest_arr)
        end
        avg_longest = mean(longest);
        m_x = avg_longest/(N^(1/D));
        @test ℯ > m_x && m_x > (c_x*D)/(ℯ*(gamma(1+D))^(1/D)*gamma(1+1/D))
    end
end

# TODO: understand why for any D the above test is passed but for
# large N, for N less than 100 something goes wrong.
# for N between 100 and 1000 everything works perfectly fine.
# Use the snippet of code below.

D = 4;
no_test = 100;          # we average over no_test runs
c_x = ℯ                 # this is true only for cube space, i.e. x = Cu(D)
for N in 100:100:600
    longest = zeros(no_test);
    for j in 1:no_test
        pos, g = cube_space_digraph(N, D);
        longest_arr = my_sslp(g, topological_sort_by_dfs(g), 1)
        longest[j] = maximum(longest_arr)
    end
    #println("This is the longest path
    # average: $(mean(longest)) ± $(std(longest))")
    # println("Expected longest path length: ", 2*(N)^(1/D), "\n")
    avg_longest = mean(longest);
    m_x = avg_longest/(N^(1/D));
    check = ℯ > m_x && m_x > (c_x*D)/(ℯ*(gamma(1+D))^(1/D)*gamma(1+1/D));
    println(ℯ > m_x && m_x > (c_x*D)/(ℯ*(gamma(1+D))^(1/D)*gamma(1+1/D)))
    if check == false
        println("this is the avg longest path $avg_longest ± $(std(longest))")
        println("we have found the value $m_x for m_x, smaller than $((c_x*D)/(ℯ*(gamma(1+D))^(1/D)*gamma(1+1/D))), it should be greater.")
    end
end

##########################################################################
# m_x is less than c_x but greater than: \frac{c_x*D}{e(gamma(1+D))^{1/D}gamma(1+1/D)}
@testset "Longest path D = 3 Cone Space" begin
    D = 3;
    c_x = ℯ*((2^(1-1/D)*(gamma(1+D))^(1/D))/(D));
    no_test = 100;          # we average over no_test runs
    for N in 50:100:1000
        longest = zeros(no_test);
        for j in 1:no_test
            pos, g = cube_space_digraph(N, D);
            longest_arr = my_sslp(g, topological_sort_by_dfs(g), 1)
            longest[j] = maximum(longest_arr)
        end
        avg_longest = mean(longest);
        m_x = avg_longest/(N^(1/D));
        @test ℯ > m_x && m_x > (c_x*D)/(ℯ*(gamma(1+D))^(1/D)*gamma(1+1/D))
        println("this is the avg longest path $avg_longest ± $(std(longest))")
        println("we have found the value $m_x for m_x, greater than $((c_x*D)/(ℯ*(gamma(1+D))^(1/D)*gamma(1+1/D))) .")
    end
end

# TODO write functions for m_x and c_x

###########################################################################
@testset "dijkstra longest paths comparison" begin
    p = 1.5; N = 10; d = 2; perc = 1;
    for N in 10:100:1000
        for i in 1:100
            max_R = Inf64
            (pos, g) = cube_space_digraph(N, d, max_R*perc/100, p);
            order = topological_sort_by_dfs(g);
            dist = my_sslp(g, order, 1)
            new_weights = weights(g).*(-1);
            ds = dijkstra_shortest_paths(g,1,new_weights)
            @test dist == ds.dists.*(-1)
        end
    end
end

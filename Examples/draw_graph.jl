using Dagology
using LightGraphs
using GraphPlot
using Colors
using Plots

##########################################################################
# Plot a 2D graph
# set up data (this representation works only for d=2)
p0 = 1.5; N = 20; d = 2; fraction = 2;
max_R = d_minkowski(ones(N), zeros(N), d, p0);
# choose the kind of graph to use
# (pos, g) = cube_space_digraph(N,d);
(pos, g) = cube_space_digraph(N, d, max_R/fraction, p0);
# (pos, g) = static_cube_space(N, d, max_R/fraction, p0)
dists = my_sslp(g, topological_sort_by_dfs(g), 1)
value_longest_path = maximum(dists)
vertex_longest_path = findall(x -> x == value_longest_path, dists)[1]
adjlist = g.badjlist
dists = convert(Vector{Int64}, dists)

longest_path_vertices = Vector{Int64}();
next_vertex = vertex_longest_path;
for i in 1:value_longest_path
    check_vertex = next_vertex;
    neigh_dists = Vector{Int64}();
    neighbours = adjlist[check_vertex]
    println("neighbours of $next_vertex are $neighbours")
    for j in neighbours                  # find next vertex in the path from in-degree
        neigh_dists = push!(neigh_dists, dists[j])
    end
    println("These are the neigh distances: $neigh_dists, iteration number $i")
    index = findall(x -> x == value_longest_path-i, neigh_dists)
    println("these are the indeces found: $index")
    ind = index[1];
    println("corresponding to vertex: $(neighbours[ind]), ind is $ind")
    if length(index) > 1
        println("ahhhh")
    end
    next_vertex = neighbours[index[1]]
    println("next vertex we are going to check: $next_vertex")
    longest_path_vertices = push!(longest_path_vertices, next_vertex)
end


my_plot = DAG_plot_2D(g, pos, true, false, true)
using Compose, Cairo
draw(PNG("test_graph.png", 16cm, 16cm), my_plot)

##########################################################################
# positive p
gr()
plot()
x = collect(0:0.01:1);
for p in 0.25:0.25:4
    y = (abs.(ones(length(x))-abs.(x).^p)).^(1/p);
    display(plot!(x, y))
end
# negative p
gr()
plot()
x = collect(0:0.01:1);
for p in -0.25:-0.25:-2
    y = (abs.(ones(length(x))-abs.(x).^p)).^(1/p);
    display(plot!(x, y))
end

p = -0.25

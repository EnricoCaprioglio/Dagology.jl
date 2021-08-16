using Dagology
using LightGraphs
using GraphPlot
using Colors
using Plots

##########################################################################
# Plot a 2D graph
# set up data (this representation works only for d=2)
p = 1.5; N = 50; d = 2; fraction = 4;
max_R = d_minkowski(ones(N), zeros(N), d, p);

# choose the kind of graph to use
# (pos, g) = cube_space_digraph(N,d);
(pos, g) = cube_space_digraph(N, d, max_R/fraction, p);
# (pos, g) = static_cube_space(N, d, max_R/fraction, p)

# find longest path distances
dists = my_sslp(g, topological_sort_by_dfs(g), 1);
value_longest_path = maximum(dists);
vertex_longest_path = findall(x -> x == value_longest_path, dists)[1];
adjlist = g.badjlist;

longest_path_vertices = get_longest_path_vertices(adjlist, dists, pos, p);
my_plot = DAG_plot_2D(g, pos, longest_path_vertices, false, false, true)

##########################################################################
# to save the plot
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

using Dagology
using LightGraphs
using GraphPlot
using Colors
using Plots
using LaTeXStrings
using Distributions
using LinearAlgebra
using Compose
set_default_graphic_size(20cm,20cm)

##########################################################################
##############################
# Plot a 2D cube space graph #
##############################
# this representation works only for d=2
d = 2;
## Set up data (any p ∈ Z, 2 < N < 50000, 0 < perc <= 100)
p = 1.5; N = 20; perc = 40;
max_R = d_minkowski(ones(d), zeros(d), d, p);
## create the graph
(pos, g) = cube_space_digraph(N, d, max_R*perc/100, p);

## Find longest path distances
start = 1;  # this is the source vertex of the system
dists = my_sslp(g, topological_sort_by_dfs(g), start);
length_longest_path = maximum(dists);
vertex_longest_path = findall(x -> x == length_longest_path, dists)[1];
adjlist = g.badjlist;
longest_path_vertices = get_longest_path_vertices(adjlist, dists, pos, p);
dst = longest_path_vertices[1];
## Find shortest path distances
ds = dijkstra_shortest_paths(g,start,weights(g));
shortest_path_vertices = get_shortest_path_vertices(adjlist, ds.dists, dst, pos, p);
## Plot final graph
arrowlen = 0.02;
my_plot = DAG_plot_2D(g, pos, longest_path_vertices, 
shortest_path_vertices, false, false, false, false, true, arrowlen)

# using p = -1.2; N = 200; perc = 7;
# we get qulitatively similar plots to cone space
# with N = 200; perc = 10; max_R = 1; prob = 1.0;

##########################################################################
## To save the plot
using Compose, Cairo
# draw(PDF("motivation.pdf", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false, true, arrowlen))
draw(PNG("motivation.png", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false, true, arrowlen))
# draw(SVG("test_graph.svg", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false))

using Dagology
using LightGraphs
using GraphPlot
using Colors
using Plots

##########################################################################
# Plot a 2D graph
# set up data (this representation works only for d=2)
p = 0.5; N = 500; d = 2; fraction = 10;
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
dst = longest_path_vertices[1];
ds = dijkstra_shortest_paths(g,1,weights(g));
shortest_path_vertices = get_shortest_path_vertices(adjlist, ds.dists, dst, pos, p);
my_plot = DAG_plot_2D(g, pos, longest_path_vertices, 
shortest_path_vertices, false, false, false, false, true)

##########################################################################
# to save the plot
using Compose, Cairo
draw(PDF("p_more_1_example.pdf", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false, true))
# draw(PNG("test_graph.png", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false))
# draw(SVG("test_graph.svg", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false))
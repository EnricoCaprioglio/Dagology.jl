using Dagology
using LightGraphs
using GraphPlot
using Colors
using Plots
using LaTeXStrings

##########################################################################
# Plot a 2D graph
# set up data (this representation works only for d=2)
p = -0.5; N = 100; d = 2; perc = 10;
max_R = d_minkowski(ones(N), zeros(N), d, p);

# choose the kind of graph to use
# (pos, g) = cube_space_digraph(N,d);
(pos, g) = cube_space_digraph(N, d, (max_R/100)*perc, p);
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
shortest_path_vertices, false, false, true, false, true)

##########################################################################
# to save the plot
using Compose, Cairo
draw(PDF("p_more_1_example.pdf", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false, true))
# draw(PNG("test_graph.png", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false))
# draw(SVG("test_graph.svg", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false))

pos, g = cone_space_digraph_test(1000, 3, 1, Inf64)
# some bits to plot are taken from:
# https://discourse.julialang.org/t/plots-plotlyjs-latex/38250
plotlyjs()
font_var = Plots.font("arial", 12)
plotlyjs(guidefont=font_var, xtickfont=font_var, 
   ytickfont=font_var, ztickfont=font_var, legendfont=font_var, 
   xlabelfont = font_var, ylabelfont = font_var, zlabelfont = font_var,
   size=(600,400));
plot(pos[:,2],pos[:,3],pos[:,1], seriestype = :scatter,
markershape = :utriangle)
my_plot = plot!(xlims = (-0.5, 0.5), ylims = (-0.5, 0.5), zlims = (0.0,1.0))
my_plot = plot!(xlabel = L"x_1", ylabel = L"x_2", zlabel = L"t")
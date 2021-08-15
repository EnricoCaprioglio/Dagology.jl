using Dagology
using LightGraphs
using GraphPlot
using Colors

##########################################################################
# Plot a 2D graph
# set up data (this representation works only for d=2)
p0 = 1.5; N = 50; d = 2; fraction = 5;
max_R = d_minkowski(ones(N), zeros(N), d, p0);
# choose the kind of graph to use
# (pos, g) = cube_space_digraph(N,d);
(pos, g) = cube_space_with_R(N, d, max_R/fraction, p0);
# (pos, g) = static_cube_space(N, d, max_R/fraction, p0)
DAG_plot_2D(g, pos, true, false)

##########################################################################

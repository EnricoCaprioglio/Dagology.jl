using Dagology
using LightGraphs
using GraphPlot

# set-up
p0 = 1.5; N = 20; d = 2;
# (pos, g) = cube_space_digraph(N,d);
max_R = d_minkowski(Box_pos[N,:], Box_pos[1,:], d, p0)
(pos, g) = cube_space_with_R(N, d, max_R/3, p0);

# get x and y and plot
locs_x = pos[:,1];
locs_y = ones(N)-pos[:,2];
nodesize = [degree(g)[v] for v in vertices(g)]
gplot(g, locs_x, locs_y) # nodesize=nodesize./2


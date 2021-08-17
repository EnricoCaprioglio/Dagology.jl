using Dagology
using LightGraphs


##########################################################################
# set up data
p = 2; N = 20; d = 2; fraction = 3;
max_R = d_minkowski(ones(N), zeros(N), d, p);
##########################################################################
# choose the kind of graph to use
# (pos, g) = cube_space_digraph(N,d);
(pos, g) = cube_space_digraph(N, d, max_R/fraction, p);
# (pos, g) = static_cube_space(N, d, max_R/fraction, p)
adjlist = g.badjlist;
##########################################################################
# find longest path
dists = my_sslp(g, topological_sort_by_dfs(g), 1);
value_longest_path = maximum(dists);
vertex_longest_path = findall(x -> x == value_longest_path, dists)[1];
longest_path_vertices = get_longest_path_vertices(adjlist, dists, pos, p);
# println("This is the longest path: ", longest_path_vertices[end:-1:1])
##########################################################################
# find shertest path
dst = longest_path_vertices[1];
ds = dijkstra_shortest_paths(g,1,weights(g));
shortest_path_vertices = get_shortest_path_vertices(adjlist, ds.dists, dst, pos, p);
##########################################################################
# calculate distance:
long_sum = 0;
for i in 1:(length(longest_path_vertices)-1)
    x_index = longest_path_vertices[i]
    y_index = longest_path_vertices[i+1]
    x = pos[x_index,:]
    y = pos[y_index,:]
    long_sum += d_minkowski(x,y,d,p)
end
short_sum = 0;
for i in 1:(length(shortest_path_vertices)-1)
    x_index = shortest_path_vertices[i]
    y_index = shortest_path_vertices[i+1]
    x = pos[x_index,:]
    y = pos[y_index,:]
    short_sum += d_minkowski(x,y,d,p)
end
max_R = d_minkowski(ones(N), zeros(N), d, p);

println("This is the longest path distance: $long_sum. \n 
    Compare with the shortest path distance: $short_sum. \n
    Finally, compare with the maximum minkwski distance in the system: $max_R")
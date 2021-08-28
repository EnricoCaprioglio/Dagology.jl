using Dagology
using LightGraphs
using Distributions

##########################################################################
###############
# Set up data #
###############
p = 0.25; N = 1000; d = 2; perc = 10;
max_R = d_minkowski(ones(d), zeros(d), d, p);
## Choose the kind of graph to use
# (pos, g) = cube_space_digraph(N,d);
(pos, g) = cube_space_digraph(N, d, max_R*perc/100, p);
adjlist = g.badjlist;
## Find longest path
dists = my_sslp(g, topological_sort_by_dfs(g), 1);
value_longest_path = maximum(dists);
vertex_longest_path = findall(x -> x == value_longest_path, dists)[1];
longest_path_vertices = get_longest_path_vertices(adjlist, dists, pos, p);
# println("This is the longest path: ", longest_path_vertices[end:-1:1])
## Find shortest path
dst = longest_path_vertices[1];
ds = dijkstra_shortest_paths(g,1,weights(g));
shortest_path_vertices = get_shortest_path_vertices(adjlist, ds.dists, dst, pos, p);
## Uncomment if you want to plot
my_plot = DAG_plot_2D(g, pos, longest_path_vertices, 
shortest_path_vertices, false, false, true, false, true)
## Calculate average perpendicular distance
long_sum = 0;
for i in 1:(length(longest_path_vertices)-1)
    x = pos[longest_path_vertices[i],:]
    # find perpendicular point on geodesic line
    t = 0;
    for j in x
        t += j
    end
    y = ones(d).*(t/d)
    # p = 2 # if you want Euclidean distance
    long_sum += d_minkowski(x,y,d,p)
end
short_sum = 0;
for i in 1:(length(shortest_path_vertices)-1)
    x = pos[shortest_path_vertices[i],:]
    # find perpendicular point on geodesic line
    t = 0;
    for j in x
        t += j
    end
    y = ones(d).*(t/d)
    # p = 2 # if you want euclidean distance
    short_sum += d_minkowski(x,y,d,p)
    println(d_minkowski(x,y,d,p))
end
average_perp_dist_long = long_sum/length(longest_path_vertices)
average_perp_dist_short = short_sum/length(shortest_path_vertices)
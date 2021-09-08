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
draw(PDF("motivation.pdf", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false, true, arrowlen))
draw(PNG("motivation.png", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false, true, arrowlen))
# draw(SVG("test_graph.svg", 16cm, 16cm), DAG_plot_2D(g, pos, longest_path_vertices, shortest_path_vertices, false, false, true, false))

########################
## Figures for poster ##
########################

loading = load("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data//For_plots/x_and_y_theo_background.jld")
x = loading["x"]
y = loading["y"]


N=20; d=2; p = 1.5; perc = 40;
R = Inf64;
R_max = d_minkowski(ones(d), zeros(d), d, p)
positions = rand(N-2,d);
pos = vcat(zeros(d)', positions, ones(d)')
# pos[:,1] = x
# pos[:,2] = y
x = pos[:,1]
y = pos[:,2]
g_complete = SimpleDiGraph(N);
g_with_R = SimpleDiGraph(N);
for i in 1:N
    for j in 1:N
        if all(pos[i,:]-pos[j,:].<0)
            if d_minkowski(pos[j,:], pos[i,:], d, p) < R;
                add_edge!(g_complete, i, j);
            end
            if d_minkowski(pos[j,:], pos[i,:], d, p) < R_max*perc/100;
                add_edge!(g_with_R, i, j);
            end
        end
    end
end

g_cone = SimpleDiGraph(N);
R_max = 1
θ = +π/4;
x_prime = x.*cos(θ) + y.*sin(θ)
y_prime = (y.*cos(θ) - x.*sin(θ))
for i in 1:N
    for j in 1:N
        spatial_diff = norm(y_prime[i] - y_prime[j]);
        temp_diff = x_prime[j] - x_prime[i];
        if (spatial_diff < temp_diff && (temp_diff^2 - spatial_diff^2)^(1/2) <= R_max*perc/100)
            add_edge!(g_cone, i, j);
        end
    end
end
arrowlen = 0.055
plot_g_complete = gplot(g_complete, pos[:,1], ones(N)-pos[:,2],arrowlengthfrac = arrowlen)
plot_g_with_R = gplot(g_with_R, pos[:,1], ones(N)-pos[:,2],arrowlengthfrac = arrowlen)
plot_g_cone = gplot(g_cone, pos[:,1], ones(N)-pos[:,2],arrowlengthfrac = arrowlen)

# g_with_R
start = 1;  # this is the source vertex of the system
dists = my_sslp(g_with_R, topological_sort_by_dfs(g_with_R), start);
length_longest_path = maximum(dists);
vertex_longest_path = findall(x -> x == length_longest_path, dists)[1];
adjlist = g_with_R.badjlist;
longest_path_vertices = get_longest_path_vertices(adjlist, dists, pos, p);
dst = longest_path_vertices[1];
## Find shortest path distances
ds = dijkstra_shortest_paths(g_with_R,start,weights(g_with_R));
shortest_path_vertices = get_shortest_path_vertices(adjlist, ds.dists, dst, pos, p);
## Plot final graph
my_plot = DAG_plot_2D(g_with_R, pos, longest_path_vertices, 
shortest_path_vertices, false, false, false, false, true, arrowlen)
draw(
    PNG("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/example_g_with_R_paths.png", 16cm, 16cm), 
    DAG_plot_2D(g_with_R, pos, longest_path_vertices, 
    shortest_path_vertices, false, false, false, false, true, arrowlen)
)
# g_complete
start = 1;  # this is the source vertex of the system
dists = my_sslp(g_complete, topological_sort_by_dfs(g_complete), start);
length_longest_path = maximum(dists);
vertex_longest_path = findall(x -> x == length_longest_path, dists)[1];
adjlist = g_complete.badjlist;
longest_path_vertices = get_longest_path_vertices(adjlist, dists, pos, p);
dst = longest_path_vertices[1];
## Find shortest path distances
ds = dijkstra_shortest_paths(g_complete,start,weights(g_complete));
shortest_path_vertices = get_shortest_path_vertices(adjlist, ds.dists, dst, pos, p);
## Plot final graph
my_plot = DAG_plot_2D(g_complete, pos, longest_path_vertices, 
shortest_path_vertices, false, false, false, false, true, arrowlen)
draw(
    PNG("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/example_g_complete_paths.png", 16cm, 16cm), 
    DAG_plot_2D(g_complete, pos, longest_path_vertices, 
    shortest_path_vertices, false, false, false, false, true, arrowlen)
)
# g_cone
start = 1;  # this is the source vertex of the system
dists = my_sslp(g_cone, topological_sort_by_dfs(g_cone), start);
length_longest_path = maximum(dists);
vertex_longest_path = findall(x -> x == length_longest_path, dists)[1];
adjlist = g_cone.badjlist;
longest_path_vertices = get_longest_path_vertices(adjlist, dists, pos, p);
dst = longest_path_vertices[1];
## Find shortest path distances
ds = dijkstra_shortest_paths(g_cone,start,weights(g_cone));
shortest_path_vertices = get_shortest_path_vertices(adjlist, ds.dists, dst, pos, p);
## Plot final graph
my_plot = DAG_plot_2D(g_cone, pos, longest_path_vertices, 
shortest_path_vertices, false, false, false, false, true, arrowlen)
draw(
    PNG("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/example_g_cone_paths.png", 16cm, 16cm), 
    DAG_plot_2D(g_cone, pos, longest_path_vertices, 
    shortest_path_vertices, false, false, false, false, true, arrowlen)
)

# https://juliapackages.com/p/jld
using JLD
x = pos[:,1]
y = pos[:,2]
save("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data//For_plots/x_and_y_theo_background.jld", "x", x, "y", y, "g_complete", g_complete, "g_with_R", g_with_R, "perc", perc)
loading = load("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data//For_plots/x_and_y_theo_background.jld")
x = loading["x"]
y = loading["y"]
using Compose, Cairo
draw(PNG("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/example_g_complete.png", 16cm, 16cm), gplot(g_complete, x, ones(N)-y,arrowlengthfrac = arrowlen))
draw(PNG("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/example_g_with_R.png", 16cm, 16cm), gplot(g_with_R, x, ones(N)-y,arrowlengthfrac = arrowlen))
draw(PNG("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/example_g_cone.png", 16cm, 16cm), gplot(g_cone, x, ones(N)-y,arrowlengthfrac = arrowlen))

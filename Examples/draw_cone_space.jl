using Dagology
using LightGraphs
using GraphPlot
using Colors
using Plots
using LaTeXStrings
using Distributions
using LinearAlgebra
# plotlyjs()

##########################################################################
##############################
# Plot a 2D cone space graph #
##############################
# this representation works only for d=2
d = 2;
## Set up data (any p = 2, 2 < N < 10000, 0 < perc <= 100)
N = 200; perc = 10; max_R = 1; prob = 1.0;
pos, g = cone_space_digraph(N, d, max_R*perc/100, prob)
p = 2; # used by get_longest_path_vertices function, p =2 is Euclidean distance

## Find longest path distances
start = 1;
dists = my_sslp(g, topological_sort_by_dfs(g), start);
length_longest_path = maximum(dists);
vertex_longest_path = findall(x -> x == length_longest_path, dists)[1];
adjlist = g.badjlist;
longest_path_vertices = get_longest_path_vertices(adjlist, dists, pos, p);
dst = longest_path_vertices[1];
## Find shortest path distances
ds = dijkstra_shortest_paths(g,1,weights(g));
shortest_path_vertices = get_shortest_path_vertices(adjlist, ds.dists, dst, pos, p);
# plot final graph
my_plot = DAG_plot_2D(g, pos, longest_path_vertices, 
shortest_path_vertices, false, false, false, false, true)

##############################
# Plot a 3D cone space graph #
##############################
# this representation works only for d=3
d = 3;
## Set up data (any p = 2, 2 < N < 1000, 0 < perc <= 100)
# max_R is always 1, it's the largest timelike distance in the system
N = 200; perc = 10; max_R = 1;
pos, g = cone_space_digraph(N, d, 1, max_R*perc/100)
## some bits of code for LaTeX (from "begin" to "end") are taken from:
# https://discourse.julialang.org/t/plots-plotlyjs-latex/38250
# begin
plotlyjs()
font_var = Plots.font("arial", 12)
plotlyjs(
    guidefont=font_var, xtickfont=font_var, 
   ytickfont=font_var, ztickfont=font_var, legendfont=font_var, 
   xlabelfont = font_var, ylabelfont = font_var, zlabelfont = font_var,
   size=(600,400)
);
# end 
plot(pos[:,2],pos[:,3],pos[:,1], seriestype = :scatter,
markershape = :utriangle)
my_plot = plot!(xlims = (-0.5, 0.5), ylims = (-0.5, 0.5), zlims = (0.0,1.0))
my_plot = plot!(xlabel = L"x_1", ylabel = L"x_2", zlabel = L"t")

##########################################################################
## Same function but plot edges as well
N = 200; # use less than 500
max_R = 1; perc = 5;
d = 3; # this is fixed for this function
(pos,g) = cone_space_digraph(N, d, max_R*perc/100, 1.0)
p = plot(
    pos[:,2],pos[:,3],pos[:,1], aspect_ratio = :equal, seriestype = :scatter,
    xlims = [-0.5, 0.5], ylims = [-0.5, 0.5], zlims = [0.0, 1.0], label = ""
)
edge_list = [e for e in edges(g)]
for e in edge_list
    source = e.src;
    dest = e.dst;
    p = plot!(
        [pos[source,2],pos[dest,2]],
        [pos[source,3],pos[dest,3]],
        [pos[source,1],pos[dest,1]],
        arrow=true,arrowsize=10, color=:grey,
        label="", linewidth = 2, headlength = 0.5,
        headwidth = 2
        )
end
plot!(xaxis = false, yaxis = false, zaxis = false)
display(p)

##########################################################################
## Below some methods to sample uniformly from d-sphere and d-balls
# http://extremelearning.com.au/how-to-generate-uniformly-random-points-on-n-spheres-and-n-balls/

#####################
# sampling 1-sphere #
#####################
## Method 3 from source above
N = 100;
x = zeros(N)
y = zeros(N)
for i in 1:N
    u = rand(Normal(0,1))
    v = rand(Normal(0,1))
    denom = (u^2+v^2)^0.5  # notation for sqrt(.)
    x[i] = u/denom
    y[i] = v/denom
end
plot(x,y, seriestype= :scatter)

###################
# sampling 2-ball #
###################
## Method 9 from source above
N = 100;
x = zeros(N)
y = zeros(N)
for i in 1:N
    s = rand(Normal(0,1))
    t = rand(Normal(0,1))
    u = rand(Normal(0,1))
    v = rand(Normal(0,1))
    norm = (s*s + t*t + u*u + v*v)^(0.5)
    x[i] = u/norm
    y[i] = v/norm
end
plot(x,y, seriestype= :scatter)

## Method 8 from source above
N = 100;
x = zeros(N)
y = zeros(N)
for i in 1:N
    u = rand(Normal(0,1))
    v = rand(Normal(0,1))
    e = rand(Exponential(1))
    denom = (u*u + v*v + e)^0.5
    x[i] = u/denom
    y[i] = v/denom
end
# translate z coordinates s.t. all z_coords > 0
y.+=1
# resize the coordinates, s.t. radius = 0.5
x./=2
y./=2
plot(x,y, seriestype= :scatter, aspect_ratio = :equal)

###################
# sampling 3-ball #
###################
## Method 17 from source above
N = 100;
x = zeros(N); y = zeros(N); z = zeros(N);
for i in 1:N
    u = rand(Normal(0,1))
    v = rand(Normal(0,1))
    w = rand(Normal(0,1))
    e = rand(Exponential(1))
    denom = (e + u*u + v*v + w*w)^(0.5)
    x[i] = u/denom
    y[i] = v/denom
    z[i] = w/denom
end
# translate z coordinates s.t. all z_coords > 0
z.+=1
# resize the coordinates, s.t. radius = 0.5
x./=2
z./=2
y./=2
plot(
    x,y,z, aspect_ratio = :equal, seriestype = :scatter,
    xlims = [-0.5, 0.5], ylims = [-0.5, 0.5], zlims = [0.0, 1.0]
)

# Notice the last methods can be used to generalize to d dimensions
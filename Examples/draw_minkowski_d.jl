using Dagology
using Plots

##########################################################################
# plot positive p unit spheres for minkowski distance
gr()
plot()
colors = [:red, :green, :blue, :lightseagreen, :purple, :orange, :pink]
x = collect(0:0.01:1);
c = 1;
for p in [0.25, 0.5, 0.75, 1, 2, 4, 50]
    to_plot = zeros(length(x)*4, 2);
    y = (abs.((ones(length(x))).^p-abs.(x).^p)).^(1/p);
    k = 0;
    for i in 1:4
        for j in 1:length(x)
            if i < 3
                to_plot[k+j, 1] = x[j]
            else
                to_plot[k+j, 1] = -x[j]
            end
            if i%2 == 1
                to_plot[k+j, 2] = y[j]
            else
                to_plot[k+j, 2] = -y[j]
            end
        end
        k += length(x)
    end
    s = 0
    for i in 1:4
        display(plot!(to_plot[1+s:s+length(x),1], to_plot[1+s:s+length(x),2],
        color = colors[c], aspect_ratio=:equal, label = ""))
        if i == 4
            display(plot!(label = "p = $p"))
        end
        s+=length(x)
    end
    c += 1;
end
using LaTeXStrings
plot!(xlabel = L"x_1", ylabel = L"x_2")
# plot!(xlims = (0.0, 1.0), ylims = (0.0, 1.0), xticks = 0:0.2:1, yticks = [0,0.5,1])
# Minkowski inequality along the axis
x = [0.5, 0.0];
z = [0.7, 0.0];
zero_to_z = d_minkowski(z, [0.0,0.0], 2, 0.25)
zero_to_x_to_z = d_minkowski(x, [0.0,0.0], 2, 0.25) + d_minkowski(z, x, 2, 0.25)
# consider small variation from axis
x = [0.5, 0.1];
z = [0.7, 0.0];
zero_to_z = d_minkowski(z, [0.0,0.0], 2, 0.25)
zero_to_x_to_z = d_minkowski(x, [0.0,0.0], 2, 0.25) + d_minkowski(z, x, 2, 0.25)

##########################################################################
# visualize unit spheres/balls in a graph
p = 1.2; N = 50; d = 2; fraction = 10;
max_R = d_minkowski(ones(N), zeros(N), d, p);
(pos, g) = cube_space_digraph(N, d, max_R/fraction, p);
x = pos[:,1]
y = pos[:,2]
alpha = 0.05;
my_plot = plot_G_with_unit_ball(x,y,max_R/fraction,p)
plot!(xlims = (-0.5, 1.5), ylims = (-0.5, 1.5),
xticks = [-0.5,0.0,1.0,1.5], yticks = [-0.5,0.0,1.0,1.5])
display(my_plot)

##########################################################################
# negative p
# we want d_p(x,y) = 1
#         (∑_i|x_i-y_i|^p)^(1/p) = 1
# but now for p < 0 we need to consider x_i > 1 only.
# Notice it takes a while to plot
plot()
x = collect(1.00:0.0001:5.00);
for p in [5,2,1.5,1.0,0.75]
    y = (x)./((x.^p - ones(length(x)))).^(1/p);
    display(plot!(x, y, label = "p = -$p"))
end
plot!(xlims = (0.0, 5), ylims = (0.0, 5),
xticks = [0.0,1.0,2.0, 3.0,4.0,5.0], yticks = [0.0,1.0,2.0, 3.0,4.0,5.0],
aspect_ratio=:equal)

# negative p but for any r (put any arbitrary value > 0)
plot()
r = 0.5;
x = collect(r:0.0001:5.00);
for p in [5,2,1.5,1.0,0.75]
    y = (x.*r)./((x.^p - (ones(length(x)).*r).^p)).^(1/p);
    display(plot!(x, y, label = "p = -$p"))
end
plot!(xlims = (0.0, 5), ylims = (0.0, 5),
xticks = [0.0,1.0,2.0,3.0,4.0,5.0,r], yticks = [0.0,1.0,2.0, 3.0,4.0,5.0,r],
aspect_ratio=:equal)

# example of points that have an edge between each other:
p = -0.5; r = 0.5;
x_1_vec = collect(0.01:0.01:1.5)
x_2_vec = [0.01, 0.2, 0.5, 0.75, 1.0, 1.5, 2.0, 5.0, 10, 100]
for x_1 in x_1_vec
    for x_2 in x_2_vec
        distance_M = ((x_1).^p+(x_2).^p)^(1/p)
        if distance_M > 0.5
            println("For x_1: $x_1, and x_2: $x_2 distance is $distance_M")
        end
    end
end

##########################################################################
# compare Minkowski distance from source to sink for:
# p > 0
for p in [-0.1,-0.2, -0.5,-0.75, -1, -1.5, -2, -5, -10, -100]
    println("For p = $p, 1 over p is $(1/p)")
    println("Then, 2^(1/p) is $(2^(1/p)) \n")
end
# p < 0
for p in [0.1,0.2,0.5,0.75,1,1.5,2,5,10,100]
    println("For p = $p, 1 over p is $(1/p)")
    println("Then, 2^(1/p) is $(2^(1/p)) \n")
end

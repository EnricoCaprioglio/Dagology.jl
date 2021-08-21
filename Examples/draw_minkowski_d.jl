using Dagology
using Plots

##########################################################################
# positive p
gr()
plot()
colors = [:red, :green, :blue, :lightseagreen, :purple, :orange]
x = collect(0:0.01:1);
c = 1
for p in [0.25, 0.5, 0.75, 1, 2, 4]
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
# plot!(xlims = (0, 5.5), ylims = (-2.2, 6), xticks = 0:0.5:10, yticks = [0,1,5,10])
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
p = 0.5; r = 0.3;
x_translation = [0.15, 0.1, 0.2, 0.3, 0.4];
y_translation = [0.15, 0.1, 0.1, 0.1, 0.3];
my_plot = plot_G_with_unit_ball(x_translation,y_translation,r,p, alpha = 0.20)
display(my_plot)

##########################################################################
# negative p
plot()
x = collect(0:0.01:1);
for p in -0.25:-0.25:-2
    y = (abs.(ones(length(x))-abs.(x).^p)).^(1/p);
    display(plot!(x, y, label = "p = $p"))
end

# we want d_p(x,y) = 1
#         (∑_i|x_i-y_i|^p)^(1/p) = 1
# but now p < 0

# e.g. p = -1.5 = - 3/2
p = -1.5;
(ones(length(x))) - x.^p
# consider  distances  > 2
plot()
x = collect(1:0.01:2);
for p in -0.75:-0.25:-2
    y = (abs.(ones(length(x))-abs.(x).^p)).^(1/p);
    display(plot!(x, y, label = "p = $p"))
end

d = 2; # example
p = -0.5;
x = [1,1];
y = [0.0,0.0];
d_minkowski(x,y,d,p)

using Dagology
using Plots
using LaTeXStrings

##########################################################################
#######################################################
# plot positive p unit spheres for Minkowski distance #
#######################################################
## choose backend
# plotlyjs()
gr()

plot(size = (800,800))
colors = [:red, :green, :blue, :lightseagreen, :purple, :orange, :pink]
x = collect(0:0.01:1);
c = 1;
for p in [0.25, 0.5, 0.75, 1, 2, 4, 100]
    to_plot = zeros(length(x)*4, 2);                        # storing array
    y = (abs.((ones(length(x))).^p-abs.(x).^p)).^(1/p);     # x_2 such that d(x,0) = 1
    k = 0;
    # add to storing array depending on the respective quadrant
    for i in 1:4
        for j in 1:length(x)                                # TODO: get rid of the j loop
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
    if p >= 1
        labels = "p = $(round(Int,p))"
    else
        labels = "p = $p"
    end
    for i in 1:4
        if i == 4
            plot!(to_plot[1+s:s+length(x),1], to_plot[1+s:s+length(x),2],
            color = colors[c], aspect_ratio=:equal, label = labels, linewidth = 2)
        else
            plot!(to_plot[1+s:s+length(x),1], to_plot[1+s:s+length(x),2],
            color = colors[c], aspect_ratio=:equal, label = "", linewidth = 2)
        end
        s+=length(x)
    end
    c += 1
end
# axis labels and size
plot!(xlabel = L"x_1", ylabel = L"x_2", xguidefontsize=24, yguidefontsize=24)
# change size of stuff
plot!(legendfontsize=24, xtickfontsize=18,ytickfontsize=18, legend=:bottomright)
# plot!(xlims = (0.0, 1.0), ylims = (0.0, 1.0), xticks = 0:0.2:1, yticks = [0,0.5,1])
plot!(xlims = (-1.1, 1.1), ylims = (-1.1, 1.1), xticks = -1:0.4:1, yticks = -1:0.4:1)
## Save figure
savefig("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/metric_ball_Mink.png")

## Minkowski inequality, triangle check:
p = 0.25;
x = [0.5, 0.5];
z = [0.7, 0.7];
zero_to_z = d_minkowski(z, [0.0,0.0], 2, p)
zero_to_x_to_z = d_minkowski(x, [0.0,0.0], 2, p) + d_minkowski(z, x, 2, p)
# we can see that along the segment the minkowski inequality is an equality.
# similarly along the axis.
## Consider small variation from axis:
x = [0.5, 0.55];
z = [0.7, 0.7];
zero_to_z = d_minkowski(z, [0.0,0.0], 2, p)
zero_to_x_to_z = d_minkowski(x, [0.0,0.0], 2, p) + d_minkowski(z, x, 2, p)
# However, small variation and we get the SUPERADDITIVITY property for 0 < p < 1
# and we get the SUBADDITIVITY property for p > 1.
println("This is the difference: $(zero_to_z-zero_to_x_to_z)")
# if the differece is less than zero we have subadditivity, if more than zero we have superadditivity
println("Then for p = $p, subadditivity: $(zero_to_z-zero_to_x_to_z < 0), superadditivity: $(zero_to_z-zero_to_x_to_z > 0)")

##########################################################################
#######################################################
# plot negative p unit spheres for Minkowski distance #
#######################################################
gr()
# any r > 0 allowed
r = 0.5;
xticks_arr = [-4.0,-3.0,-2.0,2.0,3.0,4.0,r];
yticks_arr = [-4.0,-3.0,-2.0,2.0,3.0,4.0,r];
neg_plot = plot(size = (800,800), xticks = xticks_arr, yticks = yticks_arr)
x = collect(r:0.0001:5.00);
colors = [:red, :green, :blue, :lightseagreen, :purple, :orange, :pink]
c = 1;
for p in [2,1.0,0.75,0.5]
    to_plot = zeros(length(x)*4, 2);                           # storing array
    y = (x.*r)./((x.^p - (ones(length(x)).*r).^p)).^(1/p);     # x_2 such that d(x,0) = 1
    println(y[1:10])
    k = 0;
    # add to storing array depending on the respective quadrant
    for i in 1:4
        for j in 1:length(x)                                # TODO: get rid of the j loop
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
    if p >= 1
        labels = "p = -$(round(Int,p))"
    else
        labels = "p = -$p"
    end
    for i in 1:4
        if i == 4
            neg_plot = plot!(
                to_plot[1+s:s+length(x),1], to_plot[1+s:s+length(x),2],
                color = colors[c], aspect_ratio=:equal, label = labels, linewidth = 2,
                xlims = (-5, 5), ylims = (-5, 5),
            )
        else
            neg_plot = plot!(
                to_plot[1+s:s+length(x),1], to_plot[1+s:s+length(x),2],
                color = colors[c], aspect_ratio=:equal, label = "", linewidth = 2,
                xlims = (-5, 5), ylims = (-5, 5),
            )
        end
        s+=length(x)
    end
    c += 1
end
y_prime = collect(r:0.0001:5.00)
x_prime = ones(length(y_prime)).*r
x_prime = vcat(x_prime,collect(r:0.0001:5.00))
y_prime = vcat(y_prime, ones(length(y_prime)).*r)

neg_plot = plot!(
    x_prime, y_prime,
    color = :black, aspect_ratio=:equal, linewidth = 1.5,
    xlims = (-5, 5), ylims = (-5, 5),
    label = "p → ∞", linestyle = :dash
)
neg_plot = plot!(
    x_prime, -y_prime,
    color = :black, aspect_ratio=:equal, label = "", linewidth = 1.5,
    xlims = (-5, 5), ylims = (-5, 5), linestyle = :dash
)
neg_plot = plot!(
    -x_prime, y_prime,
    color = :black, aspect_ratio=:equal, label = "", linewidth = 1.5,
    xlims = (-5, 5), ylims = (-5, 5), linestyle = :dash
)
neg_plot = plot!(
    -x_prime, -y_prime,
    color = :black, aspect_ratio=:equal, label = "", linewidth = 1.5,
    xlims = (-5, 5), ylims = (-5, 5), linestyle = :dash
)
# axis labels and size
neg_plot = plot!(xlabel = L"x_1", ylabel = L"x_2", xguidefontsize=24, yguidefontsize=24)
# change size of stuff
neg_plot = plot!(legendfontsize=24, xtickfontsize=18,ytickfontsize=18, legend=:bottomleft)

## Save figure
savefig("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/reversed_metric_ball_Mink.png")

##########################################################################
## visualize unit spheres in a 2D graph plot
pyplot()
gr()
######################################
# get data using a box space generator
p = 2; N = 6; 
max_R = d_minkowski(ones(d), zeros(d), d, p);
(pos, g) = cube_space_digraph(N, d, max_R*perc/100, p);
x = pos[:,1]
y = pos[:,2]
######################################
# or use arbitrary data
# x = [0, 0.05, 0.5, 0.7, 0.1, 1]
# y = [0, 0.5, 0.05, 0.5, 0.95, 1]
x = [0, 0.5, 0.7, 0.1, 1]
y = [0, 0.05, 0.5, 0.95, 1]
alpha = 0.05;
markersizes = 7;
d = 2; perc = 45;

# Plot graphs for different values of p
p = 4;
max_R = d_minkowski(ones(d), zeros(d), d, p);
R = max_R*perc/100
my_plot = plot_G_with_unit_ball(x,y,R,p,alpha,[:red, :green, :blue, :lightseagreen, :purple, :orange], markersizes)
savefig("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/G_with_ball_pp1.png")
p = 0.5;
max_R = d_minkowski(ones(d), zeros(d), d, p);
R = max_R*perc/100
my_plot = plot_G_with_unit_ball(x,y,R,p,alpha,[:red, :green, :blue, :lightseagreen, :purple, :orange], markersizes)
savefig("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/G_with_ball_pm1.png")
p = -0.5;
max_R = d_minkowski(ones(d), zeros(d), d, p);
R = max_R*25/100
my_plot = plot_G_with_unit_ball(x,y,R,p,alpha,[:red, :green, :blue, :lightseagreen, :purple, :orange], markersizes)
savefig("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/G_with_ball_pm0.png")

# savefig("C:/Users/enric/Documents/Imperial/MSc_Thesis/Poster_figures/plot_G_with_unit_ball.pdf")


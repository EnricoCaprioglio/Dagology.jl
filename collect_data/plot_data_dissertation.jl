using Dagology
using Test
using LightGraphs
using LinearAlgebra
using GraphPlot
using Statistics
using SpecialFunctions
using LaTeXStrings
using Plots
# plotlyjs()
pyplot()
############################################################################################
## vary perc ##                                                                            #
# p = -0.5                                                                                    #
# folder = "C:/Users/enric/Documents/Imperial/MSc_Thesis/Dagology/collect_data/Data/204060/" #
#  space_type = "cube";
#####                                                                                      #
# for perc in [20,40,60]                                                                   #
# for cone
p = 1
max_N = 13
space_type = "cone";
############################################################################################

############################################################################################
## vary p ##                                                                               #
# perc = 30;                                                                                 #
# folder = "C:/Users/enric/Documents/Imperial/MSc_Thesis/Dagology/collect_data/Data/30/"     #
#####                                                                                      #
# for p in [-2.0, -1.0, -0.75, -0.5, 0.25, 0.5, 2]                                           #
############################################################################################
#################
## select data ##
#################
# for p in [1.5, 2.0] # [-2.0, -1.0, -0.75, -0.5, 0.25, 0.5, 2]
#     scaling = 1; scaled = true;
#     d=2; no_test = 100;
#     max_i = 12
#     # pyplot() # this backend supports log2 scaling

#     plt_array = Any[]
#     for perc in [20] #[20,40,60]
#         # load data
#         using JLD # https://juliapackages.com/p/jld
#         if space_type == "cone"
#             folder = "C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/cone/"
#             filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_1_mink_max_N_$(max_N)"
#         else space_type == "cube"
#             folder = "C:/Users/enric/Documents/Imperial/MSc_Thesis/Dagology/collect_data/Data/204060/"
#             filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_$(p)_max_i$(max_i)"
#         end
#         loading = load(string(folder, filename, ".jld"));
#         store_long = loading["arr_long"];
#         store_short = loading["arr_short"];
#         store_N = loading["N"];
#         R = loading["R"];
#         p = loading["p"];
#         if space_type == "cone"
#             R_max = 1
#         else
#             R_max = d_minkowski(ones(d), zeros(d), d, p)
#         end
#         titles = " $space_type space, d = $d, p = $p, R = R_max*$perc/100"
#         if scaled
#             scaling = R_max
#         end
#         # add to a plot
#         push!(plt_array, plot(
#             store_N, abs.(store_long[:,1].-R_max)./scaling, yerr  = store_long[:,2]./scaling,
#             line = :scatter, marker = :utriangle, c = :red,
#             label = "Longest Path", markersize = 7, ecolor = :red, msc = :red,
#             title = titles
#         ))
#         plot!(
#             store_N, abs.(store_short[:,1].-R_max)./scaling, yerr  = store_short[:,2]./scaling,
#             line = :scatter, marker = :dtriangle, c = :blue,
#             label = "Shortest Path", markersize = 7, ecolor = :blue, msc = :blue
#         )
#         # change size of stuff
#         plot!(xlabel = L"x_1", ylabel = L"x_2", xguidefontsize=24, yguidefontsize=24)
#         plot!(legendfontsize=18, xtickfontsize=18,ytickfontsize=18, legend=:topleft)
#         xaxis!(xscale=:log2, xlabel = L"N", xlims = (2^4+2, 2^13))
#         yaxis!(ylabel = L"\ell", ylims = (0.0, 1.1))
#         xticks!([2^i for i in 1:12])
#     end

#     plot(
#         plt_array[1], plt_array[2], plt_array[3],
#         layout = (1, 3),
#         size = (1800, 600)
#     )

#     #####################
#     # save plot options #
#     #####################
#     # filename = string("C:/Users/enric/Documents/TexMaker/MSc_Dissertation/figures/Plots/$(space_type)_204060_p_$p.png")
#     # savefig(filename)
# end


# space_type = "cube";
# scaling = 1; scaled = true;
# d=2; no_test = 100;
# max_i = 13

# perc = 30;
# # [-2.0, -1.0, -0.75, -0.5, 0.25, 0.5, 0.75, 1, 2, 4, 100]
# p = 100

# folder = "C:/Users/enric/Documents/Imperial/MSc_Thesis/Dagology/collect_data/Data/30/"
# ################
# # just copy paste file for quick check
# filename = "long_short_cube_dim_2_avg_test_100_perc_30_parameterp_-1.0_max_i13"
# ################
# loading = load(string(folder, filename, ".jld"));
# store_long = loading["arr_long"];
# store_short = loading["arr_short"];
# store_N = loading["N"];
# R = loading["R"];
# p = loading["p"];
# R_max = d_minkowski(ones(d), zeros(d), d, p)


# cube
# space_type = "cube";
# folder = "C:/Users/enric/Documents/Imperial/MSc_Thesis/Dagology/collect_data/Data/"
# filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_$(p)_max_i$(max_i)"

##################################################################
# CONE PLOT
using JLD
perc = 20; p = 1.5; max_i = 12;
d = 2; no_test = 100;
scaling = 1; scaled = true;
max_i = 12
pyplot() # this backend supports log2 scaling

perc = 20
# load data
using JLD # https://juliapackages.com/p/jld
space_type = "cone"; perc = 20;
max_N = 13; d = 2; no_test = 100
folder = "C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/cone/"
filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_1_mink_max_N_$(max_N)"

loading = load(string(folder, filename, ".jld"));
store_long = loading["arr_long"];
store_short = loading["arr_short"];
store_N = loading["N"];
R = loading["R"];
p = loading["p"];
R_max = 1;
titles = " $space_type space, d = $d, R = R_max*$perc/100"
#####################################################################
# add to a plot
plot(size = (600, 600),
    store_N, abs.(store_long[:,1].-R_max)./scaling, yerr  = store_long[:,2]./scaling,
    line = :scatter, marker = :utriangle, c = :red,
    label = "Longest Path", markersize = 7, ecolor = :red, msc = :red,
    title = titles
)
plot!(
    store_N, abs.(store_short[:,1].-R_max)./scaling, yerr  = store_short[:,2]./scaling,
    line = :scatter, marker = :dtriangle, c = :blue,
    label = "Shortest Path", markersize = 7, ecolor = :blue, msc = :blue
)
# change size of stuff
plot!(xguidefontsize=24, yguidefontsize=24)
plot!(legendfontsize=18, xtickfontsize=18,ytickfontsize=18, legend=:bottomright)
xaxis!(xscale=:log2, xlabel = L"N", xlims = (2^4+2, 2^14))
yaxis!(ylabel = L"\ell", ylims = (0.0, 1.1))
xticks!([2^i for i in 1:13])

#####################
# save plot options #
#####################
filename = string("C:/Users/enric/Documents/TexMaker/MSc_Dissertation/figures/Plots/$(space_type)_$(perc)_p_$p.png")
savefig(filename)

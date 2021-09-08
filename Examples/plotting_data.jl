using Dagology
using Test
using LightGraphs
using LinearAlgebra
using GraphPlot
using Statistics
using SpecialFunctions
using LaTeXStrings
using Plots

###########################
# plotting different perc # available for p = [0.5, -0.5]
###########################
###############
# set up data #
###############
plt_array = Any[]
space_type = "cone" # either cube or cone
d=2; p=-0.5; no_test = 100;
pyplot() # this backend supports log2 scaling
for perc in [2,5,10,20,40,60,80,100]
    # load data
    using JLD # https://juliapackages.com/p/jld
    if space_type == "cone"
        p = 1
    end
    filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_$p"
    loading = load(string("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/Vary_perc/", filename, ".jld"));
    store_long = loading["arr_long"];
    store_short = loading["arr_short"];
    d = loading["dim"];
    store_N = loading["N"];
    R = loading["R"];
    p = loading["p"];
    # add to a plot
    if space_type == "cube"
        titles = "$space_type space, d = $d, p = $p, R = R_max*$perc/100"
    else space_type == "cone"
        titles = "$space_type space, d = $d, R = R_max*$perc/100"
    end
    push!(plt_array, plot(
        store_N, store_long[:,1], yerr  = store_long[:,2],
        line = :scatter, marker = :utriangle, c = :red,
        label = "", markersize = 7, ecolor = :red, msc = :red,
        title = titles
    ))
    plot!(
        store_N, store_short[:,1], yerr  = store_short[:,2],
        line = :scatter, marker = :dtriangle, c = :blue,
        label = "", markersize = 7, ecolor = :blue, msc = :blue
    )

    xaxis!(:log2, xlabel = L"N")
    yaxis!(ylabel = L"l")
    xticks!([2^i for i in 1:12])
end

plot(
    plt_array[1], plt_array[2], plt_array[3],
    plt_array[4], plt_array[5], plt_array[6],
    plt_array[7], plt_array[8], size = (1500, 1000)
)
########
# TODO: for cone space, it is interesting to see what happens between R = 0.2*R_max and R = 0.4*R_max
# i.e. when shortest path and longest "switch roles".
########
d_minkowski([1,1], [0.0,0.0], 2, 0.5)
##################################
# plotting different parameter p # available for perc = [30]
##################################
###############
# set up data #
###############
plt_array = Any[]
space_type = "cube" # either cube or cone
d = 2; perc = 30; no_test = 100;
pyplot() # this backend supports log2 scaling
for p in [-2,-1.5,-1,-0.5,0.5,1,1.5,2]
    # load data
    using JLD # https://juliapackages.com/p/jld
    filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_$p"
    loading = load(string("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/Vary_p/", filename, ".jld"));
    store_long = loading["arr_long"]; store_short = loading["arr_short"];
    d = loading["dim"]; store_N = loading["N"];
    R = loading["R"]; p = loading["p"];
    # add to a plot
    if space_type == "cube"
        titles = "$space_type space, d = $d, p = $p, R = R_max*$perc/100"
    else space_type == "cone"
        titles = "$space_type space, d = $d, R = R_max*$perc/100"
    end
    push!(plt_array, plot(
        store_N, store_long[:,1], yerr  = store_long[:,2],
        line = :scatter, marker = :utriangle, c = :red,
        label = "", markersize = 7, ecolor = :red, msc = :red,
        title = titles
    ))
    plot!(
        store_N, store_short[:,1], yerr  = store_short[:,2],
        line = :scatter, marker = :dtriangle, c = :blue,
        label = "", markersize = 7, ecolor = :blue, msc = :blue
    )
    x_plot = collect(1:0.1:2^12)
    R_max = d_minkowski(ones(d), zeros(d), d, p);
    plot!(x_plot,ones(length(x_plot))*R_max, label = "")
    xaxis!(:log2, xlabel = L"N")
    yaxis!(ylabel = L"l")
    xticks!([2^i for i in 1:12])
end
# plot everything
plot(
    plt_array[1], plt_array[2], plt_array[3],
    plt_array[4], plt_array[5], plt_array[6],
    plt_array[7], plt_array[8], size = (1500, 1000)
)


space_type = "cube" # either cube or cone
d = 2; perc = 30; no_test = 100; p = 1.5;
filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_$p"
loading = load(string("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/Vary_p/", filename, ".jld"));
store_long = loading["arr_long"]; store_short = loading["arr_short"];
d = loading["dim"]; store_N = loading["N"];
R = loading["R"]; p = loading["p"];
R_max = d_minkowski(ones(d), zeros(d), d, p)
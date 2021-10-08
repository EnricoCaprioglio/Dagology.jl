using Dagology
using Test
using LightGraphs
using LinearAlgebra
using GraphPlot
using Statistics
using SpecialFunctions
using LaTeXStrings
using Plots

## CUBE SPACE (fixed p)
##############################
# get data # vary perc and N #
##############################
max_i = 12;
for p in [-0.5]
    for perc in [30]
        space_type = "cube" # either cube or cone
        d=2; no_test = 100; # average over 100 simulations
        long_sums = zeros(no_test); short_sums = zeros(no_test);
        filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_$(p)poster"
        # define storing arrays
        store_N = [2^i for i in 1:max_i]
        store_long = zeros(max_i,2)
        store_short = zeros(max_i,2)
        # get data
        for j in 1:max_i
            N = store_N[j]
            for i in 1:no_test
                long_sum, short_sum = long_vs_short_path(N, d, p, perc)
                long_sums[i] = long_sum
                short_sums[i] = short_sum
            end
            store_long[j,1] = mean(long_sums)
            store_short[j,1] = mean(short_sums)
            store_long[j,2] = std(long_sums)
            store_short[j,2] = std(short_sums)
            println("For N = $N")
            println("Mean longest path distance: $(mean(long_sums)) ± $(std(long_sums))")
            println("Mean shortest path distance: $(mean(short_sums)) ± $(std(short_sums))")
            println("Compare to distance geodesic: $(d_minkowski(ones(d), zeros(d), d, p)), perc is $perc \n")
        end

        #############
        # save data #
        #############
        max_R = d_minkowski(ones(d), zeros(d), d, p);
        using JLD # https://juliapackages.com/p/jld
        save(string("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/Vary_perc/204060/", filename, ".jld"),
        "arr_long", store_long,"arr_short", store_short,
        "dim", d, "N", store_N, "R", max_R*perc/100, "p", p)
    end
end

## CUBE SPACE (fixed perc)
###########################
# get data # vary p and N #
###########################
for p in [-2,-1.5,-1,-0.5,0.5,1,1.5,2]
    space_type = "cube" # either cube or cone
    d=2; no_test = 100; perc = 30
    long_sums = zeros(no_test); short_sums = zeros(no_test);
    filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_$p"
    # define storing arrays
    store_N = [2^i for i in 1:12]
    store_long = zeros(12,2)
    store_short = zeros(12,2)
    # get data
    for j in 1:12
        N = store_N[j]
        for i in 1:no_test
            long_sum, short_sum = long_vs_short_path(N, d, p, perc)
            long_sums[i] = long_sum
            short_sums[i] = short_sum
        end
        store_long[j,1] = mean(long_sums)
        store_short[j,1] = mean(short_sums)
        store_long[j,2] = std(long_sums)
        store_short[j,2] = std(short_sums)
        println("For N = $N")
        println("Mean longest path distance: $(mean(long_sums)) ± $(std(long_sums))")
        println("Mean shortest path distance: $(mean(short_sums)) ± $(std(short_sums))")
        println("Compare to distance geodesic: $(d_minkowski(ones(d), zeros(d), d, p)), perc is $perc \n")
    end
    #############
    # save data #
    #############
    max_R = d_minkowski(ones(d), zeros(d), d, p);
    using JLD # https://juliapackages.com/p/jld
    save(string("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/Vary_p/", filename, ".jld"),
    "arr_long", store_long,"arr_short", store_short,
    "dim", d, "N", store_N, "R", max_R*perc/100, "p", p)
end

## CONE SPACE
##############################
# get data # vary perc and N #
##############################
max_N = 10; # then max(N) is 2^max_N
for perc in [30] # [2,5,10,20,40,60,80,100]
    space_type = "cone" # either cube or cone
    d=2; no_test = 100;
    p = 1 # any p is fine # TODO: make parameter p optional in "long_vs_short_path" function
    long_sums = zeros(no_test); short_sums = zeros(no_test);
    filename = "long_short_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)_parameterp_$(p)_mink"
    # define storing arrays
    store_N = [2^i for i in 1:max_N]
    store_long = zeros(max_N,2)
    store_short = zeros(max_N,2)
    # get data
    for j in 4:max_N
        N = store_N[j]
        for i in 1:no_test
            long_sum, short_sum = long_vs_short_path(N, d, p, perc, space_type)
            long_sums[i] = long_sum
            short_sums[i] = short_sum
        end
        store_long[j,1] = mean(long_sums)
        store_short[j,1] = mean(short_sums)
        store_long[j,2] = std(long_sums)
        store_short[j,2] = std(short_sums)
        println("For N = $N")
        println("Mean longest path distance: $(mean(long_sums)) ± $(std(long_sums))")
        println("Mean shortest path distance: $(mean(short_sums)) ± $(std(short_sums))")
        println("Compare to distance geodesic: 1, perc is $perc \n")
    end

    #############
    # save data #
    #############
    max_R = d_minkowski(ones(d), zeros(d), d, p);
    using JLD # https://juliapackages.com/p/jld
    save(string("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/Vary_perc/204060/", filename, ".jld"),
    "arr_long", store_long,"arr_short", store_short,
    "dim", d, "N", store_N, "R", max_R*perc/100, "p", p)
end

using Dagology
using Test
using LightGraphs
using LinearAlgebra
using GraphPlot
using Statistics
using SpecialFunctions
using LaTeXStrings
using Plots

# Coefficient m_x
function _get_m_x(avg_longest, d, N)
    return avg_longest/(N^(1/d))
end

# upper bound c_x of m_x
# (x in the literature is either Cu(d) or Co(d), i.e. d-dimensional cube and cone space respectively)
function _get_c_x(space_type, d)
    if space_type != "cube" && space_type != "cone"
        println("Please either enter cone or cube as space_type.")
        throw(DomainError(:wrongdimension))
    end
    if space_type == "cube"
        c_x = ℯ;
    else space_type == "cone"
        c_x = ℯ*((2^(1-1/D)*(gamma(1+d))^(1/d))/(d));
    end
end

# lower bound of m_x
function _get_lower_bound(c_x, d)
    return (c_x*d)/(ℯ*(gamma(1+d))^(1/d)*gamma(1+1/d))
end

###############
# set up data #
###############
space_type = "cube"             # either "cube" or "cone"
d = 3;
no_test = 5;                  # we average over no_test runs
perc = 100; max_R = Inf64; R = max_R*perc/100
filename = "store_m_x_$(space_type)_dim_$(d)_avg_test_$(no_test)_perc_$(perc)"
# get bounds
c_x = _get_c_x(space_type, d)
lower_bound = _get_lower_bound(c_x, d)
# storing arrays
store_m_x = zeros(12);
store_N = zeros(12);
store_err = zeros(12);

#################################################################
# get data
for i in 1:12
    N = 2^i
    store_N[i] = N;
    longest = zeros(no_test);       # store longest path distance for each test
    for j in 1:no_test
        pos, g = cube_space_digraph(N, d, R);
        longest_arr = my_sslp(g, topological_sort_by_dfs(g), 1)
        longest[j] = maximum(longest_arr)
    end
    avg_longest = mean(longest);
    m_x = _get_m_x(avg_longest, d, N)
    store_err[i] = std(longest)*abs(m_x)/abs(avg_longest);
    # println("For N = $N this is the avg longest path $avg_longest ± $(std(longest))")
    # println("we have found the value $m_x for m_x, greater than $lower_bound . \n")
    store_m_x[i] = m_x
end
#################################################################
# save data
using JLD # https://juliapackages.com/p/jld
save(string("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/", filename, ".jld"),
 "arr", store_m_x, "dim", d, "N", store_N, "R", max_R*perc/100, "err", store_err)

#################################################################
# load data
using JLD # https://juliapackages.com/p/jld
loading = load(string("C:/Users/enric/Documents/Imperial/MSc_Thesis/Data/", filename, ".jld"))
store_m_x = loading["arr"]
d = loading["dim"]
store_N = loading["N"]
R = loading["R"]
store_err = loading["err"]


pyplot() # this backend supports log2 scaling
plot()
plot(store_N, store_m_x, yerr  = store_err, line = :scatter, marker = :circle, c = :orange, label = "")
plot!(store_N, ones(12)*c_x, label = "")
plot!(store_N, ones(12)*lower_bound, label = "")
xaxis!(:log2, xlabel = L"N")
yaxis!(ylabel = L"m_x")
xticks!([2^i for i in 1:12])
annotate!([(100, c_x-0.1, ("upper bound", 12, :red, :center))])
annotate!([(100, lower_bound-0.1, ("lower bound", 12, :green, :center))])
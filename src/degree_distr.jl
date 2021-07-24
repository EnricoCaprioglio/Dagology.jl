# function to get degree distribution
using LightGraphs
# just get the length of the g.fadjlist and g.badjlist

"""
degree_distr(g::SimpleDiGraph{Int64})

    A simple function to get an array with the degree distribution of
    some graph g.

    Input:
        g           graph we want to find the distribution of
                    at the moment this is onlu for simple direcetd graphs
                    i.e. g::SimpleDiGraphInt64{}

    return k_out, k_in

    Output:
        K_out       array with value of k^{out} for each vertex.
                    k_out::Vector{Int64}
        k_in        array with value of k^{in} for each vertex.
                    k_in::Vector{Int64}
"""
function degree_distr(g::SimpleDiGraph{Int64})
    k_out = [length(j) for j ∈ g.fadjlist]
    k_in = [length(j) for j ∈ g.badjlist]
    return k_out, k_in
end
using LightGraphs

"""
``degree_distr(g::SimpleDiGraph{Int64})``

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

"""
``frequencies_dict(data, N)``

A simple function that outputs a dictionary storing the frequencies of each value contained in data
and the number of zeros.
"""
function frequencies_dict(data, N)
    dict = Dict{Int64,Int64}()
    num_zeros = 0
    for i in 1:N
        if data[i] == 0
            num_zeros += 1
        else
            if data[i] ∈ dict.keys
                dict[data[i]] += 1
            else
                dict[data[i]] = 1
            end
        end
    end
    return dict, num_zeros
end
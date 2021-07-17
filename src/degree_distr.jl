# function to get degree distribution
using LightGraphs
# just get the length of the g.fadjlist and g.badjlist
function degree_distr(g::SimpleDiGraph{Int64})
    k_out = [length(j) for j ∈ g.fadjlist]
    k_in = [length(j) for j ∈ g.badjlist]
    return k_out, k_in
end


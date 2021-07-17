using LightGraphs
using Plots
using LinearAlgebra

function box_space_digraph(N, d, p)
    Box_pos = rand(N,d)
    g = SimpleDiGraph(N)
    for i in 1:N
        for j in 1:N
            if (all(Box_pos[i,:]-Box_pos[j,:].<0) && isless(rand(1)[1],p))
                add_edge!(g, i, j);
            end
        end
    end
    return Box_pos, g
end
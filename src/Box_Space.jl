using LightGraphs
using Plots
using LinearAlgebra

function box_space_digraph(N::Int64, d::Int64, p = 1.0)
    """
    box_space_digraph(N::Int64, d::Int64, p::Float16)
    
        N is the number of vertices in the final digraph
        d is the dimensino of the box space
        p the probability that an edge is wired

    """
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

function cone_space_digraph(N, d, p, R)
    time_vec = rand(N);                     # times
    sort!(time_vec);                        # time ordering
    Box_pos = hcat(time_vec,rand(N,d-1));   # positions
    g = SimpleDiGraph(N);
    for i in 1:N
        for j in i:N
            time_sep = abs(norm(Box_pos[j,2:d]) - norm(Box_pos[i,2:d]))
            if time_sep < R && isless(rand(1)[1],p)
                add_edge!(g, i, j);
            end
        end
    end
    return Box_pos, g
end
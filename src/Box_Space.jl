using LightGraphs
using LinearAlgebra
using StaticGraphs

# TODO: Idea to optimize the code: instead of throwing some points at random in the space
# and then connect accoring to the connection kernel we could either order them already
# this avoid checking if all coordinates of a point are less than all the coordinates 
# of the point it is connecting to.

"""
``cube_space_digraph(N::Int64, d::Int64, p::Float16 = 1.0)``

    Inputs:
        N            number of vertices in the final digraph, ``N ∈ mathbb{N}``
        d            dimension of the box space, ``d ∈ mathbb{N}``
        prob         probability that an edge is wired, default ``prob = 1.0``
        R            connection kernel parameter, edge (i, j) is allowed if the 
                        minkowski distance between i and j is less than R
                        default: ``R = Inf64``

    return Box_pos, g

    Outputs:
        pos          ``N x d`` matrix where each row i contains the coordinates of
                        node i.
        g            Directed Acyclic Graph, ``g::SimpleDiGraph{Int64}``
"""
function cube_space_digraph(N::Int64, d::Int64, R = Inf64, p = 2.0, prob = 1.0)
    positions = rand(N-2,d);
    pos = vcat(zeros(d)', positions, ones(d)')
    g = SimpleDiGraph(N);
    for i in 1:N
        for j in 1:N
            if (all(pos[i,:]-pos[j,:].<0) && isless(rand(1)[1], prob))
                if d_minkowski(pos[j,:], pos[i,:], d, p) < R;
                    add_edge!(g, i, j);
                end
            end
        end
    end
    return pos, g
end

"""

"""
function static_cube_space(N::Int64, d::Int64, R, p0 = 2.0, p = 1.0)
    fwd = Vector{Tuple{Int64, Int64}}();
    positions = rand(N-2,d);
    pos = vcat(zeros(d)', positions, ones(d)')
    for i in 1:N
        for j in 1:N
            if (all(pos[i,:]-pos[j,:].<0) && isless(rand(1)[1],p))
                if d_minkowski(pos[j,:], pos[i,:], d, p0) < R;
                    push!(fwd, (i, j))
                end
            end
        end
    end
    g = StaticDiGraph(N, fwd, sort(reverse.(fwd)))
    return pos, g
end

"""
``cone_space_digraph(N::Int64, d::Int64, p::Float16 = 1.0, R = Inf64)``

    Creates a Directed Acyclic Graph of N vertices, each with coordinates in d
    dimensions. Vertices are connected if the edge is timelike future directed. 
    Coordinates are generated randomly. The generated coordinates are sorted
    according to the time ordering of the first coordinate (``x_0``).
    In general, a vertex ``v = (x_0, x_1, ..., x_{d-1})`` is connected to vertex
    ``w = (y_0, y_1, ..., y_{d-1})`` if ``|vec{x} - vec{y}| ≤ y_0 - x_0``
    The ``| • |`` indicates the Euclidean metric (norm function in LinearAlgebra package).

    (same defintion of cone sapce used by Bollobàs and Brightwell in 
    "Box spaces and random partial orders" transactions of the American 
    Mathematical Society, Vol 324, Number 1, March 1991)

    Inputs:
        N            number of vertices in the final digraph, N ∈ mathbb{N}
        d            dimension of the box space, d ∈ mathbb{N}
        p            probability that an edge is wired, default ``p = 1.0```
        R            forward connection kernel parameter, defaul R = Inf64
        
    return Box_pos, g

    Outputs:
        Box_pos      Nxd matrix where each row i contains the coordinates of
                        node i.
        g            Directed Acyclic Graph, g::SimpleDiGraph{Int64}
"""
function cone_space_digraph(N::Int64, d::Int64, p = 1.0) # , R = Inf64
    time_vec = rand(N);                     # times
    sort!(time_vec);                        # time ordering
    Box_pos = hcat(time_vec,rand(N,d-1));   # positions
    g = SimpleDiGraph(N);
    for i in 1:N
        for j in i:N
            spatial_diff = norm(Box_pos[i,2:end] - Box_pos[j,2:end]);
            temp_diff = Box_pos[j,1] - Box_pos[i,1];
            # time_sep = abs(norm(Box_pos[j,2:d]) - norm(Box_pos[i,2:d]))
            if (spatial_diff < temp_diff && isless(rand(1)[1],p) )
                add_edge!(g, i, j);
            end
        end
    end
    return Box_pos, g
end

# the following is just a function defined for a test
function _cone_space_digraph_check(N::Int64, d::Int64, p = 1.0) # , R::Float16
    time_vec = rand(N);                     # times
    sort!(time_vec);                        # time ordering
    Box_pos = hcat(time_vec,rand(N,d-1));   # positions
    g1 = SimpleDiGraph(N);
    g2 = SimpleDiGraph(N);
    for i in 1:N
        for j in 1:N
            spatial_diff = norm(Box_pos[i,2:end] - Box_pos[j,2:end]);
            temp_diff = Box_pos[j,1] - Box_pos[i,1];
            # time_sep = abs(norm(Box_pos[j,2:d]) - norm(Box_pos[i,2:d]))
            if (spatial_diff < temp_diff && isless(rand(1)[1],p) )
                add_edge!(g1, i, j);
            end
        end
        for k in i:N
            spatial_diff = norm(Box_pos[i,2:end] - Box_pos[k,2:end]);
            temp_diff = Box_pos[k,1] - Box_pos[i,1];
            # time_sep = abs(norm(Box_pos[j,2:d]) - norm(Box_pos[i,2:d]))
            if (spatial_diff < temp_diff && isless(rand(1)[1],p) )
                add_edge!(g2, i, k);
            end
        end
    end
    return Box_pos, g1, g2
end
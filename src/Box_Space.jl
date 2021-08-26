using LightGraphs
using LinearAlgebra
using StaticGraphs

# TODO: Idea to optimize the code: instead of throwing some points at random in the space
# and then connect accoring to the connection kernel we could either order them already
# this avoid checking if all coordinates of a point are less than all the coordinates 
# of the point it is connecting to.
# sorting is not super fast but the current cube_space_digraph is O(N^2), whcih means that for 
# any N ≥ 100'000 it becomes very slow on a "normal" machine.
# maybe use merge-sort or heap-sort which are O(Nlog(N))

"""
``cube_space_digraph(N::Int64, d::Int64, p::Float16 = 1.0)``

Creates a cube space in which there is a link between points x and y if
``x_i > y_i `` for all i and d_p(x,y) < R.

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
``static_cube_space(N::Int64, d::Int64, R = Inf64, p = 2.0, prob = 1.0)``

Creates a cube space in which there is a link between points x and y if
``x_i > y_i `` for all i and d_p(x,y) < R. This function uses static graphs
for which graph measures are optimized but edges and vertices cannot be added.

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
        g            Directed Acyclic Graph, ``g::StaticDiGraph{Int64}``
"""
function static_cube_space(N::Int64, d::Int64, R = Inf64, p = 2.0, prob = 1.0)
    fwd = Vector{Tuple{Int64, Int64}}();
    positions = rand(N-2,d);
    pos = vcat(zeros(d)', positions, ones(d)')
    for i in 1:N
        for j in 1:N
            if (all(pos[i,:]-pos[j,:].<0) && isless(rand(1)[1],prob))
                if d_minkowski(pos[j,:], pos[i,:], d, p) < R;
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
function cone_space_digraph(N::Int64, d::Int64, R = Inf64, p = 2.0, prob = 1.0)
    time_vec = rand(N-2);                       # times
    pushfirst!(time_vec, 0);                    # add source
    push!(time_vec, 1);                         # add sink
    sort!(time_vec);                            # time ordering
    pos_temp = zeros(d-1)'                      # positions, start from source
    k = 2;
    while k < N
        spatial_coords = rand(1,d-1).-0.5;
        if time_vec[k] < 0.5
            if norm(spatial_coords) <= time_vec[k]
                pos_temp = vcat(pos_temp, spatial_coords)
                k += 1
            end
        else
            if norm(spatial_coords) <= (1-time_vec[k])
                pos_temp = vcat(pos_temp, spatial_coords)
                k += 1
            end
        end
    end
    sink = zeros(d-1);                          # positions, add sink
    pos_temp = vcat(pos_temp, sink')
    pos = hcat(time_vec, pos_temp)              # merge time_vec and positions
    g = SimpleDiGraph(N);
    for i in 1:N
        for j in i:N
            spatial_diff = norm(pos[i,2:end] - pos[j,2:end]);
            temp_diff = pos[j,1] - pos[i,1];
            if (spatial_diff < temp_diff && isless(rand(1)[1],prob) )
                add_edge!(g, i, j);
            end
        end
    end
    return pos, g
end

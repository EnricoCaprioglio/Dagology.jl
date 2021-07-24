using LightGraphs
using LinearAlgebra


"""
    box_space_digraph(N::Int64, d::Int64, p::Float16 = 1.0)

    Inputs:
        N            number of vertices in the final digraph, ``N ∈ \mathbb{N}``
        d            dimension of the box space, ``d ∈ \mathbb{N}``
        p            probability that an edge is wired, default ``p = 1.0```

    return Box_pos, g

    Outputs:
        Box_pos      Nxd matrix where each row i contains the coordinates of
                     node i.
        g            Directed Acyclic Graph, g::SimpleDiGraph{Int64}
"""
function cube_space_digraph(N::Int64, d::Int64, p = 1.0)
    Box_pos = rand(N,d);
    g = SimpleDiGraph(N);
    for i in 1:N
        for j in 1:N
            if (all(Box_pos[i,:]-Box_pos[j,:].<0) && isless(rand(1)[1],p))
                add_edge!(g, i, j);
            end
        end
    end
    return Box_pos, g
end

"""
    cone_space_digraph(N::Int64, d::Int64, p::Float16 = 1.0, R::Float16 = Inf16)
    
    Creates a Directed Acyclic Graph of N vertices, each with coordinates in d
    dimensions. Vertices are connected if the edge is timelike future directed. 
    Coordinates are generated randomly. The generated coordinates are sorted
    according to the time ordering of the first coordinate (``x_0``).
    In general, a vertex ``v = (x_0, x_1, ..., x_{d-1})`` is connected to vertex
    ``w = (y_0, y_1, ..., y_{d-1})`` if ``|\vec{x} - \vec{y}| ≤ y_0 - x_0``

    # TODO add distance measure and forward connection kenrel, i.e. use R and some notion of distance
           to do this, it would be cool to undersatnd how to input a method in the function argumetns
    
    (same defintion of cone sapce used by Bollobàs and Brightwell in 
    "Box spaces and random partial orders" transactions of the American 
    Mathematical Society, Vol 324, Number 1, March 1991)

    Inputs:
        N            number of vertices in the final digraph, N ∈ \mathbb{N}
        d            dimension of the box space, d ∈ \mathbb{N}
        p            probability that an edge is wired, default ``p = 1.0```
        R            forward connection kernel parameter, defaul R = Inf16

    return Box_pos, g

    Outputs:
        Box_pos      Nxd matrix where each row i contains the coordinates of
                     node i.
        g            Directed Acyclic Graph, g::SimpleDiGraph{Int64}
"""
function cone_space_digraph(N::Int64, d::Int64, p::Float16 = 1.0, R::Float16 = Inf16)
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

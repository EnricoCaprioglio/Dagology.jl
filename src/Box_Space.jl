using LightGraphs
using LinearAlgebra
using StaticGraphs
"""

"""
function RGG(N, R, d = 2)
    pos = rand(N,d);
    g = SimpleGraph(N);
    for i in 1:N
        for j in 1:N
            if isless(((pos[i,1]-pos[j,1])^2 + (pos[i,2]-pos[j,2])^2)^(1/2), R) # Euclidean distance
                add_edge!(g, i, j);
            end
        end
    end
    return pos, g
end

# TODO: Idea to optimize the code: instead of throwing some points at random in the space
# and then connect accoring to the connection kernel we could either order them already
# this avoid checking if all coordinates of a point are less than all the coordinates 
# of the point it is connecting to.
# sorting is not super fast but the current cube_space_digraph is O(N^2), whcih means that for 
# any N ≥ 100'000 it becomes very slow on a "normal" machine.
# maybe use merge-sort or heap-sort which are O(Nlog(N))

"""
``cube_space_digraph(N::Int64, d::Int64, R = Inf64, p = 2.0, prob = 1.0)``

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
                if d_minkowski(pos[j,:], pos[i,:], d, p) <= R;
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

# TODO: generalize for d dimension the function "cone_space_digraph"
# currently works only for d = 2 and d = 3. Can we use the rejection sampling
# method for d-dimensions?

"""
``cone_space_digraph(N::Int64, d::Int64, R = Inf64, prob = 1.0)``

    Creates a Directed Acyclic Graph of N vertices, each with coordinates in 2 or 3
    dimensions. A DomainError error is raise if ``d != 2 && d != 3``.

    Vertices are connected if the edge is timelike future directed and less than R.
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
        d            dimension of the box space, ``d = 2 || d = 3``.
        p            probability that an edge is wired, default ``p = 1.0```
        R            forward connection kernel parameter, defaul R = Inf64
        
    return pos, g

    Outputs:
        pos      Nxd matrix where each row i contains the coordinates of
                        node i.
        g            Directed Acyclic Graph, g::SimpleDiGraph{Int64}
"""
function cone_space_digraph(N::Int64, d::Int64, R = Inf64, prob = 1.0)
    if d == 3
        # uniformly sample points in a 2-ball of radius 1
        N_temp = N*6
        pos_temp = zeros(N_temp, d)
        for i in 1:N_temp
        u = rand(Normal(0,1))
        v = rand(Normal(0,1))
        w = rand(Normal(0,1))
        e = rand(Exponential(1))
        denom = (e + u*u + v*v + w*w)^(0.5)
        pos_temp[i, 2] = u/denom
        pos_temp[i, 3] = v/denom
        pos_temp[i, 1] = w/denom
        end
        pos_temp./=2;                               # resize
        pos_temp[:,1].+=0.5;                        # translate z-coordinate
    else
        if d != 2
            return throw(DomainError(:wrongdimension))
        end
        # uniformly sample points in a 1-ball of radius 1
        N_temp = N*5
        d=2;
        pos_temp = zeros(N_temp, d);
        denom = 0
        for i in 1:N_temp
            s = rand(Normal(0,1))
            t = rand(Normal(0,1))
            u = rand(Normal(0,1))
            v = rand(Normal(0,1))
            denom = (s*s + t*t + u*u + v*v)^(0.5)
            pos_temp[i, 2] = u/denom
            pos_temp[i, 1] = v/denom
        end
        pos_temp./=2;
        pos_temp[:,1].+=0.5;
    end
    pos_temp = sortslices(pos_temp,dims=1)      # time ordering
    to_delete = []
    # add to delete list points outside the cone
    for i in 1:N_temp
       if pos_temp[i,1] < 0.5
          if norm(pos_temp[i,2:end]) > pos_temp[i,1]
             push!(to_delete, i)
          end
       else
          if norm(pos_temp[i,2:end]) > (1-pos_temp[i,1])
             push!(to_delete, i)
          end
       end
    end
    new_N = N_temp-length(to_delete)
    if new_N > N+2
        while length(to_delete) < N_temp - N+2
            random = round(Int,rand()*N_temp)
            if random in to_delete
                continue
            else
                push!(to_delete, random)
            end
        end
    else
        return 1,1 # TODO: find a better solution
    end
    # remove not accepted points
    if N_temp-length(to_delete) != (N-2)
        println("we have an issue here, the number of
         vertices $(N_temp-length(to_delete)) != N-2")
    end
    pos = zeros(N-2, d)
    counter = 1
    for i in 1:N_temp
        if i in to_delete
            continue
        else
            if counter > N-2
                break
            end
            pos[counter,:] = pos_temp[i,:]
            counter+=1
        end
    end
    sink = pushfirst!(zeros(d-1), 1);
    pos = vcat(zeros(d)', pos, sink')
    counter += 1
    # using the sampled points generate the DiGraph
    g = SimpleDiGraph(counter);
    for i in 1:counter
          for j in i:counter
             spatial_diff = norm(pos[i,2:end] - pos[j,2:end]);
             temp_diff = pos[j,1] - pos[i,1];
             if (spatial_diff < temp_diff && isless(rand(1)[1],prob))
                if (temp_diff^2 - spatial_diff^2)^(1/2) <= R
                      add_edge!(g, i, j);
                end
             end
          end
    end
    return pos, g
end

# NOTE: this might seem a too complicated method and I am sure it can be improved.
# The naive choice of selecting a random time vector and then constructing the cone
# around this axis resulted in a non uniform distribution. A similar example of this
# can be found here https://twitter.com/fermatslibrary/status/1430932503578226688?s=20 
# My naive solution uses rejectiuon sampling and a well known formula [1] than can be
# generalized to  d dimensions to sample random points inside a d-ball and then keep 
# only the points in both the future cone of the source and the past cone of the sink.
# A slightly easier solution would have been to sample points inside a cube space
# but it would have more expensive computationally. This is just because the volume
# of cube is larger than the volume of the two cones.

# References 
# [1]: BARTHE et al, A  PROBABILISTIC  APPROACH  TO  THE GEOMETRY  OF  THE l^{n}_{p}-BALL, 2005
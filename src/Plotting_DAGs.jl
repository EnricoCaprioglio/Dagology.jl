using LightGraphs
using Plots
using LinearAlgebra
using Colors
using GraphPlot

function DAG_plot_2D(g, pos, path, nodesizes = false, nodefillcs = false, rotated = false, nodelabels = false)
    if length(pos[1,:]) != 2
        throw(DomainError(:wrongdimension))
    end
    N = size(pos)[1];
    locs_x = pos[:,1];
    locs_y = ones(N)-pos[:,2];
    θ = π/4;
    x_prime = locs_x.*cos(θ) + locs_y.*sin(θ)
    y_prime = (locs_y.*cos(θ) - locs_x.*sin(θ)).*5
    # plot graph
    if nodesizes
        nodesize = [degree(g)[v] for v in vertices(g)];
    else
        nodesize = ones(size(pos)[1]);
    end
    if nodefillcs
        # from https://juliagraphs.org/GraphPlot.jl/
        max_size = [degree(g)[v] for v in vertices(g)]
        alphas = max_size/maximum(max_size);
        nodefillc = [RGBA(0.0,0.8,0.8,i) for i in alphas];
    else
        # from https://juliagraphs.org/GraphPlot.jl/
        membership = ones(N);
        for k in path
            membership[k] = 2
        end
        nodecolor = [colorant"lightseagreen", colorant"red"];
        nodefillc = nodecolor[convert(Vector{Int64}, membership)];
    end
    if rotated
        if nodelabels
            nodelabel = collect(1:N)
            display(gplot(g, x_prime, y_prime, nodefillc=nodefillc, nodesize=nodesize, nodelabel=nodelabel))
        else
            display(gplot(g, x_prime, y_prime, nodefillc=nodefillc, nodesize=nodesize))
        end
    else
        if nodelabels
            nodelabel = collect(1:N)
            display(gplot(g, locs_x, locs_y, nodefillc=nodefillc, nodesize=nodesize, nodelabel=nodelabel))
        else
            display(gplot(g, locs_x, locs_y, nodefillc=nodefillc, nodesize=nodesize))
        end
    end
end

function DAG_Plot_3D(Box_pos, g)
    if length(Box_pos[1,:]) != 3
        throw(DomainError(:wrongdimension))
    end
    z = Box_pos[:,1];
    x = Box_pos[:,2];
    y = Box_pos[:,3];
    display(scatter(x,y,z,legend = false))
    N = size(Box_pos)[1]
    for i in 1:N
        for j ∈ g.fadjlist[i]
            z1 = [Box_pos[i,:][1],Box_pos[j,:][1]]
            x1 = [Box_pos[i,:][2],Box_pos[j,:][2]]
            y1 = [Box_pos[i,:][3],Box_pos[j,:][3]]
            display(plot!(x1, y1, z1, line=:arrow, arrow=:closed))
        end
    end
end
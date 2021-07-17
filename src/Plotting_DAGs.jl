using LightGraphs
using Plots
using LinearAlgebra

function DAG_Plot_2D(Box_pos, g)
    if length(Box_pos[1,:]) != 2
        throw(DomainError(:wrongdimension))
    end
    display(scatter(Box_pos[:,2],Box_pos[:,1],legend = false))
    N = size(Box_pos)[1]
    for i in 1:N
        for j ∈ g.fadjlist[i]
            x = [Box_pos[i,:][1],Box_pos[j,:][1]];
            y = [Box_pos[i,:][2],Box_pos[j,:][2]];
            display(plot!(y, x,
            line=:arrow, arrow=:closed
            ))
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
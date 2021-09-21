module Dagology

# files you want to include
include("degree_distr.jl")
include("Box_Space.jl")
include("Plotting_DAGs.jl")
include("longest_path.jl")
include("Minkowski_dist.jl")

# functions to export
# these functions will be ready to use when using Dagology
export degree_distr
export find_sources
export my_TopSort_by_dfs
export my_sslp
export my_sslp_v2
export cube_space_digraph
export cone_space_digraph
export DAG_plot_2D
export DAG_Plot_3D
export find_sinks
export d_minkowski
# export cube_space_with_R
export static_cube_space
export get_longest_path_vertices
export get_shortest_path_vertices
export frequencies_dict
export plot_G_with_unit_ball
export long_vs_short_path
export RGG

end # module

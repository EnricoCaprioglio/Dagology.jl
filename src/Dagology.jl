module Dagology

# greet() = print("Hello World!")

# files you want to include
include("degree_distr.jl")
include("Box_Space.jl")
include("Plotting_DAGs.jl")
include("longest_path.jl")

# functions to export
# these functions will be ready to use when using Dagology
export degree_distr
export find_sources
export my_TopSort_by_dfs
export my_sslp
export my_sslp_v2
export box_space_digraph
export cone_space_digraph
export DAG_Plot_2D
export DAG_Plot_3D

end # module

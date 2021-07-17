module Dagology

# greet() = print("Hello World!")

# files you want to include
include("degree_distr.jl")
include("Box_Space.jl")
include("Plotting_DAGs.jl")

# functions to export
# these functions will be ready to use when using Dagology
export degree_distr

end # module

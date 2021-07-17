using Documenter
using Dagology

makedocs(
    sitename = "Dagology",
    format = Documenter.HTML(),
    modules = [Dagology]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#

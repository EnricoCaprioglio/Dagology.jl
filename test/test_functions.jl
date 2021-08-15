
using Dagology
using LightGraphs
using GraphPlot
using Test

##########################################################################
# create test DAG
N = 30;
E = N*5;
g = SimpleDiGraph(N);
for i in 1:E
    a = rand(1:N)
    b = rand(1:N)
    if b > a
        add_edge!(g, a, b)
    end
end

##########################################################################

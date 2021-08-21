using LinearAlgebra

"""
Oriented Minkowski distance, require that all ``x_i >= y_i``.

This is the distance that we can use in cube space.
"""
function d_minkowski(x, y, d, p)
    result = 0;
    for i in 1:d
        result += abs.(x[i]-y[i])^p;
    end
    return result^(1/p)
end
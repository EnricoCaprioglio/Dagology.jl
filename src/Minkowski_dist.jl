using LinearAlgebra

"""
Docstring
"""
function Mink_dist(x, y, d, p)
    result = 0;
    for i in 1:d
        result += (x[i]-y[i])^p;
    end
    return result^(1/p)
end




"""
Kernel
"""

struct LegendreBasis <: Basis
    beta::Float64
    o::PyObject
    u::PiecewiseLegendrePoly
    uhat::PiecewiseLegendreFT
    v::Nothing
    statistics::Statistics
    size::Int64
end

LegendreBasis(o::PyObject) = LegendreBasis(
        o.beta, o, o.u, o.uhat, o.v,
        o.statistics == "F" ? fermion : boson,
        o.size
    )

function LegendreBasis(
    statistics::Statistics, beta::Real, size::Int64; cl::Vector{Float64}=ones(Float64, size))
    LegendreBasis(pyaugment.LegendreBasis(statistics, beta, size, cl))
end
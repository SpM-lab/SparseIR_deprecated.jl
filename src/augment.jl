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

function LegendreBasis(o::PyObject)
    return LegendreBasis(o.beta, o, o.u, o.uhat, o.v,
                         o.statistics == "F" ? fermion : boson,
                         o.size)
end

function LegendreBasis(statistics::Statistics, beta::Real, size::Int64;
                       cl::Vector{Float64}=ones(Float64, size))
    return LegendreBasis(pyaugment.LegendreBasis(statistics, beta, size, cl))
end

function default_tau_sampling_points(basis::LegendreBasis)
    return basis.o.default_tau_sampling_points()
end

function default_matsubara_sampling_points(basis::LegendreBasis; mitigate=true)
    return basis.o.default_matsubara_sampling_points()
end

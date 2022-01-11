"""
Sampling
"""
abstract type Sampling end

struct MatsubaraSampling <: Sampling
    o::PyObject
    sampling_points::Vector{Int64}
end


struct TauSampling <: Sampling
    o::PyObject
    sampling_points::Vector{Float64}
end

function MatsubaraSampling(basis::FiniteTempBasis, sampling_points::Union{Nothing,Vector{Int64}}=nothing)
    if sampling_points === nothing
        sampling_points = basis.o.default_matsubara_sampling_points()
    end
    o = irbasis3.MatsubaraSampling(basis.o, sampling_points)
    MatsubaraSampling(o, sampling_points)
end

function TauSampling(basis::FiniteTempBasis, sampling_points::Union{Nothing,Vector{Float64}}=nothing)
    if sampling_points === nothing
        sampling_points = basis.o.default_tau_sampling_points()
    end
    o = irbasis3.TauSampling(basis.o, sampling_points)
    TauSampling(o, sampling_points)
end

function evaluate(smpl::Sampling, al::Array{T,N}; axis::Int64=1) where {T, N}
    smpl.o.evaluate(al, axis-1)
end

function fit(smpl::Sampling, ax::Array{T,N}; axis::Int64=1) where {T, N}
    smpl.o.fit(ax, axis-1)
end
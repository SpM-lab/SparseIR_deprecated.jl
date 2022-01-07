"""
Sampling
"""
abstract type Sampling end

struct MatsubaraSampling <: Sampling
    pyobj
    sampling_points
end

struct TauSampling <: Sampling
    pyobj
    sampling_points
end

function MatsubaraSampling(basis::FiniteTempBasis, sampling_points::Union{Nothing,Vector{Int64}}=nothing)
    if sampling_points === nothing
        sampling_points = basis.pyobj.default_matsubara_sampling_points()
    end
    pyobj = irbasis3.MatsubaraSampling(basis.pyobj, sampling_points)
    MatsubaraSampling(pyobj, sampling_points)
end

function TauSampling(basis::FiniteTempBasis, sampling_points::Union{Nothing,Vector{Float64}}=nothing)
    if sampling_points === nothing
        sampling_points = basis.pyobj.default_tau_sampling_points()
    end
    pyobj = irbasis3.TauSampling(basis.pyobj, sampling_points)
    TauSampling(pyobj, sampling_points)
end

function evaluate(smpl::Sampling, al::Array{T,N}; axis::Int64=1) where {T, N}
    smpl.pyobj.evaluate(al, axis-1)
end

function fit(smpl::Sampling, ax::Array{T,N}; axis::Int64=1) where {T, N}
    smpl.pyobj.fit(ax, axis-1)
end
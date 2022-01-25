"""
Sampling
"""
abstract type Sampling end


function evaluate(smpl::Sampling, al::Array{T,N}; axis::Int64=1)::Array{ComplexF64,N} where {T, N}
    smpl.o.evaluate(al, axis-1)
end

function fit(smpl::Sampling, ax::Array{T,N}; axis::Int64=1)::Array{ComplexF64,N} where {T, N}
    smpl.o.fit(ax, axis-1)
end


"""
Sampling in Matsubara frequency
"""
struct MatsubaraSampling <: Sampling
    o::PyObject
    sampling_points::Vector{Int64}
    cond::Float64
end

function MatsubaraSampling(basis::FiniteTempBasis, sampling_points::Union{Nothing,Vector{Int64}}=nothing)
    if sampling_points === nothing
        sampling_points = basis.o.default_matsubara_sampling_points()
    end
    o = sparse_ir.MatsubaraSampling(basis.o, sampling_points)
    MatsubaraSampling(o, sampling_points, o.cond)
end


"""
Sampling in time
"""
struct TauSampling <: Sampling
    o::PyObject
    sampling_points::Vector{Float64}
    cond::Float64
end

function TauSampling(basis::FiniteTempBasis, sampling_points::Union{Nothing,Vector{Float64}}=nothing)
    if sampling_points === nothing
        sampling_points = basis.o.default_tau_sampling_points()
    end
    o = sparse_ir.TauSampling(basis.o, sampling_points)
    TauSampling(o, sampling_points, o.cond)
end
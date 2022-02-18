"""
Sparse pole representation
"""
struct SparsePoleRepresentation <: Basis
    o::PyObject
    u::PiecewiseLegendrePoly
    uhat::PiecewiseLegendreFT
    statistics::Statistics
    size::Int64
end

Base.size(spr::SparsePoleRepresentation)::Int64 = spr.o.size
statistics(spr::SparsePoleRepresentation)::Statistics = spr.o.statistics

SparsePoleRepresentation(o::PyObject) = SparsePoleRepresentation(
        o, o.u, o.uhat,
        o.statistics == "F" ? fermion : boson,
        o.size
    )

function SparsePoleRepresentation(
        basis::FiniteTempBasis,
        sampling_points::Vector{Float64}=default_omega_sampling_points(basis)
    )
    SparsePoleRepresentation(
        sparse_ir.spr.SparsePoleRepresentation(basis.o, sampling_points)
    )
end

"""
From IR to SPR

gl:
    Expansion coefficients in IR
"""
function from_IR(
    spr::SparsePoleRepresentation,
    gl::Array{T,N}, axis::Int64=1)::Array{ComplexF64,N} where {T,N}
    spr.o.from_IR(gl, axis-1)
end


"""
From SPR to IR

g_spr:
    Expansion coefficients in SPR
"""
function to_IR(
    spr::SparsePoleRepresentation,
    g_spr::Array{T,N}, axis::Int64=1)::Array{ComplexF64,N} where {T,N}
    spr.o.to_IR(g_spr, axis-1)
end
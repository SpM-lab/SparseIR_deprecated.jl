"""
FiniteTempBasis
"""
struct FiniteTempBasis
    o::PyObject
    u::PiecewiseLegendrePoly
    uhat::PiecewiseLegendreFT
    v::PiecewiseLegendrePoly
    s::Vector{Float64}
    statistics::Statistics
end

Base.size(basis::FiniteTempBasis)::Int64 = basis.o.size
statistics(basis::FiniteTempBasis)::Statistics = basis.o.statistics

FiniteTempBasis(o::PyObject) = FiniteTempBasis(
    o, o.u, o.uhat, o.v, o.s, o.statistics == "F" ? fermion : boson)

"""
Create a FiniteTempBasis object by decomposing a given kernel
"""
function FiniteTempBasis(
    kernel::KernelBase, statistics::Statistics, beta::Real, eps::Union{Float64,Nothing}=nothing)
    o = sparse_ir.FiniteTempBasis(
        kernel.o, statistics==fermion ? "F" : "B", Float64(beta), eps=eps)
    FiniteTempBasis(o)
end


"""
Create a FiniteTempBasis object using KernelFFlat
"""
function FiniteTempBasis(beta::Real, wmax::Real, statistics::Statistics, eps::Float64)
    FiniteTempBasis(KernelFFlat(Float64(beta * wmax)), statistics, Float64(beta), eps)
end

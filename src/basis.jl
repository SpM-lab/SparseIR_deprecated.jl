"""
FiniteTempBasis
"""
struct FiniteTempBasis
    o::PyObject
    u::PiecewiseLegendrePoly
    uhat::PiecewiseLegendreFT
    v::PiecewiseLegendrePoly
end

Base.size(basis::FiniteTempBasis)::Int64 = basis.o.size
statistics(basis::FiniteTempBasis)::Statistics = basis.o.statistics

FiniteTempBasis(o::PyObject) = FiniteTempBasis(o, o.u, o.uhat, o.v)

"""
Create a FiniteTempBasis object by decomposing a given kernel
"""
function FiniteTempBasis(kernel::KernelBase, statistics::Statistics, beta::Float64, eps::Float64)
    o = sparse_ir.FiniteTempBasis(kernel.o, statistics==fermion ? "F" : "B", beta, eps=eps)
    FiniteTempBasis(o)
end

"""
Create a FiniteTempBasis object using KernelFFlat
"""
function FiniteTempBasis(beta::Float64, wmax::Float64, statistics::Statistics, eps::Float64)
    FiniteTempBasis(KernelFFlat(beta * wmax), statistics, beta, eps)
end
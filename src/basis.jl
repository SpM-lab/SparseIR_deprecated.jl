"""
FiniteTempBasis
"""
struct FiniteTempBasis
    pyobj
    statistics::Statistics
    size::Int64
end

function FiniteTempBasis(kernel::KernelBase, statistics::Statistics, beta::Float64, eps::Float64)
    pyobj = irbasis3.FiniteTempBasis(kernel.pyobj, statistics==fermion ? "F" : "B", beta, eps=eps)
    FiniteTempBasis(pyobj, statistics, pyobj.size)
end

function FiniteTempBasis(beta::Float64, wmax::Float64, statistics::Statistics, eps::Float64)
    kernel = KernelFFlat(beta * wmax)
    FiniteTempBasis(kernel, statistics, beta, eps)
end
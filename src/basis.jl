"""
FiniteTempBasis
"""
struct FiniteTempBasis
    o::PyObject
    statistics::Statistics
    size::Int64
end

"""
Create a FiniteTempBasis object by decomposing a given kernel
"""
function FiniteTempBasis(kernel::KernelBase, statistics::Statistics, beta::Float64, eps::Float64)
    o = irbasis3.FiniteTempBasis(kernel.o, statistics==fermion ? "F" : "B", beta, eps=eps)
    FiniteTempBasis(o, statistics, o.size)
end

"""
Create a FiniteTempBasis object using KernelFFlat
"""
function FiniteTempBasis(beta::Float64, wmax::Float64, statistics::Statistics, eps::Float64)
    kernel = KernelFFlat(beta * wmax)
    FiniteTempBasis(kernel, statistics, beta, eps)
end
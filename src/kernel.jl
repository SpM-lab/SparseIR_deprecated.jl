"""
Kernel
"""
abstract type KernelBase end

struct LogisticKernel <: KernelBase
    o::PyObject
end

function LogisticKernel(lambda::Real)
    LogisticKernel(sparse_ir.LogisticKernel(Float64(lambda)))
end

struct RegularizedBoseKernel <: KernelBase
    o::PyObject
end

function RegularizedBoseKernel(lambda::Real)
    RegularizedBoseKernel(sparse_ir.RegularizedBoseKernel(Float64(lambda)))
end

(k::KernelBase)(x::Float64, y::Float64) = k.o(x, y)
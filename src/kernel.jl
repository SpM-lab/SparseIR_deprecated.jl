"""
Kernel
"""
abstract type KernelBase end

struct KernelFFlat <: KernelBase
    o::PyObject
end

function KernelFFlat(lambda::Float64)
    KernelFFlat(irbasis3.KernelFFlat(lambda))
end

struct KernelBFlat <: KernelBase
    o::PyObject
end

function KernelBFlat(lambda::Float64)
    KernelBFlat(irbasis3.KernelBFlat(lambda))
end

(k::KernelBase)(x::Float64, y::Float64) = k.o(x, y)
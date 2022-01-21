"""
Kernel
"""
abstract type KernelBase end

struct KernelFFlat <: KernelBase
    o::PyObject
end

function KernelFFlat(lambda::Real)
    KernelFFlat(sparse_ir.KernelFFlat(Float64(lambda)))
end

struct KernelBFlat <: KernelBase
    o::PyObject
end

function KernelBFlat(lambda::Real)
    KernelBFlat(sparse_ir.KernelBFlat(Float64(lambda)))
end

(k::KernelBase)(x::Float64, y::Float64) = k.o(x, y)
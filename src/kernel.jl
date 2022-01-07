"""
Kernel
"""
abstract type KernelBase end

struct KernelFFlat <: KernelBase
    pyobj
end

function KernelFFlat(lambda::Float64)
    KernelFFlat(irbasis3.KernelFFlat(lambda))
end

struct KernelBFlat <: KernelBase
    pyobj
end

function KernelBFlat(lambda::Float64)
    KernelBFlat(irbasis3.KernelBFlat(lambda))
end
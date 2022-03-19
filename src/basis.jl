abstract type Basis end

Base.size(basis::Basis)::Int64 = basis.o.size
statistics(basis::Basis)::Statistics = basis.o.statistics

"""
IRBasis
"""
struct IRBasis <: Basis
    o::PyObject
    u::PiecewiseLegendrePoly
    uhat::PiecewiseLegendreFT
    v::PiecewiseLegendrePoly
    s::Vector{Float64}
    statistics::Statistics
    size::Int64
end

IRBasis(o::PyObject) = IRBasis(
        o, o.u, o.uhat, o.v, o.s,
        o.statistics == "F" ? fermion : boson,
        o.size
    )


"""
FiniteTempBasis
"""
struct FiniteTempBasis <: Basis
    beta::Float64
    o::PyObject
    u::PiecewiseLegendrePoly
    uhat::PiecewiseLegendreFT
    v::PiecewiseLegendrePoly
    s::Vector{Float64}
    statistics::Statistics
    size::Int64
end


FiniteTempBasis(o::PyObject) = FiniteTempBasis(
        o.beta, o, o.u, o.uhat, o.v, o.s,
        o.statistics == "F" ? fermion : boson,
        o.size
    )

"""
Create a FiniteTempBasis object by decomposing a given kernel
"""
function FiniteTempBasis(
    kernel::KernelBase, statistics::Statistics, beta::Real, eps::Union{Float64,Nothing}=nothing)
    o = sparse_ir.FiniteTempBasis(
        statistics==fermion ? "F" : "B", Float64(beta), Float64(kernel.o.lambda_/beta), eps=eps, kernel=kernel.o)
    FiniteTempBasis(o)
end


function FiniteTempBasis(
        statistics::Statistics, beta::Real, wmax::Real,
        eps::Union{Float64,Nothing}=nothing
        ;
        kernel::Union{KernelBase,Nothing}=nothing,
    )
    kernel_py = kernel !== nothing ? kernel.o : nothing
    stat =  statistics==fermion ? "F" : "B"
    if beta < 2e-8
        error("xprec is not supported yet.")
    end
    o = sparse_ir.FiniteTempBasis(stat, Float64(beta), Float64(wmax), eps=eps, kernel=kernel_py)
    FiniteTempBasis(o)
end


"""
Create a FiniteTempBasis object using LogisticKernel
"""
function FiniteTempBasis(
        beta::Real,
        wmax::Real,
        statistics::Statistics,
        eps::Union{Float64,Nothing}
    )
    FiniteTempBasis(LogisticKernel(Float64(beta * wmax)), statistics, Float64(beta), eps)
end


"""
Construct FiniteTempBasis objects for fermion and bosons using
the same LogisticKernel instance.
"""
function finite_temp_bases(
            beta::Float64, wmax::Float64, eps::Float64
        )::Tuple{FiniteTempBasis, FiniteTempBasis}
    basis_f, basis_b = sparse_ir.basis.finite_temp_bases(beta, wmax, eps)
    return (FiniteTempBasis(basis_f), FiniteTempBasis(basis_b))
end


function default_omega_sampling_points(basis::FiniteTempBasis)::Vector{Float64}
    basis.o.default_omega_sampling_points()
end


function default_tau_sampling_points(basis::FiniteTempBasis)::Vector{Float64}
    basis.o.default_tau_sampling_points()
end


function default_matsubara_sampling_points(basis::FiniteTempBasis)::Vector{Int64}
    basis.o.default_matsubara_sampling_points()
end
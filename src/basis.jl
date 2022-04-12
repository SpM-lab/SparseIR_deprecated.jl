abstract type Basis end

Base.size(basis::Basis)::Int64 = basis.o.size
statistics(basis::Basis)::Statistics = basis.o.statistics

const SVEResultType = Tuple{PiecewiseLegendrePoly,Vector{Float64},PiecewiseLegendrePoly}

"""
IRBasis
"""

#==
struct IRBasis <: Basis
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

const SVEResultType = Tuple{Matrix{Float64}, Vector{Float64}, Matrix{Float64}}

function get_kernel(statistics::Statistics, lambda::Float64, kernel::Union{Kernel,Nothing})
    if kernel === nothing
        kernel = LogisticKernel(lambda)
    else
        if hasproperty(kernel, :lambda)
            if kernel.lambda != lambda
                throw(RuntimeError("lambda mismatch!"))
            end
        end
    end
    kernel
end

function IRBasis(
    statistics::Statistics, lambda::Float64, eps=None;
    kernel::Union{Kernel,Nothing}=nothing,
    sve_result::Union{SVEResultType,Nothing}=nothing)

    kernel = get_kernel(statistics, lambda, kernel)
    if sve_result === nothing
        u, s, v = pysve.compute(self.kernel.o, eps)
    else
        u, s, v = sve_result
    end

    _even_odd = statistics == fermion ? (:odd) : (:even)

    IRBasis(
        u, hat(uhat, _even_odd, n_asymp=conv_radius(kernel)),
        v, s, statistics
    )
end
==#

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

function FiniteTempBasis(o::PyObject)
    return FiniteTempBasis(o.beta, o, o.u, o.uhat, o.v, o.s,
                           o.statistics == "F" ? fermion : boson,
                           o.size)
end

"""
Create a FiniteTempBasis object by decomposing a given kernel
"""
function FiniteTempBasis(kernel::KernelBase, statistics::Statistics, beta::Real,
                         eps::Union{Float64,Nothing}=nothing;
                         sve_result::Union{SVEResultType,Nothing}=nothing)
    if sve_result !== nothing
        sve_result = (sve_result[1].o, sve_result[2], sve_result[3].o)
    end
    o = sparse_ir.FiniteTempBasis(statistics == fermion ? "F" : "B", Float64(beta),
                                  Float64(kernel.o.lambda_ / beta); eps=eps,
                                  kernel=kernel.o, sve_result=sve_result)
    return FiniteTempBasis(o)
end

function FiniteTempBasis(statistics::Statistics, beta::Real, wmax::Real,
                         eps::Union{Float64,Nothing}=nothing
                         ;
                         kernel::Union{KernelBase,Nothing}=nothing,
                         sve_result::Union{SVEResultType,Nothing}=nothing)
    kernel_py = kernel !== nothing ? kernel.o : nothing
    stat = statistics == fermion ? "F" : "B"
    if eps !== nothing
        eps > 1.6e-8 || error("xprec is not supported yet.")
    end
    if sve_result !== nothing
        sve_result = (sve_result[1].o, sve_result[2], sve_result[3].o)
    end
    o = sparse_ir.FiniteTempBasis(stat, Float64(beta), Float64(wmax); eps=eps,
                                  kernel=kernel_py, sve_result=sve_result)
    return FiniteTempBasis(o)
end

"""
Create a FiniteTempBasis object using LogisticKernel
"""
function FiniteTempBasis(beta::Real,
                         wmax::Real,
                         statistics::Statistics,
                         eps::Union{Float64,Nothing})
    return FiniteTempBasis(LogisticKernel(Float64(beta * wmax)), statistics, Float64(beta),
                           eps)
end

"""
Construct FiniteTempBasis objects for fermion and bosons using
the same LogisticKernel instance.
"""
function finite_temp_bases(beta::Real, wmax::Real, eps::Real,
                           sve_result::Union{SVEResultType,Nothing}=nothing)::Tuple{FiniteTempBasis,
                                                                                    FiniteTempBasis}
    if sve_result !== nothing
        sve_result = (sve_result[1].o, sve_result[2], sve_result[3].o)
    end
    basis_f, basis_b = sparse_ir.basis.finite_temp_bases(Float64(beta),
                                                         Float64(wmax),
                                                         Float64(eps),
                                                         sve_result)
    return (FiniteTempBasis(basis_f), FiniteTempBasis(basis_b))
end

function default_omega_sampling_points(basis::FiniteTempBasis)::Vector{Float64}
    return basis.o.default_omega_sampling_points()
end

function default_tau_sampling_points(basis::FiniteTempBasis)::Vector{Float64}
    return basis.o.default_tau_sampling_points()
end

function default_matsubara_sampling_points(basis::FiniteTempBasis)::Vector{Int64}
    return basis.o.default_matsubara_sampling_points()
end

function Base.getproperty(basis::FiniteTempBasis, d::Symbol)
    if d === :sve_result
        u_py, s::Matrix{ComplexF64}, v_py = getfield(basis, :o).sve_result
        u = PiecewiseLegendrePoly(u_py)
        v = PiecewiseLegendrePoly(v_py)
        return u, s, v
    else
        return getfield(basis, d)
    end
end

function Base.propertynames(basis::FiniteTempBasis, private::Bool=false)
    return (:sve_result,
            fieldnames(FiniteTempBasis)...)
end

import LinearAlgebra: svd

######### DecomposedMatrix ########

"""
Matrix in SVD decomposed form for fast and accurate fitting.

Stores a matrix ``A`` together with its thin SVD form::

    A == (u * s) * vH.

This allows for fast and accurate least squares fits using ``lstsq(A, x)``.
"""
struct DecomposedMatrix{T}
    a::Matrix{T}
    uH::Matrix{T}
    s::Vector{Float64}
    v::Matrix{T}
end

function DecomposedMatrix{T}(
        a::Matrix{T},
        svd_result::Union{Tuple{Matrix{T},Vector{Float64},Matrix{T}},Nothing} = nothing
    ) where T
    if svd_result === nothing
        F = svd(a)
        uH, s, v = collect(F.U'), F.S, collect(F.V)
    else
        u, s, vH = svd_result
        uH = collect(u')
        v = collect(vH')
    end
    DecomposedMatrix(a, uH, s, v)
end

function _move_axis(arr::Array{T,N}, src::Int, dst::Int)::Array{T,N} where {T, N}
    """
    Move the axis at src to dst with keeping the order of the rest axes unchanged.

    src=1, dst=2, N=4, perm=[2, 1, 3, 4]
    src=2, dst=4, N=4, perm=[1, 3, 4, 2]
    """
    if src == dst
        return arr
    end
    perm = collect(1:N)
    deleteat!(perm, src)
    insert!(perm, dst, src)
    permutedims(arr, perm)
end

"""
Apply a matrix operator to an array along a given axis
"""
function _matop_along_axis(op::Matrix{T}, arr::Array{S,N}, axis::Int64) where {T, S, N}
    # Move the target axis to the first position
    if axis < 0 || axis > N
        throw(DomainError("axis must be in [1,N]"))
    end
    if size(arr)[axis] != size(op)[2]
        error("Dimension mismatch!")
    end

    arr = _move_axis(arr, axis, 1)
    _move_axis(_matop(op, arr), 1, axis)
end

function _matop(op::Matrix{T}, arr::Array{S,N}) where {T, S, N}
    # Apply op to the first axis of an array
    if size(arr)[1] != size(op)[2]
        error("Dimension mismatch!")
    end
    if N == 1
        return op * arr
    end

    rest_dims = size(arr)[2:end]
    arr = reshape(arr, (size(op)[2], prod(rest_dims)))
    reshape(op * arr, (size(op)[1], rest_dims...))
end

function matmul(matrix::DecomposedMatrix, al::Array{T,N}, axis::Int64)::Array{ComplexF64,N} where {T, N}
    _matop_along_axis(matrix.a, al, axis)
end

function lstsq(matrix::DecomposedMatrix, ax::Array{T,N}, axis::Int64)::Array{ComplexF64,N} where {T, N}
    ax = _move_axis(ax, axis, 1)
    r = _matop(matrix.uH, ax)
    for j = 1:size(r, 2)
        for i = 1:size(r, 1)
            r[i,j] /= matrix.s[i]
        end
    end
    res = _matop(matrix.v, r)
    _move_axis(res, 1, axis)
end

cond(a::DecomposedMatrix) = a.s[1]/a.s[length(a.s)]

############# Sampling ############
"""Base class for sparse sampling.

Encodes the "basis transformation" of a propagator from the truncated IR
basis coefficients ``G_ir[l]`` to time/frequency sampled on sparse points
``G(x[i])`` together with its inverse, a least squares fit::

         ________________                   ___________________
        |                |    evaluate     |                   |
        |     Basis      |---------------->|     Value on      |
        |  coefficients  |<----------------|  sampling points  |
        |________________|      fit        |___________________|


Attributes:
    basis: IR Basis instance
    matrix: Evaluation matrix is decomposed form
    sampling_points: Set of sampling points
"""
abstract type SamplingBase end

"""
Evaluate the basis coefficients at the sparse sampling points
"""
function evaluate(smpl::SamplingBase, al::Array{T,N}; axis::Int64=1)::Array{ComplexF64,N} where {T, N}
    matmul(smpl.matrix, al, axis)
end

"""
Fit basis coefficients from the sparse sampling points
"""
function fit(smpl::SamplingBase, ax::Array{T,N}; axis::Int64=1)::Array{ComplexF64,N} where {T, N}
    lstsq(smpl.matrix, ax, axis)
end

"""
Condition number of the fitting problem
"""
function cond(smpl::SamplingBase)::Float64 where {S}
    cond(smpl.matrix)
end

########### TauSampling ###########
"""
Sparse sampling in imaginary time.

Allows the transformation between the IR basis and a set of sampling points
in (scaled/unscaled) imaginary time.
"""
struct TauSampling <: SamplingBase
    basis::Basis
    sampling_points::Vector{Float64}
    matrix::DecomposedMatrix{Float64}
    cond::Float64
end


function TauSampling(basis::Basis, sampling_points::Union{Nothing,Vector{Float64}}=nothing)
    sampling_points = sampling_points === nothing ?
         default_tau_sampling_points(basis) : sampling_points
    mat_ = Matrix{Float64}(transpose(basis.u(sampling_points)))
    matrix = DecomposedMatrix{Float64}(mat_)
    TauSampling(basis, sampling_points, matrix, cond(matrix))
end


"""
Sampling points in (reduced) imaginary time
"""
function tau(smpl::TauSampling)
    return smpl.sampling_points
end


######## MatsubaraSampling ########
"""
Sampling in Matsubara frequency
"""
struct MatsubaraSampling <: SamplingBase
    basis::Basis
    sampling_points::Vector{Int64}
    matrix::DecomposedMatrix{ComplexF64}
    cond::Float64
end

function MatsubaraSampling(basis::Basis, sampling_points::Union{Nothing,Vector{Int64}}=nothing)
    sampling_points = sampling_points === nothing ?
         default_matsubara_sampling_points(basis) : sampling_points
    matrix = DecomposedMatrix{ComplexF64}(Matrix{ComplexF64}(transpose(basis.uhat(sampling_points))))
    MatsubaraSampling(basis, sampling_points, matrix, cond(matrix))
end
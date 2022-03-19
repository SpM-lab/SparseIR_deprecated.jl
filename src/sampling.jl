######### DecomposedMatrix ########
struct DecomposedMatrix
    o::PyObject
end

function DecomposedMatrix(a::Matrix{T}) where T
    DecomposedMatrix(pysampling.DecomposedMatrix(a))
end

function matmul(matrix::DecomposedMatrix, al::Array{T,N}, axis::Int64)::Array{ComplexF64,N} where {T, N}
    matrix.o.matmul(al, axis-1)
end

function lstsq(matrix::DecomposedMatrix, ax::Array{T,N}, axis::Int64)::Array{ComplexF64,N} where {T, N}
    matrix.o.lstsq(ax, axis-1)
end


############# Sampling ############
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
    smpl.matrix.cond
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
    matrix::DecomposedMatrix
end


function TauSampling(basis::Basis, sampling_points::Union{Nothing,Vector{Float64}}=nothing)
    sampling_points = sampling_points === nothing ?
         default_tau_sampling_points(basis) : sampling_points
    mat_ = Matrix{Float64}(transpose(basis.u(sampling_points)))
    matrix = DecomposedMatrix(mat_)
    TauSampling(basis, sampling_points, matrix)
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
    matrix::DecomposedMatrix
end

function MatsubaraSampling(basis::Basis, sampling_points::Union{Nothing,Vector{Int64}}=nothing)
    sampling_points = sampling_points === nothing ?
         default_matsubara_sampling_points(basis) : sampling_points
    matrix = DecomposedMatrix(Matrix{ComplexF64}(transpose(basis.uhat(sampling_points))))
    MatsubaraSampling(basis, sampling_points, matrix)
end
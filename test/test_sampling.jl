using SparseIR
using Test

import PyCall: pyimport, PyNULL, PyVector

irbasis3 = pyimport("irbasis3")

test_params = [
    (SparseIR.KernelFFlat, irbasis3.KernelFFlat, fermion),
    (SparseIR.KernelBFlat, irbasis3.KernelBFlat, boson)
]

@testset "sampling.MatsubaraSampling" begin
    lambda_ = 10.0
    wmax = 1.0
    eps = 1e-7
    beta = lambda_/wmax
    for (K, K_py, stat) in test_params
        basis_jl = FiniteTempBasis(K(lambda_), stat, beta, eps)
        smp_matsu_jl = SparseIR.MatsubaraSampling(basis_jl)

        stat_str = Dict(fermion => "F", boson => "B")[stat]
        basis_py = irbasis3.FiniteTempBasis(K_py(lambda_), stat_str, beta, eps)
        smp_matsu_py = irbasis3.MatsubaraSampling(basis_py)

        @test all(smp_matsu_jl.sampling_points .== smp_matsu_py.sampling_points)
    end
end
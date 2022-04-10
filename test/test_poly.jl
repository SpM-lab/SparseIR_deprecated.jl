using SparseIR
using Test
using LinearAlgebra

import PyCall: pyimport, PyNULL, PyVector

@testset "poly.getitem" begin
    lambda = 10.0
    beta = 1.0
    basis = FiniteTempBasis(LogisticKernel(lambda), fermion, beta)
    u = basis.u
    @test u[1](0.0) ≈ u.o.__getitem__(0)(0.0)
end

@testset "poly.overlap" begin
    lambda = 10.0
    beta = 1.0
    basis = FiniteTempBasis(LogisticKernel(lambda), fermion, beta)
    f = x -> 2 * x
    @test overlap(basis.u[1], f) isa Float64

    overlap_res = Matrix{Float64}(undef, size(basis), size(basis))
    for j in 1:size(basis), i in 1:size(basis)
        overlap_res[i, j] = overlap(basis.u[i], basis.u[j])
    end
    @test overlap_res ≈ Matrix(I, size(basis), size(basis))

    # Some topy spectral function
    gaussian(x, mu, sigma) = exp.(-((x .- mu) / sigma) .^ 2) / (sqrt(π) * sigma)
    function rho(omega)
        return 0.2 * gaussian(omega, 0.0, 0.15) +
               0.4 * gaussian(omega, 1.0, 0.8) + 0.4 * gaussian(omega, -1.0, 0.8)
    end

    rhol = overlap(basis.v, rho)
end
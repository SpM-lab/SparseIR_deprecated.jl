using SparseIR
using Test

import PyCall: pyimport, PyNULL, PyVector

sparse_ir = pyimport("sparse_ir")

@testset "basis.FiniteTempBasis" begin
    lambda_ = 10.0
    beta = 1.0
    eps = 1e-5
    wmax = lambda_/beta
    kernels = [SparseIR.KernelFFlat, SparseIR.KernelBFlat]

    # test points
    taus = collect(range(0, beta, length=100))
    omegas = collect(range(-wmax, -wmax, length=10))

    for K in kernels, stat in [fermion, boson]
        shift = (stat==fermion ? 1 : 0)
        v = 2 .* [-1, 1, 100, 1000] .+ shift

        k = K(lambda_)
        basis = FiniteTempBasis(k, stat, beta, eps)
        basis_py = sparse_ir.FiniteTempBasis(k.o, stat, beta, eps)
        @test all(basis.u(taus) .== basis_py.u(taus))
        @test all(basis.v(omegas) .== basis_py.v(omegas))
        @test all(basis.uhat(v) .== basis_py.uhat(v))
        @test basis.statistics == stat
        @test basis.size == basis_py.size
        @test size(basis) == basis_py.size

        for l in 1:size(basis)
            @test all(basis.u[l](taus) .== basis_py.u[l-1](taus))
            @test all(basis.uhat[l](v) .== basis_py.uhat[l-1](v))
        end
    end
end


@testset "basis.FiniteTempBasisInt" begin
    lambda = 10
    beta = 1
    basis = FiniteTempBasis(KernelFFlat(lambda), fermion, beta, 1e-5)
    @test basis isa FiniteTempBasis
end

@testset "basis.FiniteTempBasisDefaultEPS" begin
    lambda = 10
    beta = 1
    basis = FiniteTempBasis(KernelFFlat(lambda), fermion, beta)
    @test basis isa FiniteTempBasis
end
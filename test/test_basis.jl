using IRBasis3
using Test

import PyCall: pyimport, PyNULL, PyVector

irbasis3 = pyimport("irbasis3")


@testset "basis.FiniteTempBasis" begin
    lambda_ = 10.0
    beta = 1.0
    eps = 1e-8
    wmax = lambda_/beta
    kernels = [IRBasis3.KernelFFlat, IRBasis3.KernelBFlat]

    # test points
    taus = collect(range(0, beta, length=100))
    omegas = collect(range(-wmax, -wmax, length=10))

    for K in kernels, stat in [fermion, boson]
        shift = (stat==fermion ? 1 : 0)
        v = 2 .* [-1, 1, 100, 1000] .+ shift

        k = K(lambda_)
        basis = FiniteTempBasis(k, stat, beta, eps)
        basis_py = irbasis3.FiniteTempBasis(k.o, stat, beta, eps)
        @test all(basis.u(taus) .== basis_py.u(taus))
        @test all(basis.v(omegas) .== basis_py.v(omegas))
        @test all(basis.uhat(v) .== basis_py.uhat(v))
    end
end
using SparseIR
using Test
using LinearAlgebra

import PyCall: pyimport, PyNULL, PyVector

@testset "poly.overlap" begin
    lambda = 10.0
    beta = 1.0
    basis = FiniteTempBasis(KernelFFlat(lambda), fermion, beta)
    f = x::Array{Float64}->2*x
    @test overlap(basis.u, f) isa Array{Float64}

    @test overlap(basis.u, basis.u) ≈ Matrix(I, size(basis), size(basis))

    # Some topy spectral function
    gaussian(x, mu, sigma) = exp.(-((x.-mu)/sigma).^2)/(sqrt(π)*sigma)
    rho(omega) = 0.2*gaussian(omega, 0.0, 0.15) + 
       0.4*gaussian(omega, 1.0, 0.8) + 0.4*gaussian(omega, -1.0, 0.8)
    
    rhol = overlap(basis.v, rho)
end